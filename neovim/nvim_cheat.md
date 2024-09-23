# Neovim Cheatsheet

## Modes

- **Normal Mode**: Default mode for navigation and commands (`Esc`)
- **Insert Mode**: `i`, `I`, `a`, `A` (exit with `Esc`)
- **Visual Mode**: `v` (character), `V` (line), `Ctrl+v` (block)
- **Command Mode**: `:`

## Navigation

- **Basic**: `h` (left), `j` (down), `k` (up), `l` (right)
- **Words**: `w` (next word), `b` (previous word), `e` (end of word)
- **Lines**: `0` (start), `^` (first non-whitespace), `$` (end)
- **Scrolling**: `Ctrl+d` (down), `Ctrl+u` (up)
- **File**: `gg` (top), `G` (bottom)

## Actions

- `d`: Delete
- `c`: Change
- `y`: Yank (copy)
- `p`, `P`: Paste (after, before)
- `u`: Undo
- `Ctrl+r`: Redo

## Text Objects and Motions

- `w`: Word
- `s`: Sentence
- `p`: Paragraph
- `t`: Tag
- `'`, `"`, `` ` ``: Quote
- `(`, `)`, `{`, `}`, `<`, `>`: Bracket
- `i`, `a`: Inside/Around

## Examples

- `dw`: Delete word
- `cw`: Change word
- `yy`: Copy entire line
- `y$`: Copy to end of line
- `di'`, `di"`: Delete inside quotes
- `ca{`, `ci(`: Change around braces
- `yap`: Yank paragraph
- `yiw`: Yank inside word
- `ciw`: Change inside word
- `vit`: Visual selection inside tag
- `ct"`: Change to next `"` (leaving the `"`)
- `df|`: Delete to next `|` (including the `|`)

## Keybindings

- **Leader Key**: Space (`<leader>`)
- **File Actions**: 
  - Save: `<C-s>`
  - Save without auto-formatting: `<leader>sn`
  - Quit: `<C-q>`
- **Deleting**:
  - Delete character without copying: `x`
- **Scrolling and Centering**:
  - Scroll: `<C-d>`, `<C-u>`
  - Find and center: `n`, `N`
- **Window Resizing**: 
  - Resize: `<Up>`, `<Down>`, `<Left>`, `<Right>`
- **Buffer Management**: 
  - Switch buffers: `<Tab>`, `<S-Tab>`
  - Close buffer: `<leader>x`, `<leader>b`
- **Window Management**: 
  - Split: `<leader>v` (vertical), `<leader>h` (horizontal)
  - Equalize: `<leader>se`
  - Close split: `<leader>xs`
- **Navigate Between Splits**: 
  - `<C-k>`, `<C-j>`, `<C-h>`, `<C-l>`
- **Tab Management**: 
  - Open: `<leader>to`
  - Close: `<leader>tx`
  - Next/Previous: `<leader>tn`, `<leader>tp`
- **Toggle Line Wrapping**: `<leader>lw`
- **Indenting**: Stay in indent mode: `<`, `>`
- **Pasting**: Keep last yanked when pasting: `p`
- **Diagnostic Navigation**: 
  - Previous/Next diagnostic: `[d`, `]d`
  - Show diagnostics: `<leader>d`
  - Open diagnostic list: `<leader>q`
- **Incremental Rename**: `<leader>rn`

## Miscellaneous

- `.`: Repeat last command
- `gd`: Go to definition
- `f<char>`: Find character
- `t<char>`: To character
- `ZZ`: Save & close Neovim

## Plugin-Specific Keybindings

- **Telescope**:
  - Find files: `<leader>ff`
  - Live grep: `<leader>fg`
  - Find buffers: `<leader>fb`
  - Help tags: `<leader>fh`

- **Neotree**:
  - Toggle file explorer: `<leader>e`

- **LazyGit**:
  - Open LazyGit: `<leader>lg`

## Macro Recording and Playback

- **Start Recording**: `q<char>` (e.g., `qa` for register `a`)
- **Stop Recording**: `q`
- **Playback**: `@<char>` (e.g., `@a`)
- **Repeat Last Macro**: `@@`

## Search and Replace

- **Replace All**: `:%s/old/new/g`
- **Replace in Lines 10-20**: `:10,20s/old/new/g`
- **Replace in Current Line**: `:s/old/new/g`

## Additional Window Management

- Cycle through splits: `<C-w>w`
- Move current split to far left: `<C-w>H`
- Move current split to top: `<C-w>K`
