.PHONY: help install uninstall clean

TARBALL := $(wildcard kiro-ide-*-stable-linux-x64.tar.gz)

# Default target
help:
	@echo "Kiro IDE Flatpak Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install   - Build and install the Flatpak and 'kiro' launcher"
	@echo "  make uninstall - Uninstall the Flatpak and remove 'kiro' launcher"
	@echo "  make clean     - Clean build artifacts"
	@echo ""

# Build and install the Flatpak and launcher
install:
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
