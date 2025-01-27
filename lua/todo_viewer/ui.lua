local M = {}

local win_id = nil
local buf_id = nil
local main_win_id = nil  -- Store the main window ID

M.show_todo_panel = function()
    local todos = require("todo_viewer.search").search_todos()
    if #todos == 0 then
        print("No TODOs found")
        return
    end

    -- Store the current window (main editor window)
    main_win_id = vim.api.nvim_get_current_win()

    -- Check if buffer already exists
    if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        if win_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_set_current_win(win_id)
            return
        end
    else
        buf_id = vim.api.nvim_create_buf(false, true)
    end

    -- Make buffer modifiable before writing
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf_id })

    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, todos)

    -- Now make it non-editable
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf_id })

    -- **Open the panel on the RIGHT side**
    vim.cmd("botright vsplit")  -- This ensures the split happens on the right
    win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win_id, buf_id)
    vim.api.nvim_win_set_width(win_id, 50) -- Set panel width

    -- Apply window-local options
    vim.api.nvim_win_set_option(win_id, "wrap", true)
    vim.api.nvim_win_set_option(win_id, "linebreak", true)
    vim.api.nvim_win_set_option(win_id, "breakindent", true)

    -- Apply syntax highlighting
    vim.cmd("highlight TodoHighlight ctermfg=Yellow guifg=Yellow")
    vim.cmd("highlight FileHeader ctermfg=Blue guifg=Cyan")

    -- Highlight TODOs and filenames
    vim.fn.matchadd("TodoHighlight", "\\(TODO\\|FIXME\\|NOTE\\)")
    vim.fn.matchadd("FileHeader", "^[^:]*$")

    -- **Set 'l' keymap only for this buffer**
    vim.api.nvim_buf_set_keymap(buf_id, "n", "l", ":lua require('todo_viewer.ui').open_todo_at_line()<CR>", { noremap = true, silent = true })
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
    local file, lnum = line:match("^([^:]+)$")  -- Check if it's a file header

    -- Switch focus to main window before opening file
    if main_win_id and vim.api.nvim_win_is_valid(main_win_id) then
        vim.api.nvim_set_current_win(main_win_id)
    end

    if file then
        vim.cmd("e " .. file)  -- Open file in the main window
        return
    end

    file, lnum = line:match("([^:]+):(%d+)") -- Extract filename & line number

    if file and lnum then
        vim.cmd("e " .. file)  -- Open file in main window
        vim.cmd(lnum)  -- Jump to line number
    end
end

return M
