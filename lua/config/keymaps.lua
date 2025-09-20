local get_buf_type = require("config.helpers.get_buf_type")
local terminal_manager = require("config.helpers.terminal_manager")
local filter = require("config.helpers.filter")
local kill_buffer = require("config.helpers.kill_buffer")
-----------------------------------------------------------
-- Normal Mode
-----------------------------------------------------------
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("n", "<leader>", "<nop>")
-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- Kill floating windows
vim.keymap.set("n", "<leader>kf", function()
	local windows = vim.api.nvim_list_wins()
	for _, value in ipairs(windows) do
		if vim.api.nvim_win_get_config(value).relative ~= "" then
			vim.api.nvim_win_close(value, true)
		end
	end
end)

-- Swap between split buffers
vim.keymap.set("n", "<C-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-Right>", ":wincmd l<CR>")
vim.keymap.set("n", "<C-Up>", "<C-w><Up>")
vim.keymap.set("n", "<C-Down>", function()
	vim.cmd("wincmd j")
end)

vim.keymap.set("t", "<C-w><Left>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n> <C-w><Left>", true, true, true), "t", true)
end)
vim.keymap.set("t", "<C-w><Up>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n> <C-w><Up>", true, true, true), "t", true)
end)

-- Jump to line with the same indent
vim.keymap.set("v", "<leader>jsi", function()
	vim.cmd("JumpForwardSameIndent")
end)

vim.keymap.set("n", "<leader>jsi", ":JumpForwardSameIndent<CR>")
vim.keymap.set("v", "<leader>ksi", function()
	vim.cmd("JumpBackwardSameIndent")
end)

vim.keymap.set("n", "<leader>ksi", ":JumpBackwardSameIndent<CR>")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Little one from Primeagen to mass replace string in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false })

-- Navigate through buffers
vim.keymap.set("n", "<leader><Right>", function()
	vim.cmd("SwapNextBuffer")
end, { silent = false })

vim.keymap.set("n", "<leader><Left>", function()
	vim.cmd("SwapPrevBuffer")
end, { silent = false })
-- Kill buffers with the same buftype
vim.keymap.set("n", "<leader>kb", function()
	local current_buf = vim.api.nvim_get_current_buf()
	vim.cmd("SwapNextBuffer")
	kill_buffer(current_buf)
end)
-- Kill all buffer of the same type except current buffer
vim.keymap.set("n", "<leader>kab", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_buftype = get_buf_type(current_buf)
	local filtered_bufs = filter(vim.api.nvim_list_bufs(), function(value)
		local buftype = get_buf_type(value)
		return buftype == current_buftype and value ~= current_buf
	end)
	for _, value in ipairs(filtered_bufs) do
		kill_buffer(value)
	end
end)

-- Close currently active buffer
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Center buffer when navigating up and down
vim.keymap.set("n", "<S-Up>", "<C-u>zz")
vim.keymap.set("n", "<S-Down>", "<C-d>zz")

-- Terminal management
vim.keymap.set("n", "<leader>tb", terminal_manager.open_bottom_terminal, { silent = false })

vim.keymap.set("n", "<leader>tf", ":term<CR>", { silent = false })
vim.keymap.set("n", "<leader>tr", terminal_manager.open_right_terminal, { silent = false })

vim.keymap.set("t", "<C-t>c", "<C-\\><C-n> :q<CR>", { silent = false })
vim.keymap.set("t", "<C-k>b", function()
	vim.api.nvim_input(
		vim.api.nvim_replace_termcodes("<C-b>:", true, true, true)
			.. "kill-session"
			.. vim.api.nvim_replace_termcodes("<CR>", true, true, true)
	)
end)

-- Center buffer when progressing through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Toggle line number
vim.keymap.set("n", "<leader>ln", ":ToggleLineNumber<CR>")

-- Paste without replacing paste with what you are highlighted over
vim.keymap.set("n", "<leader>p", '"_dP')

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Open buffer to the right
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

-----------------------------------------------------------
-- Visual Mode
-----------------------------------------------------------
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("v", "<leader>", "<nop>")

-- Move selection up and down
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_autocmd(
	"LspAttach",
	{ --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			-- Open the diagnostic under the cursor in a float window
			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts)
		end,
	}
)
