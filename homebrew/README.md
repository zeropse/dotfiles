# Homebrew Upgrade Tool

A comprehensive, modular Homebrew maintenance tool designed for reliable system updates with enhanced error handling, beautiful progress reporting, and professional user experience.

## 📦 Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

Then reload the terminal.


### Manual Installation

1. Download the installer:

   ```bash
   curl -O https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh
   ```

2. Make it executable and run:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

### Local Installation (Development)

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles/homebrew
./install.sh
```

### Installation Directory Structure

```
~/.scripts/
├── brew-upgrade                 # Symlink to main script
└── homebrew-upgrade/           # Installation directory
    ├── brew-upgrade.sh         # Main script
    └── lib/                    # Library modules
        ├── cli.sh              # Command-line interface
        ├── common.sh           # Shared functions and configuration
        ├── config.sh           # Configuration management
        ├── logger.sh           # Logging utilities
        ├── steps.sh            # Maintenance steps
        ├── summary.sh          # Summary generation
        └── utils.sh            # Utility functions
```

### Installation Options

The installer supports the following options:

- **Interactive mode** (default): Shows a confirmation prompt with details about what will be installed
- **Help** (`--help` or `-h`): Shows usage information and exits

## 🔄 What It Does

The tool performs comprehensive Homebrew maintenance:

1. **Initial Cleanup** - Remove broken symlinks and stale locks
2. **System Health Check** - Run `brew doctor`
3. **Update Homebrew** - Update core and formulae
4. **Analyze Outdated Packages** - Check what needs updating
5. **Upgrade Formulae** - Update tools/libraries
6. **Upgrade Casks** - Update GUI apps
7. **Check Dependencies** - Verify integrity
8. **Remove Unused Dependencies** - Autoremove orphans
9. **Final Cleanup** - Clear caches

### **Beautiful Interface**

- **Colorized output** with clear status indicators
- **Progress tracking** with step-by-step reporting
- **Professional banners** and completion summaries
- **Detailed statistics** and performance metrics
- **Clean, readable help system**
- **Modern Unicode symbols** for better visual feedback

### **Self-Management**

- **Built-in uninstaller** - Remove tool cleanly
- **Smart updates** - Update existing installations
- **Modular installation** - Preserve user customizations
- **Clean removal** - Optional cleanup of empty directories

## 🗑️ Uninstallation

Use the built-in uninstaller:

```bash
brew-upgrade --uninstall
```

This will safely remove the tool from your system with confirmation prompts and:

- Remove the installation directory
- Remove the command shortcut
- Optionally remove empty .scripts directory (with confirmation)
- Provide completion message

## 🔄 Updates

Use the built-in updater:

```bash
brew-upgrade --update
```

This will download and install the latest version while preserving your configuration and:

- Create automatic backup of current installation
- Download latest version from repository
- Update all tool files
- Verify installation integrity
- Show backup location for safety

## 📋 Requirements

- **macOS** (Intel or Apple Silicon)
- **Homebrew** installed and configured
- **Bash 4.0+** (included in modern macOS)
- **Standard Unix tools** (curl, tar, mkdir)

## 🐛 Troubleshooting

### Common Issues

**Command not found after installation:**

- Make sure `~/.scripts` is in your PATH
- Restart your terminal or run `source ~/.zshrc` (or `~/.bashrc`)
- Add to PATH: `echo 'export PATH="$HOME/.scripts:$PATH"' >> ~/.zshrc`

**Permission errors:**

- The installer handles permissions automatically
- If issues persist: `chmod +x ~/.scripts/homebrew-upgrade/brew-upgrade.sh`

**Installation fails:**

- Check internet connection
- Verify Homebrew: `brew --version`
- Try manual installation method

**Script fails with "Homebrew not found":**

- Ensure Homebrew is properly installed
- Check that `brew` command is in your PATH
- Try running `brew --version` manually

**Cask upgrades fail:**

- Individual cask failures don't stop the process
- Check specific cask issues in the log file
- Some casks require manual intervention

**brew doctor reports issues:**

- Review the specific warnings/errors
- The tool will continue despite issues automatically
- Address underlying problems when possible

### Getting Help

When reporting issues, please include:

- **Operating system** and version
- **Homebrew version** (`brew --version`)
- **Full command used** and options
- **Log file contents** from the tool
- **Error messages** (copy exactly)

## 🏗️ Architecture

### Modular Design

The tool uses a clean modular architecture:

- **`brew-upgrade.sh`** - Main entry point and orchestration
- **`lib/config.sh`** - Configuration constants and variables
- **`lib/logger.sh`** - Logging functions and output formatting
- **`lib/utils.sh`** - Common utilities and helper functions
- **`lib/cli.sh`** - Command-line parsing and help system
- **`lib/steps.sh`** - Individual maintenance step implementations
- **`lib/summary.sh`** - Summary generation and reporting

### Error Handling Strategy

- **Fails fast** on critical errors (Homebrew missing, update failures)
- **Continues gracefully** on non-critical issues (individual package failures)
- **Automatic handling** of doctor warnings and cleanup issues
- **Logs everything** for post-execution review
- **Clean exit** with proper resource cleanup

### Performance Optimizations

- **Parallel operations** where safely possible
- **Intelligent step skipping** based on system state
- **Efficient cleanup** with selective operations
- **Minimal redundancy** in checks and operations

## 🤝 Contributing

Contributions are welcome! This script is part of a personal dotfiles collection but improvements benefit everyone:

1. **Fork the repository**
2. **Create a feature branch**
3. **Test thoroughly** on different macOS versions
4. **Maintain backward compatibility** where possible
5. **Follow existing code style** and patterns
6. **Update documentation** for any changes
7. **Consider edge cases** and error scenarios
8. **Submit a pull request**

---
