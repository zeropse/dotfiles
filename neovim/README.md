# Neovim Configuration

<p align="left">
<img src="https://img.shields.io/badge/Neovim-57AD31?style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim">
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua">
</p>

This is my **Neovim configuration**, written in **Lua**. It uses **lazy.nvim** as the plugin manager and is designed to be clean, efficient, and easy to maintain. It includes support for LSP, fuzzy finding, syntax highlighting, autocompletion, file navigation, and various UI enhancements.

## Requirements

The configuration requires:

- **Neovim** `>= 0.10.0`
- **Git**
- **C compiler** such as GCC or Clang
- **ripgrep** — required for Telescope live grep
- **fd** — recommended for file searching
- **Nerd Font** — required for terminal icons

Some plugins may have additional dependencies depending on the language and development tools being used.

## Installation

### macOS

Using Homebrew:

```bash
brew install neovim ripgrep fd gcc
brew install --cask font-jetbrains-mono-nerd-font
```

### Arch Linux

```bash
sudo pacman -S neovim ripgrep fd gcc
```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install neovim ripgrep fd-find build-essential
```

### Clone the Repository

Clone the dotfiles repository:

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles
```

### Install the Configuration

Create the Neovim configuration directory and copy the files:

```bash
mkdir -p ~/.config
cp -r neovim ~/.config/nvim
```

### Launch Neovim

Start Neovim:

```bash
nvim
```

On the first launch:

- `lazy.nvim` bootstraps automatically.
- Configured plugins are installed.
- Mason installs the configured language servers and development tools.

## Features

- **Plugin Management** — Plugin installation and management through `lazy.nvim`.
- **Fuzzy Finding** — File search, live grep, buffers, diagnostics, and other search functionality through `telescope.nvim`.
- **LSP Integration** — Language Server Protocol support with `mason.nvim`, `nvim-lspconfig`, formatters, and linters.
- **Syntax Highlighting** — Tree-sitter based syntax highlighting and parsing.
- **File Explorer** — File navigation through `neo-tree.nvim`.
- **Completion** — Autocompletion with `nvim-cmp` and snippets through `LuaSnip`.
- **Interface** — Nord colorscheme with `lualine.nvim`, `bufferline.nvim`, and `alpha-nvim`.
- **Keybindings** — Interactive keybinding discovery through `which-key.nvim`.

## Repository Structure

```text
neovim/
├── init.lua
├── .stylua.toml
├── nvim_cheat.md
└── lua/
    ├── core/
    │   ├── keymaps.lua
    │   ├── lazy_setup.lua
    │   └── options.lua
    └── plugins/
        ├── alpha.lua
        ├── autocompletion.lua
        ├── lsp.lua
        ├── neotree.lua
        ├── telescope.lua
        ├── which-key.lua
        └── ...
```

### Module Overview

| Directory / File          | Purpose                                 |
| :------------------------ | :-------------------------------------- |
| `init.lua`                | Main configuration entry point          |
| `lua/core/options.lua`    | General Neovim options and UI settings  |
| `lua/core/keymaps.lua`    | Global keybindings                      |
| `lua/core/lazy_setup.lua` | Plugin manager configuration            |
| `lua/plugins/`            | Individual plugin configuration modules |
| `nvim_cheat.md`           | Neovim keybinding and command reference |

## Usage

### Useful Commands

The following commands can be run inside Neovim:

| Command        | Description                                   |
| :------------- | :-------------------------------------------- |
| `:Lazy`        | Open the plugin manager                       |
| `:Mason`       | Manage language servers and development tools |
| `:checkhealth` | Check Neovim and plugin dependencies          |

### Keybindings

The `<Space>` key is used as the leader key.

| Mode   | Keybinding    | Action                         |
| :----- | :------------ | :----------------------------- |
| Normal | `<Space>e`    | Toggle Neo-tree                |
| Normal | `<Space>sf`   | Search files with Telescope    |
| Normal | `<Space>sg`   | Live grep with Telescope       |
| Normal | `<C-s>`       | Save the current file          |
| Normal | `<C-h/j/k/l>` | Navigate between split windows |
| Normal | `gd`          | Go to LSP definition           |
| Normal | `gr`          | Go to LSP references           |
| Normal | `<Space>rn`   | Rename using LSP               |
| Normal | `<Space>ca`   | Show LSP code actions          |
| Insert | `<C-y>`       | Confirm completion             |

Press `<Space>` in Normal mode to view available keybindings through `which-key`.

For the complete list, see [`nvim_cheat.md`](./nvim_cheat.md).

## Troubleshooting

### Missing Icons or Broken Symbols

Ensure a Nerd Font is installed and configured as your terminal font.

### Telescope Live Grep Fails

`telescope.nvim` requires `ripgrep` (`rg`) to be installed and available in your `PATH`.

### Tree-sitter Compilation Errors

Tree-sitter parsers require a C compiler such as GCC or Clang.

## License

See the repository for licensing information.
