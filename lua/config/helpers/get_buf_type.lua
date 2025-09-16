---@param bufid number
---@return "terminal"|"nvim tree"|"no name"|"directory"|"file"
local function get_buf_type(bufid)
	local bufname = vim.api.nvim_buf_get_name(bufid)
	if string.sub(bufname, 1, 7) == "term://" then
		return "terminal"
	elseif string.sub(bufname, -10, -1) then
		return "nvim tree"
	elseif bufname == "" then
		return "no name"
	elseif vim.fn.isdirectory(bufname) then
		return "directory"
	elseif vim.fn.filereadable(bufname) then
		return "file"
	end
end

return get_buf_type
