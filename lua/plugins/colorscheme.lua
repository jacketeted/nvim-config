return {
	"folke/tokyonight.nvim",
	"sainnhe/sonokai",
	{
		"savq/melange-nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme tokyonight-day]])
		end,
	},
}
