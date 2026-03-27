.PHONY: help build install install-launcher uninstall clean all

# Default target
help:
	@echo "Kiro IDE Flatpak Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make build            - Build the Flatpak"
	@echo "  make install          - Build and install the Flatpak"
	@echo "  make install-launcher - Install 'kiro' command to /usr/local/bin"
	@echo "  make all              - Build, install Flatpak, and install launcher"
	@echo "  make uninstall        - Uninstall the Flatpak"
	@echo "  make clean            - Clean build artifacts"
	@echo ""

# Build the Flatpak
build:
	@echo "Building Kiro IDE Flatpak..."
	flatpak-builder --force-clean build-dir kiro-ide.yaml

# Build and install the Flatpak
install:
	@echo "Building and installing Kiro IDE Flatpak..."
	flatpak-builder --user --install --force-clean build-dir kiro-ide.yaml
	@echo ""
	@echo "✓ Kiro IDE Flatpak installed successfully!"
	@echo "  Run with: flatpak run dev.kiro.KiroIDE"
	@echo "  Or install launcher with: make install-launcher"

# Install the kiro launcher script to PATH
install-launcher:
	@echo "Installing 'kiro' launcher to ~/.local/bin..."
	@if [ ! -f kiro ]; then \
		echo "Error: kiro launcher script not found!"; \
		exit 1; \
	fi
	mkdir -p ~/.local/bin
	cp kiro ~/.local/bin/kiro
	chmod +x ~/.local/bin/kiro
	@echo "✓ Launcher installed to ~/.local/bin/kiro"
	@echo "  Make sure ~/.local/bin is in your PATH."

# Build, install Flatpak, and install launcher
all: install install-launcher
	@echo ""
	@echo "✓ Complete! Kiro IDE is ready to use."
	@echo "  Run from terminal: kiro"
	@echo "  Or from desktop: Launch 'Kiro IDE' from your application menu"

# Uninstall the Flatpak
uninstall:
	@echo "Uninstalling Kiro IDE Flatpak..."
	flatpak uninstall --user dev.kiro.KiroIDE
	@echo "✓ Kiro IDE Flatpak uninstalled."
	@echo ""
	@echo "To remove the launcher, run:"
	@echo "  rm ~/.local/bin/kiro"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf build-dir .flatpak-builder
	@echo "✓ Build artifacts cleaned."
