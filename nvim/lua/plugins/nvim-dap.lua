return {
    {
        "mfussenegger/nvim-dap",  -- Main debugging plugin
        config = function()
            local dap = require("dap")  -- Get the debug adapter protocol module
            
            -- Detect operating system for OS-specific configurations
            local uname = vim.loop.os_uname().sysname

            if uname == "Linux" then
                -- Setup for Linux
                dap.adapters.coreclr = {  -- Configure the C# debugger adapter
                    type = "executable",   -- Run as an executable program
                    command = "/usr/bin/netcoredbg",  -- Path to the debugger
                    args = { "--interpreter=vscode" }, -- Use VSCode debug protocol
                }
                dap.configurations.cs = {  -- Configuration for C# debugging
                    {
                        type = "coreclr",  -- Use the coreclr adapter defined above
                        name = "launch - netcoredbg",  -- Name shown in debugger
                        request = "launch", -- Start new process (vs 'attach')
                        program = function()
                            -- Prompt for dll path with default value
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd()  -- Start from current directory
                                    .. "/ProjectRiskManagementSim.ProjectSimulator/bin/Debug/net8.0/ProjectRiskManagementSim.ProjectSimulator.dll",
                                "file"
                            )
                        end,
                    },
                }
            elseif uname == "Darwin" then -- macOS configuration (empty for now)
            -- Nothing defined
            elseif uname == "Windows_NT" then
                -- Windows configuration (similar to Linux but with Windows paths)
                dap.adapters.coreclr = {
                    type = "executable",
                    command = "C:\\Users\\marni\\scoop\\shims\\netcoredbg",
                    args = { "--interpreter=vscode" },
                }
                dap.configurations.cs = {
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg",
                        request = "launch",
                        program = function()
                            return vim.fn.input(
                                "Path to dll",
                                vim.fn.getcwd()
                                    .. "\\ProjectRiskManagementSim.ProjectSimulator\\bin\\Debug\\net8.0\\ProjectRiskManagementSim.ProjectSimulator.dll",
                                "file"
                            )
                        end,
                    },
                }
            else
                print("Unsupported operating system.")
                return
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",  -- UI plugin for nvim-dap
        -- Required dependencies
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            -- Get both dap and dapui modules
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup({
                -- Configure UI icons for expanded/collapsed sections
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                
                -- Define key mappings for the UI
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },  -- Expand section
                    open = "o",    -- Open item
                    remove = "d",  -- Remove item
                    edit = "e",    -- Edit item
                    repl = "r",    -- Open REPL
                    toggle = "t",  -- Toggle item
                },

                -- Optional element-specific mapping overrides
                element_mappings = {
                    -- Example:
                    -- stacks = {
                    --   open = "<CR>",
                    --   expand = "o",
                    -- }
                },

                -- Enable line expansion if Neovim >= 0.7
                expand_lines = vim.fn.has("nvim-0.7") == 1,

                -- Define UI layout
                layouts = {
                    {   -- Left sidebar layout
                        elements = {
                            { id = "scopes", size = 0.25 },  -- Variable scope viewer
                            "breakpoints",  -- Breakpoint list
                            "stacks",      -- Call stack
                            "watches",     -- Watch expressions
                        },
                        size = 40,         -- Width in columns
                        position = "left", -- Position on screen
                    },
                    {   -- Bottom panel layout
                        elements = {
                            "repl",     -- Interactive REPL
                            "console",  -- Debug console
                        },
                        size = 0.25,     -- Height (25% of window)
                        position = "bottom",
                    },
                },

                -- Debug control buttons configuration
                controls = {
                    enabled = true,
                    element = "repl",  -- Show in REPL window
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

                -- Floating window configuration
                floating = {
                    max_height = nil,     -- Can be number or nil
                    max_width = nil,      -- Can be number or nil
                    border = "single",    -- Window border style
                    mappings = {
                        close = { "q", "<Esc>" },  -- Close window mappings
                    },
                },

                windows = { indent = 1 },  -- Indentation in windows
                render = {
                    max_type_length = nil,    -- Max length for type strings
                    max_value_lines = 100,    -- Max lines for values
                },
            })

            -- Auto-open UI when debugging starts
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            -- Auto-close UI when debugging terminates
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            -- Auto-close UI when debugging exits
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}
