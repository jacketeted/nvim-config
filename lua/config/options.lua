-----------------------------------------------------------
-- General
-----------------------------------------------------------
-- Set leader key to space
vim.g.mapleader = " "
-- Set leader key to space
vim.g.maplocalleader = " "

-- Number of spaces a tab represents
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
-- Disable mouse
vim.opt.mouse = ""

-- Use appropriate when using indent command
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Indenting correctly after { etc
vim.opt.smartindent = true

-- Copy indent from current line when starting new line
vim.opt.autoindent = true

-- Prevent line wrapping
vim.opt.breakindent = true

-- Disable text wrap
vim.opt.wrap = true

-- Speeds up plugin wait time
vim.opt.updatetime = 50

-- Persistant undo file history
vim.opt.undofile = true
-----------------------------------------------------------
-- UI Config
-----------------------------------------------------------
-- Enable line numbers
vim.opt.nu = true

-- Enable relative line numbers
vim.opt.rnu = true

-- Disable showing the mode below the statusline
vim.opt.showmode = false

-- Better completion experience
vim.opt.completeopt = { "menuone", "noselect" }

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Faster scrolling
vim.opt.lazyredraw = true
-- Highlight yank
vim.api.nvim_create_autocmd("textyankpost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- Auto save and auto refresh
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		-- Format and save before changing buffer
		local current_win = vim.api.nvim_get_current_win()
		local win_config = vim.api.nvim_win_get_config(current_win)
		if
			vim.bo.modifiable
			and vim.bo.modified
			and win_config.relative == "" -- Window is not float window
		then
			require("conform").format({ async = false })
			vim.cmd("w")
		end
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		-- Auto update buffer if file content is changed by another process
		vim.cmd("checktime")
	end,
})

-- Toggle line number
vim.api.nvim_create_user_command("ToggleLineNumber", function()
	vim.opt.nu = not vim.opt.number:get()
	vim.opt.rnu = not vim.opt.relativenumber:get()
end, {})

-----------------------------------------------------------
-- Search Config
-----------------------------------------------------------
-- Enable highlighting search in progress
vim.opt.incsearch = true

-- Ignore case for searches
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Diagnostic display inline
vim.diagnostic.config({
	update_in_insert = true,
	virtual_text = require("config.screen_size").sm == false and true or false,
	-- virtual_lines = true,
	float = true,
	underline = true,
})
