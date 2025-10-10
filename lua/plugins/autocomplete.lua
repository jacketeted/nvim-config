return {
	{
		-- Auto paired parenthesis, square brackets or curly braces
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		-- HTML tag auto pair and auto rename functionality
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
