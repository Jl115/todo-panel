local M = {}

local ui = require("todo_viewer.ui")

M.toggle_todo_panel = function()
	ui.toggle_todo_panel()
end

M.setup = function()
	vim.api.nvim_set_keymap(
		"n",
		"<leader>t",
		":lua require('todo_viewer').toggle_todo_panel()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"l",
		":lua require('todo_viewer.ui').open_todo_at_line()<CR>",
		{ noremap = true, silent = true }
	)
end

return M
