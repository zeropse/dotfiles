return {
    "smjonas/inc-rename.nvim",
    after = "nvim-lspconfig",  -- ensure it loads after LSP
    config = function()
      require("inc_rename").setup {
        -- You can add additional configuration options here
      }
    end,
  }
  