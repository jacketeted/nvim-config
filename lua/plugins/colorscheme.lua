return {
	-- "folke/tokyonight.nvim",
	"sainnhe/sonokai",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd([[colorscheme sonokai]])
	end,
}
