local M = {}

local win_id = nil
local buf_id = nil

M.show_todo_panel = function()
	local todos = require("todo_viewer.search").search_todos()
	if #todos == 0 then
		print("No TODOs found")
		return
	end

	-- Create a scratch buffer
	buf_id = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, todos)

	-- Make buffer non-editable
	vim.bo[buf_id].modifiable = false
	vim.bo[buf_id].buftype = "nofile"

	-- Open vertical split and set width to 50
	vim.cmd("vsplit")
	win_id = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win_id, buf_id)
	vim.api.nvim_win_set_width(win_id, 50)

	-- Apply syntax highlighting
	vim.cmd("highlight TodoHighlight ctermfg=Yellow guifg=Yellow")
	vim.cmd("highlight FileHeader ctermfg=Blue guifg=Cyan") -- Color for filenames

	-- Highlight TODOs and filenames
	vim.fn.matchadd("TodoHighlight", "\\(TODO\\|FIXME\\|NOTE\\)")
	vim.fn.matchadd("FileHeader", "^[^:]*$")
end

M.toggle_todo_panel = function()
	if win_id and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
		win_id = nil
	else
		M.show_todo_panel()
	end
end

M.open_todo_at_line = function()
	local line = vim.api.nvim_get_current_line()
	local file, lnum = line:match("^([^:]+)$") -- Check if it's a file header

	if file then
		vim.cmd("e " .. file) -- Open file only
		return
	end

	file, lnum = line:match("([^:]+):(%d+)") -- Extract filename & line number

	if file and lnum then
		vim.cmd("e " .. file) -- Open file in main buffer
		vim.cmd(lnum) -- Jump to line number
	end
end

return M
