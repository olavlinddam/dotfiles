return {
	{
		"sainnhe/everforest",
		--"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optional: configure it here
			vim.cmd([[
        set background=dark " or light if you prefer
        colorscheme everforest
        "colorscheme tokyonight-storm
      ]])
		end,
	},
}
