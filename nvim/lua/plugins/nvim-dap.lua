return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local uname = vim.loop.os_uname().sysname

			-- Function to read and parse launchSettings.json
			local function get_launch_settings()
				local function find_launch_settings()
					-- Common paths to look for launchSettings.json
					local possible_paths = {
						"Properties/launchSettings.json",
						"../Properties/launchSettings.json",
						"../../Properties/launchSettings.json",
					}

					for _, path in ipairs(possible_paths) do
						local full_path = vim.fn.getcwd() .. "/" .. path
						if vim.fn.filereadable(full_path) == 1 then
							return full_path
						end
					end
					return nil
				end

				local settings_path = find_launch_settings()
				if not settings_path then
					print("Warning: launchSettings.json not found")
					return {
						ASPNETCORE_ENVIRONMENT = "Development",
						ASPNETCORE_URLS = "http://localhost:5000",
					}
				end

				local content = vim.fn.readfile(settings_path)
				local json_str = table.concat(content, "\n")
				local ok, settings = pcall(vim.json.decode, json_str)

				if not ok then
					print("Error parsing launchSettings.json")
					return {
						ASPNETCORE_ENVIRONMENT = "Development",
						ASPNETCORE_URLS = "http://localhost:5000",
					}
				end

				-- Get environment variables from the "http" profile
				local env_vars = settings.profiles.http.environmentVariables or {}

				-- Always ensure these basic variables are set
				env_vars.ASPNETCORE_ENVIRONMENT = env_vars.ASPNETCORE_ENVIRONMENT or "Development"
				env_vars.ASPNETCORE_URLS = env_vars.ASPNETCORE_URLS or "http://localhost:5000"

				return env_vars
			end

			-- Get the platform-specific netcoredbg path
			local function get_debugger_path()
				if uname == "Windows_NT" then
					return "C:\\Users\\marni\\scoop\\shims\\netcoredbg"
				elseif uname == "Linux" or uname == "Darwin" then
					return "/usr/local/netcoredbg"
				else
					print("Unsupported operating system")
					return nil
				end
			end

			-- Get the platform-specific dll path format
			local function get_dll_path_format()
				if uname == "Windows_NT" then
					return "\\bin\\Debug\\net8.0\\"
				else
					return "/bin/Debug/net8.0/"
				end
			end

			local debugger_path = get_debugger_path()
			if not debugger_path then
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
							vim.fn.getcwd()
								.. get_dll_path_format()
								.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
								.. ".dll",
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
							vim.fn.getcwd()
								.. get_dll_path_format()
								.. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
								.. ".dll",
							"file"
						)
					end,
					env = function()
						return get_launch_settings()
					end,
					cwd = "${workspaceFolder}",
				},
			}
		end,
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
			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
			end)
			vim.keymap.set("n", "<F10>", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<Leader>b", function()
				require("dap").toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>B", function()
				require("dap").set_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>lp", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end)
			vim.keymap.set("n", "<Leader>dt", function()
				require("dap").terminate()
			end)

			-- Dap UI keymaps
			vim.keymap.set("n", "<Leader>dui", function()
				require("dapui").toggle()
			end)
		end,
	},
}

