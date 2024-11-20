return {
    -- Mason for managing LSP servers
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            
            -- Configure omnisharp
            lspconfig.omnisharp.setup({
                cmd = { "omnisharp" },  -- Uses the system-installed omnisharp from AUR
                enable_import_completion = true,
                enable_roslyn_analyzers = true,
                enable_editorconfig_support = true,
            })
        end
    }
}
