return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = 'fallback'
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_organize_imports', 'ruff_format' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      rust = { 'rustfmt' },
    },
  },
}
