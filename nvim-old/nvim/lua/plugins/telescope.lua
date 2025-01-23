return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { 
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({
                        -- even more compact
                        layout_config = {
                            width = 0.4,  -- 40% of screen width
                            height = 0.4, -- 40% of screen height
                        },
                    })
                }
            }
        })
        telescope.load_extension("ui-select")
    end,
  }
}
