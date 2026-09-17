#!/bin/bash
export GTK_MODULES=
# Suppress update check logs
export ELECTRON_NO_ATTACH_CONSOLE=1

# Ensure pipx directories exist on first run
mkdir -p "${PIPX_HOME:-$HOME/.local/share/pipx}"/venvs
mkdir -p "${PIPX_HOME:-$HOME/.local/share/pipx}"/shared

exec /app/Kiro/kiro --no-sandbox "$@" > /dev/null 2>&1
