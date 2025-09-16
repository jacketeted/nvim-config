local filter = require("config.helpers.filter")
local get_has_attached_window = require("config.helpers.get_has_attached_window")
---@param callback fun(current_index:number,total:number):{next_index:number}
---@return nil
local function buf_swap(callback)
	local current_buf_id = vim.api.nvim_get_current_buf()
	local current_buftype = vim.bo.buftype
	local bufs = vim.api.nvim_list_bufs()
	local filtered_bufs = {}
	filtered_bufs = filter(bufs, function(value)
		print(vim.api.nvim_buf_get_name(value))
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = value })
		return current_buftype == buftype
	end, current_buf_id)
	local wins = vim.api.nvim_list_wins()
	filtered_bufs = filter(filtered_bufs, function(value)
		local has_attached_window = get_has_attached_window(value, wins)
		return has_attached_window == false
	end, current_buf_id)
	filtered_bufs = filter(filtered_bufs, function(value)
		local bufname = vim.api.nvim_buf_get_name(value)

		return vim.fn.isdirectory(bufname) ~= 1
	end, current_buf_id)

	local current_index = -1
	for index, value in ipairs(filtered_bufs) do
		if value == current_buf_id then
			current_index = index
			break
		end
	end
	if #filtered_bufs == 1 then
		return
	end
	local result = callback(current_index, #filtered_bufs)
	vim.api.nvim_set_current_buf(filtered_bufs[result.next_index])
end

return buf_swap
