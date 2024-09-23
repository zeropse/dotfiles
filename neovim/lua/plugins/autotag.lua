return {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",  -- ensure it loads after treesitter
    config = function()
      require("nvim-ts-autotag").setup {
        filetypes = { "html", "xml", "jsx", "tsx" },  -- Specify filetypes you want to enable
        -- Add more configuration options here if needed
      }
    end,
  }
  