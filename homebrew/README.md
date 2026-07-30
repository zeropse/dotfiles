# 🍺 Homebrew Upgrade Tool

<p align="left">
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS Supported">
  <img src="https://img.shields.io/badge/Homebrew-v4.0+-FDEE21?style=for-the-badge&logo=homebrew&logoColor=black" alt="Homebrew Supported">
  <img src="https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell Supported">
</p>

A powerful, modular, and reliable **Homebrew Maintenance & Upgrade Tool** for macOS. Designed for developers who want automated system health checks, cached outdated package checks, clean background logging, and zero terminal clutter.

---

## ⚡ Quick Start

### One-Line Installation (Recommended)

Run the installer directly from your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

> **Note:** Reload your shell after installing (`source ~/.zshrc` or `source ~/.bashrc`), then run `brew-upgrade`.

---

## ✨ Key Features

- **🚀 Faster Performance**: Single-pass package evaluation caches outdated formulae and casks into memory to eliminate redundant `brew outdated` calls.
- **🎨 Interactive Terminal UI**: Beautiful progress bar (`[████████░░] 88%`) and smooth animated spinners when interactive, with quiet fallback for background scripts.
- **🧹 Clean Log Output**: ANSI terminal color codes are automatically stripped before saving to `~/.brew-maintenance.log` so log files remain clean plain text.
- **🛡️ Isolated Cask Upgrades**: Upgrades GUI casks individually so a single network/checksum failure on one cask won't block the rest of your system updates.
- **⚙️ Strict Module Architecture**: All sub-scripts are protected with include guards (`_BREW_CONFIG_SH_`, etc.) to prevent duplicate sourcing and variable collisions.
- **🔄 Built-in Self-Management**: Effortlessly update (`--update`) or cleanly uninstall (`--uninstall`) the tool at any time.

---

## 🚀 Usage & Options

Once installed, simply run:

```bash
brew-upgrade
```

### Command-Line Options

| Option         | Description                                                 |
| :------------- | :---------------------------------------------------------- |
| `-h`, `--help` | Show usage instructions and exit                            |
| `--update`     | Self-update the tool to the latest release from GitHub      |
| `--uninstall`  | Completely remove the tool, shortcut, backups, and log file |

### Example CLI Help

```text
Homebrew Upgrade Tool
Comprehensive Homebrew maintenance and system upgrade script.

USAGE:
    brew-upgrade [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    --update            Update the Homebrew Upgrade Tool to the latest version
    --uninstall         Remove the Homebrew Upgrade Tool from your system

EXAMPLES:
    brew-upgrade               Run full Homebrew maintenance
    brew-upgrade --help        Show usage information
    brew-upgrade --update      Self-update the tool
    brew-upgrade --uninstall   Remove the tool
```

---

## 🔄 What It Does

When you run `brew-upgrade`, the script executes a 9-step maintenance sequence:

1. **Update Homebrew Index** (`brew update`) - Refreshes core formula index and tap manifests.
2. **System Health Check** (`brew doctor`) - Inspects environment configuration for warnings.
3. **Analyze Outdated Packages** - Evaluates and caches outdated CLI tools and GUI casks in a single pass.
4. **Upgrade Formulae** (`brew upgrade --formula`) - Upgrades all outdated CLI libraries.
5. **Upgrade Casks** (`brew upgrade --cask`) - Upgrades GUI applications with per-cask error isolation.
6. **Check Dependencies** (`brew missing`) - Verifies broken or missing package links.
7. **Remove Unused Dependencies** (`brew autoremove`) - Cleans up orphaned dependencies no longer needed.
8. **Final Cleanup** (`brew cleanup -s`) - Removes stale download caches, old bottle versions, and lockfiles.
9. **Final Health Check** (`brew doctor`) - Verifies final system health and reports elapsed execution time.

---

## 🏗️ Repository Architecture

```text
~/.scripts/
├── brew-upgrade -> homebrew-upgrade/brew-upgrade.sh  # Symlink shortcut
└── homebrew-upgrade/                                 # Installation directory
    ├── brew-upgrade.sh                               # Main executable entry point
    └── lib/                                          # Core modular libraries
        ├── cli.sh                                    # CLI flag parser & usage system
        ├── config.sh                                 # Global settings, TTY colors & exit codes
        ├── logger.sh                                 # TTY progress, spinner & log writer
        ├── self_mgmt.sh                              # Self-updater & uninstaller routines
        ├── steps.sh                                  # Implementation of maintenance steps 1-9
        ├── summary.sh                                # Execution dashboard & statistics
        └── utils.sh                                  # Subshell runner & line counting utilities
```

---

## 💻 Local Installation & Development

To clone and install locally for development:

1. Clone the repository:

   ```bash
   git clone https://github.com/zeropse/dotfiles.git
   cd dotfiles/homebrew
   ```

2. Make executable and run installer:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. Test syntax across all modules:
   ```bash
   bash -n brew-upgrade.sh && bash -n install.sh && bash -n lib/*.sh
   ```

---

## 🔄 Self-Management

### Updating the Tool

Keep your installation up to date with a single command:

```bash
brew-upgrade --update
```

_Creates an automatic timestamped backup (`~/.scripts/homebrew-upgrade.backup.YYYYMMDDHHMMSS`) before applying updates._

### Uninstalling the Tool

Remove the tool cleanly at any time:

```bash
brew-upgrade --uninstall
```

_Safely removes the `brew-upgrade` shortcut, log file `~/.brew-maintenance.log`, backup folders, and installation directory._

---

## ❓ FAQ & Troubleshooting

<details>
<summary><b>Where are logs saved?</b></summary>
Logs are written to <code>~/.brew-maintenance.log</code>. All terminal colors and control sequences are automatically stripped so the log file remains clean plain text.
</details>

<details>
<summary><b>What if a cask upgrade fails?</b></summary>
Cask upgrades run with per-cask error isolation. If a specific application download fails, the script logs a warning, skips that single cask, and continues upgrading the remaining applications.
</details>

<details>
<summary><b>Command not found after installation?</b></summary>
Ensure <code>~/.scripts</code> is included in your shell PATH:
<pre>echo 'export PATH="$HOME/.scripts:$PATH"' >> ~/.zshrc
source ~/.zshrc</pre>
</details>

---

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome!

1. Fork the repo.
2. Create your feature branch (`git checkout -b feature/amazing-feature`).
3. Commit changes (`git commit -m 'Add amazing feature'`).
4. Push to branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.

---

<p align="center">
  Crafted with ❤️ for macOS power users.
</p>
