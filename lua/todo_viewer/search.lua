local M = {}

M.search_todos = function()
	local cmd = "rg --column --line-number --no-heading --color=never '(TODO|FIXME|NOTE)'"
	local result = vim.fn.systemlist(cmd)
	return result
end

return M
