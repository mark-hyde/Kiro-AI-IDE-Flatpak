.PHONY: help bump install uninstall clean

TARBALL := $(wildcard kiro-ide-*-stable-linux-x64.tar.gz)

# Default target
help:
	@echo "Kiro IDE Flatpak Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make bump      - Point kiro-ide.yaml at the newest downloaded tarball"
	@echo "  make install   - Bump, then build and install the Flatpak and 'kiro' launcher"
	@echo "  make uninstall - Uninstall the Flatpak and remove 'kiro' launcher"
	@echo "  make clean     - Clean build artifacts"
	@echo ""

# Update the manifest to reference the newest downloaded Kiro IDE tarball
bump:
	@./bump-version.sh

# Build and install the Flatpak and launcher
install: bump
	@if [ -z "$(TARBALL)" ]; then \
		echo "Error: No Kiro IDE tarball found!"; \
		echo "Download from https://kiro.dev/downloads/ and place in this directory."; \
		exit 1; \
	fi
	@echo "Building and installing Kiro IDE Flatpak..."
	flatpak-builder --user --install --force-clean build-dir kiro-ide.yaml
	@mkdir -p ~/.local/bin
	@cp kiro ~/.local/bin/kiro
	@chmod +x ~/.local/bin/kiro
	@echo ""
	@echo "✓ Kiro IDE installed successfully!"
	@echo "  Run from terminal: kiro"
	@echo "  Or from desktop: Launch 'Kiro IDE' from your application menu"
	@echo "  Make sure ~/.local/bin is in your PATH."

# Uninstall the Flatpak and remove launcher
uninstall:
	@echo "Uninstalling Kiro IDE..."
	flatpak uninstall --user dev.kiro.KiroIDE
	@rm -f ~/.local/bin/kiro
	@echo "✓ Kiro IDE uninstalled."

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build-dir .flatpak-builder
	@echo "✓ Build artifacts cleaned."
