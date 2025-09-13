function my_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
	api.config.mappings.default_on_attach(bufnr)
	-- custom mappings
	vim.keymap.set("n", "<CR>", function()
		api.node.open.edit()
		if api.tree.get_node_under_cursor().type == "file" then
			if vim.fn.winwidth(0) <= 50 then
				vim.cmd("NvimTreeClose")
			end
		end
	end, opts("Open file"))
end

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>" },
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			on_attach = my_on_attach,
		})
	end,
}
