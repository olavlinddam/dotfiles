return {

	{
		-- Setup of the unit testing for dotnet
		"Issafalcon/neotest-dotnet",
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-dotnet"),
				},
			})
		end,
	},
	{
		-- Framework for unit testing
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"Issafalcon/neotest-dotnet",
		},
	},
}
