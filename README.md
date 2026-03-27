# Kiro IDE Flatpak Packaging

> **Note:**  
> This is **not an official repository by AWS or the creators of Kiro IDE**.  
> It is created and supported by a Flatpak enthusiast to make Kiro IDE easier and safer to run on any Linux distribution.

---

## 🚀 Kiro IDE by AWS 

Kiro is an AI-powered integrated development environment that helps developers go from concept to production through spec-driven development, bridging the gap between rapid prototyping ("vibe coding") and production-ready systems.

### ✨ Key Features

**📋 Spec-Driven Development**  
Kiro transforms simple prompts into comprehensive technical artifacts including user stories with EARS notation, design documents with diagrams, and sequenced task lists that break down complex projects into manageable chunks.

**🤖 Agentic AI Capabilities**  
Built with an agentic reasoning loop that plans, reasons, takes actions, and evaluates results to handle multi-step tasks autonomously. Powered by Claude Sonnet 4.0 and 3.7 models for state-of-the-art AI operations.

**🔧 Kiro Hooks**  
Event-driven automation triggers that act like an experienced developer, catching issues and completing boilerplate tasks in the background when files are saved, created, or deleted.

**🔌 Built on Code OSS**  
Keep your VS Code settings and Open VSX compatible plugins while working with the full AI coding experience.

**🔒 Privacy & Security**  
All code execution happens locally, with transparent actions and data remaining on your machine unless explicitly shared.

### 🎯 What Makes It Unique

Unlike traditional AI coding assistants that focus primarily on code generation, Kiro emphasizes creating and maintaining project documentation, specs, and technical blueprints automatically as code evolves. It works agnostically with any technology stack and cloud provider, not just AWS.

**💡 Free during public preview** with some limits!  [Compare Kiro with Replit, Lovable, Bolt, Cursor and Windsurf](https://www.aiservices.review/review/ai-code-generators/top-6-vibe-coding-ai-tools-of-2025-replit-lovable-bolt-cursor-windsurf-kiro-compared)

## Why Use Flatpak?

**Flatpak** provides a secure, universal way to install Linux applications.  
Key benefits:
- **Sandboxing:** Apps run isolated from the rest of your system for improved security.
- **Universal install:** Works the same across all major Linux distributions.
- **Safe testing:** You can try out new or unstable apps without risking your system.
- **Easy updates and uninstalls:** Apps and their dependencies are managed independently.

If you're experimenting with new tools like Kiro IDE, Flatpak helps ensure any bugs or vulnerabilities in the app can't compromise your computer.

---

## Extensions Support

**Flatpak release of Kiro IDE** supports both VS Code Extensions and Specific Kiro Extensions which are supported by native distribution packages for Linux. If you experience a problem with support for specific extension you can identify an issue using a debugger within the Flatpak's sandboxed environment after installing the application's SDK, the Debug SDK, and the Debug extension for the application. [Learn more about debugging a Flatpak application](https://docs.flatpak.org/en/latest/debugging.html)

---

## Building and Installing Kiro IDE Flatpak

### 1. Clone This Repository

```bash
git clone https://github.com/AI-Services-Review/Kiro-AI-IDE-Flatpak.git
cd Kiro-AI-IDE-Flatpak
```

### 2. Download the Official Kiro IDE Distribution

Go to the [Kiro IDE website](https://kiro.dev/) and download the Linux version.  
Place the downloaded archive in your cloned repository directory (e.g., `kiro-ide-0.8.206-stable-linux-x64.tar.gz`).

**Note:** Update the filename in `kiro-ide.yaml` if your downloaded version differs from the one in this repository.

### 3. Make Sure Required Files Exist

Your project folder should now contain:
- `kiro-ide.yaml` (the Flatpak manifest)
- `git-wrapper.sh` (Git integration wrapper)
- `kiro-wrapper.sh` (Kiro launcher wrapper)
- `dev.kiro.KiroIDE.desktop` (desktop launcher file)
- `default-settings.json` (default Kiro settings)
- `kiro-ide-0.8.206-stable-linux-x64.tar.gz` (downloaded Kiro IDE distribution)

**Note:** The application icon is automatically extracted from the Kiro IDE tarball during build.

### 4. Install Flatpak and Flatpak Builder

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install flatpak flatpak-builder
```

**On Fedora:**
```bash
sudo dnf install flatpak flatpak-builder
```

### 5. Install Flatpak Runtimes

```bash
flatpak install flathub org.freedesktop.Platform//25.08
flatpak install flathub org.freedesktop.Sdk//25.08
```

### 6. Build and Install the Flatpak

**Using Make (recommended):**
```bash
make all
```

This will build the Flatpak, install it, and add the `kiro` command to your PATH.

**Or manually:**
```bash
flatpak-builder --user --install --force-clean build-dir kiro-ide.yaml
```

**Available Make targets:**
- `make help` - Show available commands
- `make build` - Build the Flatpak only
- `make install` - Build and install the Flatpak
- `make install-launcher` - Install `kiro` command to `/usr/local/bin`
- `make all` - Build, install Flatpak, and install launcher
- `make uninstall` - Uninstall the Flatpak
- `make clean` - Clean build artifacts

### 7. Run Kiro IDE

**From desktop:** Launch "Kiro IDE" from your application menu.

**From terminal:**
```bash
flatpak run dev.kiro.KiroIDE
```

**Or simply (if you ran `make all` or `make install-launcher`):**
```bash
kiro
```

---

## Python Support

This Flatpak includes **Python 3.10** with full pip and pipx support for Python development:

- **Python commands:** `python`, `python3`, `python3.10`
- **Package management:** `pip`, `pip3`, `pip3.10`, `pipx`
- **Isolated packages:** User-installed packages are isolated to the Flatpak environment

Install Python packages inside the Flatpak:
```bash
flatpak run --command=bash dev.kiro.KiroIDE
pip install --user <package-name>
```

---

## Updating Kiro IDE Flatpak

To update to a new Kiro IDE version:
1. Download the latest Linux tarball from the official site.
2. Replace the tarball in your project folder.
3. Update the filename in `kiro-ide.yaml` (two locations: tar command and source path).
4. Re-run the build and install command:
   ```bash
   flatpak-builder --user --install --force-clean build-dir kiro-ide.yaml
   ```

---

## Uninstalling

To remove Kiro IDE Flatpak from your system:

**Using Make:**
```bash
make uninstall
rm ~/.local/bin/kiro  # If you installed the launcher
```

**Or manually:**
```bash
flatpak uninstall dev.kiro.KiroIDE
rm ~/.local/bin/kiro  # If you installed the launcher
```

---

## Troubleshooting

- If you see errors about missing runtimes or dependencies, repeat step 5.
- If the icon does not appear, ensure the Kiro IDE tarball is present during build (icon is extracted automatically).
- For Git integration issues, verify that `git-wrapper.sh` is executable and `default-settings.json` points to `/app/bin/git`.

---

## Contributing

Improvements and bug fixes are welcome! Flatpak makes it safe and easy for anyone to help package and distribute Linux apps.
