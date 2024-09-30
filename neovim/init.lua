-- [[ Core Settings ]]
require 'core.options'
require 'core.keymaps'

-- [[ Load Lazy.nvim Setup ]]
require 'core.lazy_setup'

-- [[ Load Plugins ]]
require('lazy').setup {
  require 'plugins.alpha',
  require 'plugins.autocompletion',
  require 'plugins.autopairs',
  require 'plugins.autotag',
  require 'plugins.bufferline',
  require 'plugins.colortheme',
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
