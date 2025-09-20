local kill_buffer = require("config.helpers.kill_buffer")
local filter = require("config.helpers.filter")
local get_buf_type = require("config.helpers.get_buf_type")
local should_save_session = false
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		local buftype = get_buf_type(vim.api.nvim_get_current_buf())
		if buftype == "nvim tree" then
			if vim.fn.filereadable("./Session.vim") == 1 then
				vim.cmd("source ./Session.vim")
				vim.cmd("leftabove vsplit")
				vim.cmd("NvimTreeOpen")
			end
			should_save_session = true
		end
	end,
	-- other plugins can be triggered
	nested = true,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if should_save_session == true then
			local non_file_bufs = filter(vim.api.nvim_list_bufs(), function(value)
				return get_buf_type(value) ~= "file"
			end)
			for _, value in ipairs(non_file_bufs) do
				kill_buffer(value)
			end
			vim.cmd("mksession!")
		end
	end,
	-- other plugins can be triggered
	nested = true,
})

vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		-- Format and save before changing buffer
		if get_buf_type(vim.api.nvim_get_current_buf()) == "file" and vim.bo.modified then
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
		local buf_type = get_buf_type(vim.api.nvim_get_current_buf())
		if buf_type == "terminal" then
			vim.cmd("startinsert")
		elseif buf_type == "file" then
			-- Auto update buffer if file content is changed by another process

			vim.cmd("checktime")
		end
	end,
})
