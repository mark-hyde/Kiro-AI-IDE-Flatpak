#!/bin/bash
# Update kiro-ide.yaml to reference the newest downloaded Kiro IDE tarball.
#
# - Detects the newest kiro-ide-*-stable-linux-x64.tar.gz in this directory
#   (by version number, not mtime).
# - Rewrites both tarball references in kiro-ide.yaml (the tar extract command
#   and the sources path).
# - Verifies the icon source path in the manifest still exists in the tarball.
#   Since Kiro 1.0.4xx, node_modules is packed as node_modules.asar, so icons
#   that used to live under node_modules are no longer directly copyable. If the
#   configured icon is missing, this script suggests known-good alternatives.
#
# Usage: ./bump-version.sh [version]
#   With no argument, picks the highest version tarball present.
#   With an argument (e.g. 1.0.437), targets that specific tarball.

set -euo pipefail

MANIFEST="kiro-ide.yaml"
PREFIX="kiro-ide-"
SUFFIX="-stable-linux-x64.tar.gz"

cd "$(dirname "$0")"

if [ ! -f "$MANIFEST" ]; then
    echo "Error: $MANIFEST not found in $(pwd)" >&2
    exit 1
fi

# Determine target tarball
if [ $# -ge 1 ]; then
    VERSION="$1"
    TARBALL="${PREFIX}${VERSION}${SUFFIX}"
else
    # Pick highest version via version sort
    TARBALL="$(ls ${PREFIX}*${SUFFIX} 2>/dev/null | sort -V | tail -n1 || true)"
    if [ -z "$TARBALL" ]; then
        echo "Error: no ${PREFIX}*${SUFFIX} tarball found in $(pwd)" >&2
        exit 1
    fi
    VERSION="${TARBALL#$PREFIX}"
    VERSION="${VERSION%$SUFFIX}"
fi

if [ ! -f "$TARBALL" ]; then
    echo "Error: $TARBALL does not exist in $(pwd)" >&2
    exit 1
fi

echo "Target tarball: $TARBALL (version $VERSION)"

# Current tarball referenced in the manifest
CURRENT="$(grep -oE "${PREFIX}[0-9.]+${SUFFIX}" "$MANIFEST" | head -n1 || true)"
if [ -n "$CURRENT" ] && [ "$CURRENT" != "$TARBALL" ]; then
    echo "Updating manifest: $CURRENT -> $TARBALL"
    # Replace every occurrence of the old tarball name
    sed -i "s|${CURRENT}|${TARBALL}|g" "$MANIFEST"
elif [ "$CURRENT" = "$TARBALL" ]; then
    echo "Manifest already references $TARBALL. No change needed."
else
    echo "Warning: could not find an existing tarball reference in $MANIFEST" >&2
fi

# Verify the icon source path still exists in the tarball.
# Note: this is a best-effort advisory check. If listing the tarball fails
# (some sandboxed environments misbehave with piped tar output), we skip the
# check rather than block the build.
ICON_SRC="$(grep -oE '/app/Kiro/[^ ]+\.(svg|png)' "$MANIFEST" | head -n1 || true)"
if [ -n "$ICON_SRC" ]; then
    # Strip the /app/ prefix; entries in the tarball are prefixed with "Kiro/"
    ICON_IN_TAR="${ICON_SRC#/app/}"
    LIST_FILE="$(mktemp)"
    trap 'rm -f "$LIST_FILE"' EXIT

    if tar -tzf "$TARBALL" > "$LIST_FILE" 2>/dev/null && [ -s "$LIST_FILE" ]; then
        if grep -qxF "$ICON_IN_TAR" "$LIST_FILE"; then
            echo "Icon source OK: $ICON_IN_TAR"
        else
            echo "" >&2
            echo "WARNING: configured icon '$ICON_IN_TAR' is NOT present in $TARBALL." >&2
            echo "Icons inside node_modules are packed in node_modules.asar and cannot" >&2
            echo "be copied directly. Candidate .svg/.png replacements in this tarball:" >&2
            grep -iE '\.(svg|png)$' "$LIST_FILE" \
                | grep -iE 'kiro|code' \
                | grep -ivE 'node_modules|workbench/contrib/extensions|theme-icon|language-icon' \
                | sed 's|^|  |' >&2 || true
            echo "" >&2
            echo "Update the 'cp ... dev.kiro.KiroIDE.svg' line in $MANIFEST to one of the above," >&2
            echo "then re-run this script." >&2
            exit 1
        fi
    else
        echo "Note: could not list $TARBALL to verify the icon path; skipping icon check." >&2
        echo "      Configured icon: $ICON_IN_TAR" >&2
    fi
fi

echo "Done. Manifest now targets Kiro $VERSION."
