-- [[ Core Settings ]]
require 'core.options'
require 'core.keymaps'

-- [[ Load Lazy.nvim Setup ]]
require 'core.lazy_setup'

-- [[ Load Plugins ]]
require('lazy').setup({
  { import = 'plugins' },
}, {
  change_detection = { notify = false },
})

