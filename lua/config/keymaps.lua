-----------------------------------------------------------
-- Normal Mode
-----------------------------------------------------------
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("n", "<leader>", "<nop>")
-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- Kill floating windows
vim.keymap.set("n", "<leader>kf", function()
	local windows = vim.api.nvim_list_wins()
	for _, value in ipairs(windows) do
		if vim.api.nvim_win_get_config(value).relative ~= "" then
			vim.api.nvim_win_close(value, true)
		end
	end
end)
---@generic T
---@param elems T[]
---@param predicate fun(value:T):boolean
---@param must_have_elem T|nil
---@return table
local function filter(elems, predicate, must_have_elem)
	local filtered_bufs = {}
	for _, value in ipairs(elems) do
		if must_have_elem ~= nil and must_have_elem == value then
			table.insert(filtered_bufs, value)
			goto continue
		end
		if predicate(value) then
			table.insert(filtered_bufs, value)
		end

		::continue::
	end
	return filtered_bufs
end
local function get_has_attached_window(bufid, winids)
	for _, value in ipairs(winids) do
		if vim.api.nvim_win_get_buf(value) == bufid then
			return true
		end
	end
	return false
end

--[[ ---@param p_buftype string
---@param has_attached_window boolean?
---@param must_have_bufid number?
---@return number[]
local function get_filtered_bufs(p_buftype, has_attached_window, must_have_bufid)
	local bufs = vim.api.nvim_list_bufs()
	local filtered_bufs = {}
	filtered_bufs = filter(bufs, function(value)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = value })
		return p_buftype == buftype
	end, must_have_bufid)
	if has_attached_window ~= nil then
		local wins = vim.api.nvim_list_wins()
		filtered_bufs = filter(filtered_bufs, function(value)
			local r_has_attached_window = get_has_attached_window(value, wins)
			return r_has_attached_window == has_attached_window
		end, must_have_bufid)
	end
	return filtered_bufs
end ]]
---@param callback fun(current_index:number,total:number):{next_index:number}
---@return nil
local function buf_swap(callback)
	local current_buf_id = vim.api.nvim_get_current_buf()
	local current_buftype = vim.bo.buftype
	local bufs = vim.api.nvim_list_bufs()
	local filtered_bufs = {}
	filtered_bufs = filter(bufs, function(value)
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

-- Swap between split buffers
vim.keymap.set("n", "<C-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-Right>", ":wincmd l<CR>")
vim.keymap.set("n", "<C-Up>", "<C-w><Up>")
vim.keymap.set("n", "<C-Down>", "<C-w><Down>")

-- Save and quit current file quicker
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

-- Little one from Primeagen to mass replace string in a file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false })

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
-- Navigate through buffers
vim.keymap.set("n", "<leader><Right>", function()
	vim.cmd("SwapNextBuffer")
end, { silent = false })

vim.keymap.set("n", "<leader><Left>", function()
	vim.cmd("SwapPrevBuffer")
end, { silent = false })
vim.keymap.set("n", "<leader>kb", function()
	local current_buf = vim.api.nvim_get_current_buf()
	vim.cmd("SwapNextBuffer")
	vim.api.nvim_buf_delete(current_buf, { force = true })
end)

-- Close currently active buffer
vim.keymap.set("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Center buffer when navigating up and down
vim.keymap.set("n", "<S-Up>", "<C-u>zz")
vim.keymap.set("n", "<S-Down>", "<C-d>zz")

-- Terminal
local terminal_lines
if require("config.screen_size").sm == false then
	terminal_lines = 10
else
	terminal_lines = 8
end
local function terminal_manager()
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
local manager = terminal_manager()
vim.keymap.set("n", "<leader>tb", manager.open_bottom_terminal, { silent = false })

vim.keymap.set("n", "<leader>tf", ":term<CR>", { silent = false })
vim.keymap.set("n", "<leader>tr", manager.open_right_terminal, { silent = false })
-- vim.keymap.set("n", "<leader>tr", ":vsp | term<CR>", { silent = false })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = false })
-- Center buffer when progressing through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Toggle line number
vim.keymap.set("n", "<leader>ln", ":ToggleLineNumber<CR>")

-- Paste without replacing paste with what you are highlighted over
vim.keymap.set("n", "<leader>p", '"_dP')

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Open buffer to the right
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

-----------------------------------------------------------
-- Visual Mode
-----------------------------------------------------------
-- Disable Space bar since it'll be used as the leader key
vim.keymap.set("v", "<leader>", "<nop>")

-- Move selection up and down
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_autocmd(
	"LspAttach",
	{ --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			-- Open the diagnostic under the cursor in a float window
			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts)
		end,
	}
)
