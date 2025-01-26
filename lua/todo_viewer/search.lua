local M = {}

M.search_todos = function()
	local cmd = "rg --column --line-number --no-heading --color=never '(TODO|FIXME|NOTE)'"
	local results = vim.fn.systemlist(cmd)

	if #results == 0 then
		return {}
	end

	local grouped_todos = {}
	local last_file = nil

	for _, line in ipairs(results) do
		local file, lnum, todo_text = line:match("([^:]+):(%d+):(.*)")
		if file and lnum and todo_text then
			if last_file ~= file then
				table.insert(grouped_todos, file) -- Add filename as a header
				last_file = file
			end
			table.insert(grouped_todos, "  " .. lnum .. ": " .. todo_text) -- Indent TODOs
		end
	end

	return grouped_todos
end

return M
