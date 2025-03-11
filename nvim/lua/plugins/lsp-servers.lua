-- plugins/lsp-config.lua
return {
  -- Mason for managing LSP servers, formatters and linters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry"  -- Required for Roslyn
        }
      })
    end,
  },

  -- Mason LSP integration
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",         -- Lua
          "ts_ls",       -- TypeScript/JavaScript
          "volar",          -- Vue
          "dockerls",       -- Dockerfile
          "docker_compose_language_service", -- Docker Compose
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Import lspconfig
      local lspconfig = require("lspconfig")

      -- Capabilities for completion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configure Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Configure TypeScript/JavaScript LSP
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })

      -- Configure Vue LSP
      lspconfig.volar.setup({
        capabilities = capabilities,
      })

      -- Configure Docker LSP
      lspconfig.dockerls.setup({
        capabilities = capabilities,
      })

      -- Configure Docker Compose LSP
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities,
      })

      -- Global LSP mappings are already defined in your keymaps.lua
    end,
  },

  -- Roslyn LSP for C# (keeping your existing configuration)
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    opts = {
      exe = {
        "dotnet",
        "C:/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
      },
      args = {
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
      },
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      },
      filewatching = "auto",
    },
  },
}
