local filter = require("config.helpers.filter")
local get_has_attached_window = require("config.helpers.get_has_attached_window")

-- Terminal
local terminal_lines
if require("config.screen_size").sm == false then
	terminal_lines = 10
else
	terminal_lines = 8
end
local function terminal_manager_closure()
	local bottom_term_winids = {}
	local function has_winid(winid)
		for _, value in ipairs(bottom_term_winids) do
			if value == winid then
				return true
			end
		end
		return false
	end
	return {
		open_right_terminal = function()
			if vim.bo.buftype ~= "terminal" then
				return
			end
			vim.cmd("vsp")
			vim.cmd("term")
			table.insert(bottom_term_winids, vim.api.nvim_get_current_win())
		end,
		open_bottom_terminal = function()
			local wins = vim.api.nvim_list_wins()
			for _, value in ipairs(wins) do
				-- Bottom terminal window already exists
				if has_winid(value) then
					vim.api.nvim_set_current_win(value)
					return
				end
			end
			local filtered_bufs = {}
			filtered_bufs = filter(vim.api.nvim_list_bufs(), function(value)
				local buftype = vim.api.nvim_get_option_value("buftype", { buf = value })
				return "terminal" == buftype
			end)
			filtered_bufs = filter(filtered_bufs, function(value)
				local has_attached_window = get_has_attached_window(value, wins)
				return has_attached_window == false
			end)

			if #filtered_bufs == 0 then
				vim.cmd("sp")
				vim.cmd("term")
				vim.cmd("resize " .. terminal_lines)
			else
				vim.cmd("sp")
				vim.cmd("resize " .. terminal_lines)
				local win_id = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_buf(win_id, filtered_bufs[1])
			end
			bottom_term_winids = {}
			table.insert(bottom_term_winids, vim.api.nvim_get_current_win())
			--- Prevent nvim.tree to change the terminal window size
			vim.cmd("set winfixheight")
		end,
	}
end
local terminal_manager = terminal_manager_closure()
return terminal_manager
