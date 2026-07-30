return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]ab' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>d', group = '[D]iagnostics' },
      { '<leader>x', group = 'Trouble/Diagnostics' },
      { '<leader>c', group = '[C]ode / Symbols' },
    },
  },
}
