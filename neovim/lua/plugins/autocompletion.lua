return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      config = function()
        -- LuaSnip Keymaps
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        vim.keymap.set({ 'i', 's' }, '<C-l>', function()
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { silent = true })

        vim.keymap.set({ 'i', 's' }, '<C-h>', function()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { silent = true })

        vim.keymap.set({ 'i', 's' }, '<C-j>', function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end)

        vim.keymap.set({ 'i', 's' }, '<C-k>', function()
          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          end
        end)
      end,
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    local kind_icons = {
      Text = '󰉿',
      Method = 'm',
      Function = '󰊕',
      Constructor = '',
      Field = '',
      Variable = '󰆧',
      Class = '󰌗',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰇽',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰊄',
    }
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete {},

        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),

        ['<C-h>'] = cmp.mapping(function()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },

      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
