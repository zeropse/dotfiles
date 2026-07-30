# Homebrew Upgrade Tool

A comprehensive, modular Homebrew maintenance tool designed for reliable system updates with enhanced error handling, clean logging, progress reporting, and professional user experience.

---

## 📦 Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

### Manual / Local Installation (Development)

1. Clone or download the repository:

   ```bash
   git clone https://github.com/zeropse/dotfiles.git
   cd dotfiles/homebrew
   ```

2. Run the installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

### Installation Directory Structure

```
~/.scripts/
├── brew-upgrade -> homebrew-upgrade/brew-upgrade.sh  # Symlink shortcut
└── homebrew-upgrade/                                 # Tool directory
    ├── brew-upgrade.sh                               # Main entry point
    └── lib/                                          # Modular libraries
        ├── cli.sh                                    # CLI argument parser
        ├── config.sh                                 # Global configuration & constants
        ├── logger.sh                                 # Terminal logging & TTY spinner
        ├── self_mgmt.sh                              # Updater & uninstaller modules
        ├── steps.sh                                  # Maintenance step implementations
        ├── summary.sh                                # Dashboard & progress statistics
        └── utils.sh                                  # Subshell & system utilities
```

---

## 🚀 Usage

Run the tool at any time from your terminal:

```bash
brew-upgrade
```

### Options

| Flag          | Description                                              |
| :------------ | :------------------------------------------------------- |
| `--help`      | Display usage information and exit                       |
| `--update`    | Self-update the tool to the latest version from GitHub   |
| `--uninstall` | Safely remove the tool and its shortcut from your system |

---

## 🔄 What It Does

The tool executes a streamlined, 9-step Homebrew maintenance pipeline:

1. **Update Homebrew Index** - Runs `brew update` to refresh formulae index and tap manifests.
2. **System Health Check** - Runs `brew doctor` to check for core conflicts or environment warnings.
3. **Analyze Outdated Packages** - Identifies and caches outdated formulae and casks in a single pass.
4. **Upgrade Formulae** - Upgrades all outdated CLI tools and libraries (`brew upgrade --formula`).
5. **Upgrade Casks** - Upgrades outdated GUI applications individually with per-cask error isolation.
6. **Check Dependencies** - Verifies package integrity (`brew missing`).
7. **Remove Unused Dependencies** - Autoremoves orphaned dependencies (`brew autoremove`).
8. **Final Cleanup** - Clears download caches and stale locks (`brew cleanup -s`).
9. **Final Health Check** - Re-runs `brew doctor` to confirm post-maintenance system health.

---

## 🔄 Updating the Tool

To update the tool to the latest release:

```bash
brew-upgrade --update
```

---

## 🗑️ Uninstallation

To remove the tool cleanly:

```bash
brew-upgrade --uninstall
```

---

## 🏗️ Architecture & Features

- **Strict Include Guards**: Prevents duplicate sourcing and variable collision across shell modules.
- **Clean File Logging**: Strips ANSI terminal color codes before writing to `~/.brew-maintenance.log` so logs stay clean and readable.
- **TTY-Aware Progress**: Renders smooth animated spinners on interactive terminals while keeping piped/background execution silent.
- **Cached Package Evaluation**: Minimizes repetitive, slow `brew outdated` calls.
- **Non-blocking Error Recovery**: Isolated cask upgrades ensure single failed cask downloads won't block the rest of your system updates.

---

## 📋 Requirements

- **macOS** (Intel or Apple Silicon)
- **Homebrew** installed and in `PATH`
- **Bash 4.0+** or **Zsh**
- **Standard Unix Tools**: `curl`, `tar`, `mkdir`

---

## 🤝 Contributing

Contributions and feedback are welcome!

1. Fork the repository.
2. Create a feature branch.
3. Submit a pull request.
