local get_buf_type = require("config.helpers.get_buf_type")
local function kill_buffer(bufid)
	local buftype = get_buf_type(bufid)
	if buftype == "terminal" then
		vim.api.nvim_buf_delete(bufid, { force = true })
	elseif buftype == "file" then
		vim.api.nvim_buf_delete(bufid, { force = false })
	else
		vim.api.nvim_buf_delete(bufid, { force = true })
	end
end
return kill_buffer
