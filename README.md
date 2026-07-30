# Dotfiles

Personal configuration files, shell configurations, editor settings, terminal configuration, and system utilities for macOS and Linux.

This repository contains configurations for the tools and environments I use for development and daily work.

## Repository Structure

| Directory                  | Description                                |
| :------------------------- | :----------------------------------------- |
| [`fastfetch/`](fastfetch/) | Fastfetch system information configuration |
| [`ghostty/`](ghostty/)     | Ghostty terminal emulator configuration    |
| [`homebrew/`](homebrew/)   | Homebrew maintenance and upgrade tool      |
| [`neovim/`](neovim/)       | Neovim configuration and cheatsheet        |
| [`starship/`](starship/)   | Starship shell prompt configuration        |
| [`vim/`](vim/)             | Vim configuration files                    |
| [`zsh/`](zsh/)             | Zsh configurations for macOS and Linux     |

## Components

### Homebrew

A modular Homebrew maintenance and upgrade tool for macOS. It handles Homebrew updates, package upgrades, dependency checks, cleanup, logging, and tool management.

See the [Homebrew Upgrade Tool documentation](homebrew/README.md) for installation and usage.

### Zsh

Shell configurations for macOS and Linux. The configurations include shell options, aliases, environment settings, functions, and other command-line customizations.

### Starship

A cross-shell prompt configuration for Starship. It defines the appearance and information displayed in the terminal prompt.

### Fastfetch

A Fastfetch configuration for displaying system information in the terminal, including hardware, operating system, and environment details.

### Neovim

A Lua-based Neovim configuration for editor setup and customization. The directory also contains a personal cheatsheet for commonly used commands and workflows.

### Vim

Vim configuration files for editor preferences, behavior, and local customizations.

### Ghostty

Configuration for the Ghostty terminal emulator, including terminal appearance, behavior, and keybindings.

## Usage

Clone the repository:

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles
```

Review the relevant component before copying or symlinking its configuration files into your home directory.

Each component can be used independently, so you only need to install or configure the parts relevant to your environment.

## License

This repository is licensed under the [MIT License](LICENSE).
