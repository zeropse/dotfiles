# Neovim Configuration

Personal Neovim configuration written in Lua and managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

The configuration includes LSP support, autocompletion, syntax highlighting, fuzzy finding, file navigation, and terminal UI customization.

## Features

- **Plugin Management** — Uses `lazy.nvim` for plugin installation and management.
- **Fuzzy Finding** — File search, live grep, buffers, diagnostics, and other search functionality through `telescope.nvim`.
- **LSP** — Language Server Protocol support with `mason.nvim`, `nvim-lspconfig`, and configured formatters and tools.
- **Syntax Highlighting** — Tree-sitter based syntax highlighting and parsing.
- **File Explorer** — File navigation through `neo-tree.nvim`.
- **Completion** — Autocompletion with `nvim-cmp` and snippets through `LuaSnip`.
- **Interface** — Nord colorscheme with `lualine.nvim`, `bufferline.nvim`, and a configured startup dashboard.
- **Keybindings** — `which-key.nvim` provides interactive keybinding discovery.

## Directory Structure

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

## Requirements

The configuration requires:

- **Neovim** `>= 0.10.0`
- **Git**
- **C compiler** such as GCC or Clang
- **ripgrep** — required for Telescope live grep
- **fd** — recommended for file searching
- **Nerd Font** — required for terminal icons

Some plugins may have additional dependencies depending on the language or tools being used.

## Installation

### 1. Install Dependencies

#### macOS

Using Homebrew:

```bash
brew install neovim ripgrep fd gcc
```

For icons, install a Nerd Font such as JetBrainsMono Nerd Font:

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

#### Arch Linux

```bash
sudo pacman -S neovim ripgrep fd gcc
```

#### Ubuntu / Debian

```bash
sudo apt update
sudo apt install neovim ripgrep fd-find build-essential
```

### 2. Clone the Repository

Clone the dotfiles repository:

```bash
git clone https://github.com/zeropse/dotfiles.git
cd dotfiles
```

### 3. Link the Configuration

Create the Neovim configuration directory if it does not already exist:

```bash
mkdir -p ~/.config
```

Create a symlink to the configuration:

```bash
ln -s "$(pwd)/neovim" ~/.config/nvim
```

### 4. Start Neovim

Launch Neovim:

```bash
nvim
```

On the first launch:

- `lazy.nvim` bootstraps automatically.
- Configured plugins are installed.
- Mason installs the configured language servers and development tools.

## Useful Commands

The following commands can be run inside Neovim:

| Command        | Description                                   |
| :------------- | :-------------------------------------------- |
| `:Lazy`        | Open the plugin manager                       |
| `:Mason`       | Manage language servers and development tools |
| `:checkhealth` | Check Neovim and plugin dependencies          |

## Keybindings

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

## License

MIT © zeropse
