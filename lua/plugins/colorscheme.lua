return {
	"folke/tokyonight.nvim",
	"sainnhe/sonokai",
	{
		"savq/melange-nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd("colorscheme " .. require("config.myconfig").theme)

			-- Set custom cursor colors
			local cursor_color = require("config.myconfig").cursor_color
			vim.api.nvim_set_hl(0, "MyNormalCursor", { bg = cursor_color }) -- Green cursor
			vim.api.nvim_set_hl(0, "MyInsertCursor", { bg = cursor_color }) -- Red cursor
			vim.o.guicursor = "n-v-c:block-MyNormalCursor,i-ci-ve:ver25-MyInsertCursor,r-cr:hor20"

			-- Set Copilot suggestion color
			vim.api.nvim_set_hl(0, "MyGhostText", {
				fg = require("config.myconfig").copilot_suggestion_color,
				bg = "NONE",
			})
			vim.api.nvim_set_hl(0, "CopilotSuggestion", {
				link = "MyGhostText",
			})

			vim.api.nvim_set_hl(0, "NvimDapVirtualText", {
				link = "MyGhostText",
			})
		end,
	},
}
