return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({
      -- Use preset for a predefined setup
      preset = "classic",

      -- Delay before showing the popup
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,

      -- Filter mappings to show
      filter = function(mapping)
        -- Show all mappings (including those without descriptions)
        return true
      end,

      -- Add mappings within setup
      spec = {},

      -- Set proper triggers
      triggers = {
        { "<auto>", mode = "nxsotc" },
      },

      -- Defer showing which-key until a key is pressed
      defer = function(ctx)
        return ctx.mode == "V" or ctx.mode == "<C-V>"
      end,

      -- Plugin settings
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },

      -- Window options (replaced deprecated 'window')
      win = {
        no_overlap = true,
        padding = { 1, 2 },
        border = "rounded",
        title = true,
        title_pos = "center",
        zindex = 1000,
        wo = {
          winblend = 10,
        },
      },

      -- Layout settings
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        height = { min = 4, max = 25 },
      },

      -- Keys for scrolling
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },

      -- Sorting options
      sort = { "local", "order", "group", "alphanum", "mod" },

      -- Expand behavior
      expand = 0,

      -- Icons settings
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        mappings = true,
        colors = true,
      },

      -- Help and debug settings
      show_help = true,
      show_keys = true,
      disable = {
        ft = {},
        bt = {},
      },
      debug = false,
    })

    -- Add your key groups
    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>s", group = "search" },
      { "<leader>w", group = "window" },
      { "<leader>g", group = "git" },
      { "<leader>d", group = "debug" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "refactor" },
      { "<leader>h", group = "harpoon" },
      { "<leader>j", group = "jumplist" },
    })
    end
}
