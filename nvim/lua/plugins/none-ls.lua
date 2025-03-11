return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufReadPre *.vue", "BufReadPre *.lua", "BufReadPre *.js", "BufReadPre *.jsx", "BufReadPre *.ts", "BufReadPre *.tsx" },
    config = function()
        local null_ls = require("null-ls")
        local mason_registry = require("mason-registry")

        -- Install Mason tool installer to ensure formatters/linters are installed
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "eslint_d",
                "prettier",
                "luacheck"
            },
            auto_update = true,
            run_on_start = true,
        })

        -- Define a function to ensure tools are installed based on filetype
        local ensure_installed = function(filetype)
            local tools = {
                lua = { "stylua", "luacheck" },
                javascript = { "eslint_d", "prettier" },
                javascriptreact = { "eslint_d", "prettier" },
                typescript = { "eslint_d", "prettier" },
                typescriptreact = { "eslint_d", "prettier" },
            }

            local to_install = tools[filetype] or {}
            for _, tool in ipairs(to_install) do
                if not mason_registry.is_installed(tool) then
                    vim.notify("Installing " .. tool, vim.log.levels.INFO)
                    local package = mason_registry.get_package(tool)
                    package:install()
                end
            end
        end

        -- Setup an autocmd to install tools when specific filetypes are loaded
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "javascript", "javascriptreact", "typescript", "typescriptreact" },
            callback = function(opts)
                ensure_installed(opts.match)
            end,
            once = true, -- Only trigger once per filetype
        })

        -- Register sources
        null_ls.setup({
            sources = {
                -- Formatting
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,

                -- Diagnostics
                null_ls.builtins.diagnostics.eslint_d,
                -- Only use luacheck if it's installed
                mason_registry.is_installed("luacheck")
                    and null_ls.builtins.diagnostics.luacheck
                    or nil,
            },
            -- When missing a tool, don't error but show a warning
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<leader>fd", function()
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            filter = function(formatter)
                                return formatter.name == "null-ls"
                            end
                        })
                    end, { buffer = bufnr, desc = "Format document with none-ls" })
                end
            end,
        })
    end,
}
