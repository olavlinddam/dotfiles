return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local uname = vim.loop.os_uname().sysname

            -- Function to read and parse .dap-config.json
            local function load_dap_config()
                local config_path = vim.fn.getcwd() .. "/dap-config.json"
                if vim.fn.filereadable(config_path) == 1 then
                    local content = vim.fn.readfile(config_path)
                    local json_str = table.concat(content, "\n")
                    local ok, config = pcall(vim.json.decode, json_str)
                    if ok then
                        return config
                    else
                        print("Error parsing .dap-config.json")
                    end
                else
                    print("Warning: .dap-config.json not found")
                end
                return {}
            end

            -- Function to read and parse .env file
            local function load_env_file(env_path)
                if vim.fn.filereadable(env_path) == 1 then
                    local content = vim.fn.readfile(env_path)
                    local env_vars = {}
                    for _, line in ipairs(content) do
                        local key, value = line:match("^(.-)=(.*)$")
                        if key and value then
                            env_vars[key] = value
                        end
                    end
                    return env_vars
                else
                    print("Warning: .env file not found at " .. env_path)
                    return {}
                end
            end

            -- Function to read and parse launchSettings.json
            local function get_launch_settings(launch_settings_path)
                if vim.fn.filereadable(launch_settings_path) == 1 then
                    local content = vim.fn.readfile(launch_settings_path)
                    local json_str = table.concat(content, "\n")
                    local ok, settings = pcall(vim.json.decode, json_str)
                    if ok then
                        -- Get environment variables from the "http" profile
                        local env_vars = settings.profiles.http.environmentVariables or {}
                        -- Always ensure these basic variables are set
                        env_vars.ASPNETCORE_ENVIRONMENT = env_vars.ASPNETCORE_ENVIRONMENT or "Development"
                        env_vars.ASPNETCORE_URLS = env_vars.ASPNETCORE_URLS or "http://localhost:5000"
                        return env_vars
                    else
                        print("Error parsing launchSettings.json")
                    end
                else
                    print("Warning: launchSettings.json not found at " .. launch_settings_path)
                end
                return {
                    ASPNETCORE_ENVIRONMENT = "Development",
                    ASPNETCORE_URLS = "http://localhost:5000"
                }
            end

            -- Load the custom DAP configuration
            local dap_config = load_dap_config()

            -- Get the platform-specific debugger path
            local debugger_path = dap_config.debugger_path and dap_config.debugger_path[uname:lower()]
            if not debugger_path then
                print("Unsupported operating system or debugger path not configured")
                return
            end

            -- Get the platform-specific DLL path format
            local dll_path_format = dap_config.dll_path_format and dap_config.dll_path_format[uname:lower()]
            if not dll_path_format then
                print("Unsupported operating system or DLL path format not configured")
                return
            end

            -- Configure the adapter
            dap.adapters.coreclr = {
                type = "executable",
                command = debugger_path,
                args = { "--interpreter=vscode" },
            }

            -- Configure launch options
            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg (console)",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to dll",
                            vim.fn.getcwd() .. dll_path_format .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
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
                            vim.fn.getcwd() .. dll_path_format .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ".dll",
                            "file"
                        )
                    end,
                    env = function()
                        local env_vars = get_launch_settings(dap_config.launch_settings)
                        local env_file_vars = load_env_file(dap_config.env_file)
                        -- Merge environment variables from .env file with those from launchSettings.json
                        for k, v in pairs(env_file_vars) do
                            env_vars[k] = v
                        end
                        return env_vars
                    end,
                    cwd = "${workspaceFolder}",
                }
            }
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

            -- Add keymaps for debugging
            vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
            vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
            vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
            vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
            vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
            vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
            vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
            vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
            vim.keymap.set('n', '<Leader>dt', function() require('dap').terminate() end)

            -- Dap UI keymaps
            vim.keymap.set('n', '<Leader>dui', function() require('dapui').toggle() end)
        end
    },
}
