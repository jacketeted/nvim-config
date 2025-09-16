local buf_swap = require("config.helpers.buf_swap")
-- Toggle line number
vim.api.nvim_create_user_command("ToggleLineNumber", function()
	vim.opt.nu = not vim.opt.number:get()
	vim.opt.rnu = not vim.opt.relativenumber:get()
end, {})

vim.api.nvim_create_user_command("SwapNextBuffer", function()
	buf_swap(function(current_index, total)
		if current_index == total then
			return { next_index = 1 }
		else
			return { next_index = current_index + 1 }
		end
	end)
end, {
	desc = "Swap to next buffer",
})
vim.api.nvim_create_user_command("SwapPrevBuffer", function()
	buf_swap(function(current_index, total)
		if current_index == 1 then
			return { next_index = total }
		else
			return { next_index = current_index - 1 }
		end
	end)
end, {
	desc = "Swap to previous buffer",
})
vim.api.nvim_create_user_command("JumpForwardSameIndent", function()
	local current_line_number = vim.fn.line(".")
	local current_indent = vim.fn.indent(current_line_number)
	local total_lines = vim.fn.line("$")
	if current_line_number == total_lines then
		return
	end
	for i = current_line_number + 1, total_lines, 1 do
		if current_indent == vim.fn.indent(i) then
			vim.api.nvim_win_set_cursor(0, { i, 0 })
			vim.cmd("normal! $")
			return
		end
	end
end, {})
vim.api.nvim_create_user_command("JumpBackwardSameIndent", function()
	local current_line_number = vim.fn.line(".")
	local current_indent = vim.fn.indent(current_line_number)
	if current_line_number == 1 then
		return
	end
	for i = current_line_number - 1, 1, -1 do
		if current_indent == vim.fn.indent(i) then
			vim.api.nvim_win_set_cursor(0, { i, 0 })
			return
		end
	end
end, {})
