return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local uname = vim.loop.os_uname().sysname

            if uname == "Linux" then
                dap.adapters.coreclr = {
                    type = "executable",
                    command = "/usr/local/netcoredbg",
                    args = { "--interpreter=vscode" },
                }
                dap.configurations.cs = {
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (console)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                    },
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (web)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                        env = {
                            ASPNETCORE_ENVIRONMENT = "Development",
                            ASPNETCORE_URLS = "http://localhost:5000"
                        },
                        cwd = "${workspaceFolder}",
                    }
                }
            elseif uname == "Darwin" then
                -- macOS configuration (similar to Linux)
                dap.adapters.coreclr = {
                    type = "executable",
                    command = "/usr/local/netcoredbg",
                    args = { "--interpreter=vscode" },
                }
                dap.configurations.cs = {
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (console)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                    },
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (web)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "/bin/Debug/net8.0/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                        env = {
                            ASPNETCORE_ENVIRONMENT = "Development",
                            ASPNETCORE_URLS = "http://localhost:5000"
                        },
                        cwd = "${workspaceFolder}",
                    }
                }
            elseif uname == "Windows_NT" then
                dap.adapters.coreclr = {
                    type = "executable",
                    command = "C:\\Users\\marni\\scoop\\shims\\netcoredbg",
                    args = { "--interpreter=vscode" },
                }
                dap.configurations.cs = {
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (console)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "\\bin\\Debug\\net8.0\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                    },
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg (web)",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd() .. "\\bin\\Debug\\net8.0\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                                "file"
                            )
                        end,
                        env = {
                            ASPNETCORE_ENVIRONMENT = "Development",
                            ASPNETCORE_URLS = "http://localhost:5000"
                        },
                        cwd = "${workspaceFolder}",
                    }
                }
            else
                print("Unsupported operating system")
                return
            end
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                expand_lines = vim.fn.has("nvim-0.7") == 1,
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 0.25,
                        position = "bottom",
                    },
                },
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "↻",
                        terminate = "□",
                    },
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil,
                    max_value_lines = 100,
                },
            })

            -- Auto open/close dap UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}
