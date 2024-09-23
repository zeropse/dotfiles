-- [[ Core Settings ]]
require 'core.options'
require 'core.keymaps'

-- [[ Install `lazy.nvim` Plugin Manager ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Load Plugins ]]
require('lazy').setup {
  require 'plugins.alpha',
  require 'plugins.autocompletion',
  require 'plugins.autopairs',
  require 'plugins.autotag',
  require 'plugins.bufferline',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.inc-rename',
  require 'plugins.indent-blankline',
  require 'plugins.lazygit',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.misc',
  require 'plugins.neotree',
  require 'plugins.none-ls',
  require 'plugins.telescope',
  require 'plugins.treesitter',
}
