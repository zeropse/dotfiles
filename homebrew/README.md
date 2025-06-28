# Homebrew Upgrade Script

A comprehensive, modular Homebrew maintenance script designed for reliable system updates with enhanced error handling, logging, and user experience.

## Installation

### One-Line Install

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

### Local Installation

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles/homebrew
./install.sh
```

## ✨ Features

### 🔧 **Comprehensive Maintenance**

- **Initial cleanup** - Removes old versions, cache, and temporary files
- **System health checks** - Validates Homebrew installation integrity
- **Package updates** - Updates Homebrew itself and all installed packages
- **Dependency management** - Checks and removes unused dependencies
- **Intelligent cask handling** - Individual cask upgrades with error isolation
- **Final verification** - Ensures system health after all operations

### 🛡️ **Robust Error Handling**

- **Strict error checking** with `set -euo pipefail`
- **Graceful cleanup** on script exit or interruption
- **Individual package handling** with failure isolation
- **Comprehensive error logging** and reporting
- **Force options** for continuing despite warnings

### 🎯 **Smart Configuration**

- **Dry-run mode** to preview all changes before execution
- **Modular architecture** with separated concerns
- **Flexible options** for skipping specific operations
- **Verbose logging** with detailed output control
- **Environment variable support** for automation

### 🎨 **Beautiful Interface**

- **Colorized output** with clear status indicators
- **Progress tracking** with step-by-step reporting
- **Professional banners** and completion summaries
- **Detailed statistics** and performance metrics
- **Clean, readable help system**

## 📁 Project Structure

```
homebrew/
├── brew-upgrade.sh           # Main entry point script
├── lib/                      # Modular components
│   ├── config.sh            # Configuration and constants
│   ├── logger.sh            # Logging functions
│   ├── utils.sh             # Common utilities
│   ├── cli.sh               # Command-line interface
│   ├── steps.sh             # Maintenance step functions
│   └── summary.sh           # Summary and reporting
├── README.md                # Documentation
```

## 🚀 Quick Start

### Basic Usage

```bash
# Run full maintenance
./brew-upgrade.sh

# Preview changes without executing
./brew-upgrade.sh --dry-run

# Skip cask upgrades for faster execution
./brew-upgrade.sh --skip-casks

# Enable verbose output
./brew-upgrade.sh --verbose
```

## 📊 Output and Logging

### Console Output

- **Colorized status indicators** (✓ success, ⚠️ warning, ❌ error)
- **Progress tracking** with step numbers and descriptions
- **Real-time feedback** during long-running operations
- **Professional banners** for start and completion

### Log File

- **Comprehensive logging** to `~/.brew-maintenance.log`
- **Timestamped entries** for audit trails
- **Error details** and debugging information
- **Configuration tracking** for troubleshooting

### Default Behavior

- **Full maintenance** including all steps
- **Normal output** with colored status indicators
- **Automatic cleanup** before and after updates
- **Complete logging** to `~/.brew-maintenance.log`

## 🛠️ Installation

### Prerequisites

- **macOS** (Intel or Apple Silicon)
- **Homebrew** installed and configured
- **Bash 4.0+** (default on modern macOS)

### Setup

1. **Clone or download** the script files
2. **Make executable**:
   ```bash
   chmod +x brew-upgrade.sh
   ```
3. **Run directly** or add to your PATH

### Integration

- **Add to cron** for automated maintenance
- **Include in shell scripts** for system automation
- **Use with CI/CD** for development environments

## 🐛 Troubleshooting

### Common Issues

**Script fails with "Homebrew not found"**

- Ensure Homebrew is properly installed
- Check that `brew` command is in your PATH
- Try running `brew --version` manually

**Permission errors during cleanup**

- Run with appropriate permissions
- Check Homebrew directory ownership
- Use `sudo` only if absolutely necessary

**Cask upgrades fail**

- Individual cask failures don't stop the process
- Check specific cask issues in the log file
- Some casks require manual intervention

**brew doctor reports issues**

- Review the specific warnings/errors
- Use `--force-doctor` to continue despite issues
- Address underlying problems when possible

### Getting Help

When reporting issues, please include:

- **Operating system** and version
- **Homebrew version** (`brew --version`)
- **Full command used** and options
- **Log file contents** (`~/.brew-maintenance.log`)

## 🔒 Error Handling

The script implements comprehensive error handling:

- **Fails fast** on critical errors (Homebrew missing, update failures)
- **Continues gracefully** on non-critical issues (individual package failures)
- **Provides options** to force continuation (`--force-doctor`)
- **Logs everything** for post-execution review
- **Clean exit** with proper resource cleanup

## 📈 Performance

### Optimization Features

- **Parallel operations** where safely possible
- **Intelligent step skipping** based on system state
- **Efficient cleanup** with selective operations
- **Minimal redundancy** in checks and operations

## 🤝 Contributing

This script is part of a personal dotfiles collection but contributions are welcome:

1. **Test thoroughly** on different macOS versions
2. **Maintain backward compatibility** where possible
3. **Follow existing code style** and patterns
4. **Update documentation** for any changes
5. **Consider edge cases** and error scenarios
