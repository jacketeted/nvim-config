return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					accept_word = "<C-w>",
					accept_line = "<C-l>",
				},
			},
			filetypes = {
				markdown = true,
				yaml = true,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
	},

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "1.*",
		opts = {
			enabled = function()
				if vim.bo.filetype == "markdown" or vim.bo.filetype == "copilot-chat" then
					return false
				else
					return true
				end
			end,
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-s>"] = { "show" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = true } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	-- Completion of Lua content exported by third party modules
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
