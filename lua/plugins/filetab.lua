local get_buf_type = require("config.helpers.get_buf_type")
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				custom_filter = function(buf, _)
					local buftype = get_buf_type(buf)
					return buftype == "file"
				end,
			},
		})
	end,
}
