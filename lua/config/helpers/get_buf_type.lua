---@param bufid number
---@return "terminal"|"nvim tree"|"no name"|"directory"|"file"|"Lualine Notices"|"Neotest Output Panel"|"others"
local function get_buf_type(bufid)
	local bufname = vim.api.nvim_buf_get_name(bufid)
	local return_value
	if string.sub(bufname, 1, 7) == "term://" then
		return_value = "terminal"
	elseif string.sub(bufname, -10, -1) == "NvimTree_1" then
		return_value = "nvim tree"
	elseif string.sub(bufname, -15, -1) == "Lualine Notices" then
		return_value = "Lualine Notices"
	elseif string.sub(bufname, -20, -1) == "Neotest Output Panel" then
		return_value = "Neotest Output Panel"
	elseif bufname == "" then
		return_value = "no name"
	elseif vim.fn.isdirectory(bufname) == 1 then
		return_value = "directory"
	elseif vim.fn.filereadable(bufname) == 1 then
		return_value = "file"
	else
		-- print("unrecognized buf type, buf name: " .. bufname)
		return_value = "others"
	end
	return return_value
end

return get_buf_type
