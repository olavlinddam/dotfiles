return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- dap.defaults.fallback.exception_breakpoints = { "raised", "uncaught" }

		dapui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			element_mappings = {},
			expand_lines = true,
			floating = {
				border = "rounded",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			force_buffers = true,
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			layouts = {
				{
					elements = {
						{
							id = "scopes",
							size = 0.25,
						},
						{
							id = "breakpoints",
							size = 0.25,
						},
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "watches",
							size = 0.25,
						},
					},
					position = "right",
					size = 50,
				},
				{
					elements = {
						{
							id = "repl",
							size = 0.5,
						},
						{
							id = "console",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 10,
				},
			},
			mappings = {
				edit = "e",
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				repl = "r",
				toggle = "t",
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		})

		-- HELPER FUNCTIONS FOR DOTNET
		-- Get the platform-specific netcoredbg path
		local function get_debugger_path()
			if uname == "Windows_NT" then
				return "C:\\Users\\olav\\scoop\\shims\\netcoredbg"
			elseif uname == "Linux" or uname == "Darwin" then
				return "/usr/local/netcoredbg"
			else
				print("Unsupported operating system")
				return nil
			end
		end

		local dotnet_build_project = function()
			local default_path = vim.fn.getcwd() .. "/"

			if vim.g["dotnet_last_proj_path"] ~= nil then
				default_path = vim.g["dotnet_last_proj_path"]
			end

			local path = vim.fn.input("Path to your *proj file", default_path, "file")

			vim.g["dotnet_last_proj_path"] = path

			local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"

			print("")
			print("Cmd to execute: " .. cmd)

			local f = os.execute(cmd)

			if f == 0 then
				print("\nBuild: ✔️ ")
			else
				print("\nBuild: ❌ (code: " .. f .. ")")
			end
		end

		local dotnet_get_dll_path = function()
			local request = function()
				return vim.fn.input("Path to dll to debug: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
			end

			if vim.g["dotnet_last_dll_path"] == nil then
				vim.g["dotnet_last_dll_path"] = request()
			else
				if
					vim.fn.confirm("Change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2) == 1
				then
					vim.g["dotnet_last_dll_path"] = request()
				end
			end

			return vim.g["dotnet_last_dll_path"]
		end

		dap.adapters.coreclr = {
			type = "executable",
			command = "C:\\Users\\olav\\scoop\\shims\\netcoredbg.exe",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					if vim.fn.confirm("Rebuild first?", "&yes\n&no", 2) == 1 then
						dotnet_build_project()
					end

					return dotnet_get_dll_path()
				end,
			},
		}

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<Leader>dca", dap.clear_breakpoints, { desc = "Clear all breakpoints" })
		vim.keymap.set("n", "<Leader>dla", dap.list_breakpoints, { desc = "List all breakpoints" })
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "si", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end)

		local continue = function()
			local cwd = vim.fn.getcwd()
			print(cwd .. "/.vscode/launch.json")
			local path = cwd .. "\\.vscode\\launch.json"
			print(path)
			if vim.fn.filereadable(path) then -- Use the path variable we created above
				require("dap.ext.vscode").load_launchjs()
			end
			dap.continue()
		end
		vim.keymap.set("n", "<Leader>dc", continue, { desc = "Continue" })
	end,
}
