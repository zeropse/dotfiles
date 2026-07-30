# Homebrew Upgrade Tool

<p align="left">
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS Supported">
  <img src="https://img.shields.io/badge/Homebrew-v4.0+-FDEE21?style=for-the-badge&logo=homebrew&logoColor=black" alt="Homebrew Supported">
  <img src="https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell Supported">
</p>

A modular Homebrew maintenance and upgrade script for macOS. It updates Homebrew, checks system health, upgrades formulae and casks, removes unused dependencies, cleans cached files, and records the execution log.

## Installation

### One-Line Installation

Run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash
```

After installation, reload your shell:

```bash
source ~/.zshrc
```

Then run:

```bash
brew-upgrade
```

For Bash users:

```bash
source ~/.bashrc
```

## Features

- Pre-flight cleanup of stale Homebrew lock files to prevent process conflict errors.
- Caches the result of `brew outdated` to avoid repeated package checks.
- Supports both Homebrew formulae and casks.
- Upgrades casks individually so a failed cask does not stop other upgrades.
- Provides interactive progress indicators when running in a TTY.
- Falls back to non-interactive output when used by scripts or background processes.
- Deep cache purging (`brew cleanup --prune=all -s`) to reclaim maximum disk space.
- Displays upgraded formulae and cask counts in the final execution summary.
- Writes clean, ANSI-free logs to `~/.brew-maintenance.log`.
- Uses modular shell libraries with include guards to prevent duplicate sourcing.
- Includes built-in update and uninstall commands.
- Supports both Apple Silicon and Intel Macs.

## Usage

Run the complete maintenance process:

```bash
brew-upgrade
```

### Options

| Option         | Description                              |
| :------------- | :--------------------------------------- |
| `-h`, `--help` | Display usage information                |
| `--update`     | Update the tool to the latest version    |
| `--uninstall`  | Remove the tool and its associated files |

## Maintenance Process

`brew-upgrade` performs the following steps:

1. **Update Homebrew**

   ```bash
   brew update
   ```

   Clears stale lockfiles (if any) and refreshes Homebrew's formula and cask indexes.

2. **Run Initial Health Check**

   ```bash
   brew doctor
   ```

   Checks the Homebrew environment for potential problems.

3. **Check Outdated Packages**

   Identifies outdated formulae and casks and stores the results for use by later steps.

4. **Upgrade Formulae**

   ```bash
   brew upgrade --formula
   ```

   Upgrades outdated command-line packages and libraries.

5. **Upgrade Casks**

   ```bash
   brew upgrade --cask
   ```

   Upgrades installed graphical applications individually.

6. **Check Dependencies**

   ```bash
   brew missing
   ```

   Checks for missing or broken dependencies.

7. **Remove Unused Dependencies**

   ```bash
   brew autoremove
   ```

   Removes dependencies that are no longer required.

8. **Clean Homebrew**

   ```bash
   brew cleanup --prune=all -s
   ```

   Removes outdated downloads, cached files, old package versions, and related temporary files.

9. **Run Final Health Check**

   Runs `brew doctor` again and reports the final status and total execution time.

## Repository Structure

```text
~/.scripts/
├── brew-upgrade -> homebrew-upgrade/brew-upgrade.sh
└── homebrew-upgrade/
    ├── brew-upgrade.sh
    └── lib/
        ├── cli.sh
        ├── config.sh
        ├── logger.sh
        ├── self_mgmt.sh
        ├── steps.sh
        ├── summary.sh
        └── utils.sh
```

### Module Overview

| File              | Purpose                                          |
| :---------------- | :----------------------------------------------- |
| `brew-upgrade.sh` | Main executable and entry point                  |
| `cli.sh`          | Command-line argument parsing and help output    |
| `config.sh`       | Configuration, terminal settings, and exit codes |
| `logger.sh`       | Progress display and log handling                |
| `self_mgmt.sh`    | Update and uninstall functionality               |
| `steps.sh`        | Homebrew maintenance operations                  |
| `summary.sh`      | Execution summary and statistics                 |
| `utils.sh`        | Shared shell utilities                           |

## Local Installation

To install from a local clone:

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles/homebrew
```

Make the installer executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
./install.sh
```

## Updating

The tool can update itself from the repository:

```bash
brew-upgrade --update
```

Before updating, the current installation is backed up using a timestamped directory:

```text
~/.scripts/homebrew-upgrade.backup.YYYYMMDDHHMMSS
```

## Uninstalling

To remove the tool:

```bash
brew-upgrade --uninstall
```

The uninstall process removes:

- `brew-upgrade` shortcut
- Installation directory
- Backup directories
- `~/.brew-maintenance.log`

## Logging

Execution logs are stored at:

```text
~/.brew-maintenance.log
```

Terminal formatting and ANSI control sequences are removed before entries are written to the log, keeping the file suitable for viewing or processing from the command line.

## Troubleshooting

### `brew-upgrade: command not found`

Make sure `~/.scripts` is included in your `PATH`:

```bash
echo 'export PATH="$HOME/.scripts:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

For Bash:

```bash
echo 'export PATH="$HOME/.scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### A cask upgrade fails

Casks are processed individually. If an application fails to upgrade, the failure is logged and the remaining casks continue to be processed.

### Checking the log

View the latest maintenance log with:

```bash
cat ~/.brew-maintenance.log
```

## Contributing

Contributions, bug reports, and feature requests are welcome.

1. Fork the repository.
2. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature
   ```

3. Commit your changes:

   ```bash
   git commit -m "Add your feature"
   ```

4. Push the branch:

   ```bash
   git push origin feature/your-feature
   ```

5. Open a pull request.

## License

See the repository for licensing information.
