return {
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optional: configure it here
			vim.cmd([[set background=dark]]) -- or light if you prefer
			vim.cmd.colorscheme("everforest")
		end,
	},
}
