return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"artemave/workspace-diagnostics.nvim",
		},
		opts = {
			servers = {
				lua_ls = {
					on_attach = function(client, bufnr)
						require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					end,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "describe", "it", "assert", "spy" },
							},
						},
					},
				},
				ts_ls = {
					on_attach = function(client, bufnr)
						require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					end,
				},
				eslint = {},
				tailwindcss = {},
				bashls = {},
			},
		},
		config = function(_, opts)
			require("mason").setup({})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"eslint",
					"ts_ls",
					"bashls",
					"cssls",
				},
			})

			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
}
