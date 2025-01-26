# TODO Viewer.nvim

A Neovim plugin that finds and displays TODOs (`TODO`, `FIXME`, `NOTE`) in a right-side panel.

## Installation

For **LazyVim**:

```lua
{
    "Jl115/todo-viewer.nvim",
    config = function()
        require("todo_viewer").setup()
    end
}

