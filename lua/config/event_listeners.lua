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
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		-- Auto update buffer if file content is changed by another process
		vim.cmd("checktime")
	end,
})
