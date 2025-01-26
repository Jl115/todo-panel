local M = {}

local win_id = nil
local buf_id = nil

M.show_todo_panel = function()
	local todos = require("todo_viewer.search").search_todos()
	if #todos == 0 then
		print("No TODOs found")
		return
	end

	buf_id = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, todos)

	vim.bo[buf_id].modifiable = false
	vim.bo[buf_id].buftype = "nofile"

	vim.cmd("vsplit")
	win_id = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win_id, buf_id)
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
	local file, lnum = line:match("([^:]+):(%d+):")

	if file and lnum then
		vim.cmd("e " .. file)
		vim.cmd(lnum)
	end
end

return M
