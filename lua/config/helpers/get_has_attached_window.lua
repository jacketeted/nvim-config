return function
(bufid, winids)
	for _, value in ipairs(winids) do
		if vim.api.nvim_win_get_buf(value) == bufid then
			return true
		end
	end
	return false
end
