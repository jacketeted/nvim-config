return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
		},
		config = function()
			local dap = require("dap")
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}
			vim.fn.sign_define("DapBreakpoint", { text = "⬤" })
			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
			vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { noremap = true })
			vim.keymap.set("n", "<leader>dc", require("dap").continue, { noremap = true })
			vim.keymap.set("n", "<leader>dd", require("dap").disconnect, { noremap = true })
			vim.keymap.set("n", "<leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<leader>dh", function()
				local widgets = require("dap.ui.widgets")
				widgets.hover()
			end)
			vim.keymap.set("n", "<leader>dl", function()
				require("osv").launch({ port = 8086 })
			end, { noremap = true })

			vim.keymap.set("n", "<leader>dr", require("dap").restart, { noremap = true })
			vim.keymap.set("n", "<leader>ds", require("dap").close, { noremap = true })
			vim.keymap.set("n", "<leader>dt", require("dap").run_to_cursor, { noremap = true })
			vim.keymap.set("n", "<leader>d<Down>", require("dap").step_over, { noremap = true })
			vim.keymap.set("n", "<leader>d<Right>", require("dap").step_into, { noremap = true })
			vim.keymap.set("n", "<leader>d<Left>", require("dap").step_out, { noremap = true })
			vim.keymap.set("n", "<leader>d<Up>", require("dap").step_back, { noremap = true })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup({
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.5,
							},
							{
								id = "repl",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			vim.keymap.set("n", "<leader>du", require("dapui").toggle, { noremap = true })
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value:gsub("%s+", " ")
					else
						return variable.name .. " = " .. variable.value:gsub("%s+", " ")
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				-- experimental features:
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})
		end,
	},
}
