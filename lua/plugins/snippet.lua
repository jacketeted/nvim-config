return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "v2.*",
	config = function()
		local ls = require("luasnip")
		vim.keymap.set({ "i" }, "<C-k>", function()
			ls.expand({})
		end, { silent = true })
		local lp = ls.snippet(
			{ trig = "gf" }, -- { trig = "prefix" }
			{
				ls.text_node({ "第一行代码" }),
				ls.text_node({ "第二行代码" }),
				ls.insert_node(1, "默认值"), -- 对应 $1 或 ${1:default}
				ls.text_node({ "其他代码" }),
				ls.insert_node(0), -- 对应 $0
			}
		)
		ls.add_snippets("all", { lp })
	end,
}
