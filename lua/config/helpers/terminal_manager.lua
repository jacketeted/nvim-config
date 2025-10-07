-- Terminal
local function terminal_manager_closure()
	local term_winid = -1
	local tmux_session_id = -1
	local term_bufid = -1
	---@generic T
	---@param items T[]
	---@param item T
	local function indexof(items, item)
		for i, value in ipairs(items) do
			if item == value then
				return i
			end
		end
		return -1
	end
	---@param open_new_window_func fun():nil
	local function open_terminal(open_new_window_func)
		local winids = vim.api.nvim_list_wins()
		-- if terminal window already exists, set it to current window
		if indexof(winids, term_winid) ~= -1 then
			vim.api.nvim_set_current_win(term_winid)
			return
		end

		if indexof(vim.api.nvim_list_bufs(), term_bufid) == -1 then
			tmux_session_id = os.time()
			open_new_window_func()
			vim.cmd("term tmux new -s " .. tmux_session_id)
			term_bufid = vim.api.nvim_get_current_buf()
			vim.cmd("startinsert")
		else
			open_new_window_func()
			vim.api.nvim_win_set_buf(term_winid, term_bufid)
			vim.cmd("startinsert")
		end
		term_winid = vim.api.nvim_get_current_win()

		--- Prevent other plugins to change the terminal window size
		vim.cmd("set winfixheight")
	end
	return {
		open_bottom_terminal = function()
			open_terminal(function()
				vim.cmd("sp")
				vim.cmd("resize " .. require("config.myconfig").bottom_terminal_height)
			end)
		end,
		open_right_terminal = function()
			open_terminal(function()
				vim.cmd("vsp")
			end)
		end,
		kill_terminal = function()
			if indexof(vim.api.nvim_list_bufs(), term_bufid) ~= -1 then
				vim.api.nvim_buf_delete(term_bufid, { force = true })
				term_bufid = -1
				vim.system({ "tmux", "kill-session", "-t", "" .. tmux_session_id })
				tmux_session_id = -1
			end
		end,
	}
end
local terminal_manager = terminal_manager_closure()
return terminal_manager
