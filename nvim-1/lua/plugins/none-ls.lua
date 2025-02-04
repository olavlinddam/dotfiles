return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"williamboman/mason.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		-- Register sources
		null_ls.setup({
			sources = {
				-- Lua formatting
				null_ls.builtins.formatting.stylua,

				-- General formatting
				null_ls.builtins.formatting.prettier,

				-- Python formatting
				--null_ls.builtins.formatting.black,
				--null_ls.builtins.formatting.isort,

				-- Diagnostics
				--null_ls.builtins.diagnostics.eslint,
				--null_ls.builtins.diagnostics.luacheck,

				-- Code Actions
				--null_ls.builtins.code_actions.gitsigns,

				-- Completion
				null_ls.builtins.completion.luasnip,
			},
		})

		-- Set up format keybinding outside of the setup call
	end,
}
