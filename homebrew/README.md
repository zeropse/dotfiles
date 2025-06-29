# Homebrew Upgrade Tool

A comprehensive, modular Homebrew maintenance tool designed for reliable system updates with enhanced error handling, beautiful progress reporting, and professional user experience.

## ✨ Features

### 🔧 **Comprehensive Maintenance**

- **Initial cleanup** - Remove broken symlinks and stale locks
- **System health checks** - Run `brew doctor` to identify issues
- **Package updates** - Update Homebrew itself and all formula definitions
- **Intelligent upgrades** - Update command-line tools, libraries, and GUI apps
- **Dependency management** - Check and remove unused dependencies
- **Final cleanup** - Remove old downloads and clear caches
- **Health verification** - Ensure everything works after maintenance

### 🛡️ **Robust Error Handling**

- **Strict error checking** with `set -euo pipefail`
- **Graceful cleanup** on script exit or interruption
- **Individual package handling** with failure isolation
- **Comprehensive error logging** and reporting
- **Force options** for continuing despite warnings
- **Smart recovery** from common issues

### 🎯 **Smart Configuration**

- **Dry-run mode** to preview all changes before execution
- **Modular architecture** with separated concerns
- **Flexible options** for skipping specific operations
- **Verbose logging** with detailed output control
- **Cross-platform support** (Intel and Apple Silicon)
- **Environment variable support** for automation

### 🎨 **Beautiful Interface**

- **Colorized output** with clear status indicators
- **Progress tracking** with step-by-step reporting
- **Professional banners** and completion summaries
- **Detailed statistics** and performance metrics
- **Clean, readable help system**
- **Modern Unicode symbols** for better visual feedback

### �️ **Self-Management**

- **Built-in uninstaller** - Remove tool cleanly
- **Smart updates** - Update existing installations
- **Modular installation** - Preserve user customizations
- **Clean removal** - Optional cleanup of empty directories

## 📦 Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

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
        ├── config.sh           # Configuration management
        ├── logger.sh           # Logging utilities
        ├── steps.sh            # Maintenance steps
        ├── summary.sh          # Summary generation
        └── utils.sh            # Utility functions
```

## 🔄 What It Does

The tool performs comprehensive Homebrew maintenance in this order:

1. **Initial Cleanup** - Remove broken symlinks and stale locks
2. **System Health Check** - Run `brew doctor` to identify issues
3. **Update Homebrew** - Update Homebrew itself and formula definitions
4. **Analyze Outdated Packages** - Check what needs updating
5. **Upgrade Formulae** - Update command-line tools and libraries
6. **Upgrade Casks** - Update GUI applications (if not skipped)
7. **Check Dependencies** - Verify package dependencies
8. **Remove Unused Dependencies** - Clean up orphaned packages
9. **Final Cleanup** - Remove old downloads and clear caches
10. **Final Health Check** - Verify everything is working properly

## 🗑️ Uninstallation

### Option 1: Self-Uninstall (Recommended)

```bash
brew-upgrade --uninstall
```

### Option 2: Using the Installer

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash -s -- --uninstall
```

### Option 3: Manual Removal

```bash
rm -rf ~/.scripts/homebrew-upgrade
rm -f ~/.scripts/brew-upgrade
# Optionally remove .scripts if empty
rmdir ~/.scripts 2>/dev/null
```

## 🔄 Updates

To update to the latest version, simply run the installer again:

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

The installer automatically detects and updates existing installations while preserving your configuration.

## 📋 Requirements

- **macOS** (Intel or Apple Silicon)
- **Homebrew** installed and configured
- **Bash 4.0+** (included in modern macOS)
- **Standard Unix tools** (curl, tar, mkdir)

## 🔧 Configuration

### Environment Variables

```bash
# Enable dry-run mode by default
export BREW_UPGRADE_DRY_RUN=true

# Skip casks by default
export BREW_UPGRADE_SKIP_CASKS=true

# Enable verbose logging
export BREW_UPGRADE_VERBOSE=true
```

### Automation

```bash
# Add to crontab for weekly maintenance
0 9 * * 1 /Users/$(whoami)/.scripts/brew-upgrade --skip-casks

# Use in scripts
if brew-upgrade --dry-run; then
    echo "Maintenance would succeed"
    brew-upgrade
fi
```

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
- Use `--force-doctor` to continue despite issues
- Address underlying problems when possible

### Getting Help

When reporting issues, please include:

- **Operating system** and version
- **Homebrew version** (`brew --version`)
- **Full command used** and options
- **Log file contents** from the tool
- **Error messages** (copy exactly)

1. Run `brew-upgrade --help` for usage information
2. Check the logs in the installation directory
3. Open an issue on GitHub with error details

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
- **Provides options** to force continuation (`--force-doctor`)
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
