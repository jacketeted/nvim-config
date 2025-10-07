return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"marilari88/neotest-vitest",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = function(path)
						return "jest.config.mts"
					end,
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-vitest")({
					jestCommand = "npm test --",
					jestConfigFile = function(path)
						return "vitest.config.mts"
					end,
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})
	end,
}

--[[ return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-jest",
		},
		keys = {
			{ "<leader>tr", "<cmd>Neotest run<cr>" },
			{ "<leader>ti", "<cmd>Neotest output<cr>" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>" },
			{ "<leader>ta", "<cmd>lua require('neotest').run.run({ suite = true })<cr>" },
		},
		config = function()
			require("neotest").setup({
				settings = {
					watch = true,
				},
				adapters = {
					require("neotest-vitest"),
					require("neotest-jest"),
				},
			})
		end,
	},
} ]]
