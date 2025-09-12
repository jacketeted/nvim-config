return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	opts = function()
		local cmp = require("cmp")

		return {
			mapping = cmp.mapping.preset.insert({
				["<Down>"] = cmp.mapping.select_next_item(),

				["<Up>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm(),
				["<C><leader>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		}
	end,
}
