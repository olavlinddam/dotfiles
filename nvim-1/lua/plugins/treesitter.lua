return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "rust",
          "c",
          "cpp",
          "markdown",
          "html",
          "css",
          "c_sharp"
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          enable = true,
          -- disable = { "c", "rust" },  -- list of languages you want to disable
          additional_vim_regex_highlighting = false,
        },

        -- Indentation based on treesitter for the = operator
        indent = { enable = true },

        -- Autotagging with windwp/nvim-ts-autotag
        autotag = { enable = true },
      })
    end,
  }
}
