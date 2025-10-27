-- ==============================================================================
-- Custom User Commands
-- ==============================================================================
-- Useful custom commands for common operations
-- ==============================================================================

local command = vim.api.nvim_create_user_command

-- ==============================================================================
-- File Operations
-- ==============================================================================

-- Sudo write (save file with sudo)
command("W", "w !sudo tee > /dev/null %", {
    desc = "Save file with sudo"
})

-- Delete current file and buffer
command("Delete", function()
    local file = vim.fn.expand("%:p")
    vim.cmd("bdelete!")
    vim.fn.delete(file)
end, {
    desc = "Delete current file and buffer"
})

-- Rename current file
command("Rename", function(opts)
    local old_name = vim.fn.expand("%:p")
    local new_name = opts.args
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    vim.cmd("bdelete " .. old_name)
end, {
    nargs = 1,
    complete = "file",
    desc = "Rename current file"
})

-- ==============================================================================
-- Buffer Operations
-- ==============================================================================

-- Delete all buffers except current
command("BufOnly", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, {})
        end
    end
end, {
    desc = "Delete all buffers except current"
})

-- Close all buffers
command("BufCloseAll", "%bd", {
    desc = "Close all buffers"
})

-- ==============================================================================
-- Window Operations
-- ==============================================================================

-- Close all other windows
command("WinOnly", "only", {
    desc = "Close all other windows"
})

-- ==============================================================================
-- Formatting
-- ==============================================================================

-- Remove trailing whitespace
command("TrimWhitespace", [[%s/\s\+$//e]], {
    desc = "Remove trailing whitespace"
})

-- Convert tabs to spaces
command("TabsToSpaces", "set expandtab | retab", {
    desc = "Convert tabs to spaces"
})

-- Convert spaces to tabs
command("SpacesToTabs", "set noexpandtab | retab!", {
    desc = "Convert spaces to tabs"
})

-- Format JSON
command("FormatJSON", "%!python3 -m json.tool", {
    desc = "Format JSON file"
})

-- ==============================================================================
-- Search and Replace
-- ==============================================================================

-- Case-insensitive search and replace
command("ReplaceAll", function(opts)
    vim.cmd(":%s/" .. opts.args .. "/gc")
end, {
    nargs = 1,
    desc = "Interactive search and replace"
})

-- ==============================================================================
-- Information
-- ==============================================================================

-- Show file info
command("FileInfo", function()
    local file = vim.fn.expand("%:p")
    local size = vim.fn.getfsize(file)
    local lines = vim.api.nvim_buf_line_count(0)
    local ft = vim.bo.filetype

    print(string.format([[
File: %s
Size: %d bytes
Lines: %d
Type: %s
    ]], file, size, lines, ft))
end, {
    desc = "Show file information"
})

-- ==============================================================================
-- Diff
-- ==============================================================================

-- Diff current buffer with file on disk
command("DiffOrig", function()
    local scratch = vim.api.nvim_create_buf(false, true)
    local orig = vim.api.nvim_get_current_buf()
    vim.cmd("vertical sbuffer " .. scratch)
    vim.cmd("read ++edit #")
    vim.cmd("0d_")
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end, {
    desc = "Diff with original file"
})

-- ==============================================================================
-- Quick Edits
-- ==============================================================================

-- Open init.lua
command("EditInit", "e ~/.config/nvim/init.lua", {
    desc = "Edit init.lua"
})

-- Open vimrc-equivalent
command("EditVimrc", "e ~/.config/nvim/init.lua", {
    desc = "Edit init.lua"
})

-- ==============================================================================
-- Terminal
-- ==============================================================================

-- Open horizontal terminal
command("TermH", "split | terminal", {
    desc = "Open horizontal terminal"
})

-- Open vertical terminal
command("TermV", "vsplit | terminal", {
    desc = "Open vertical terminal"
})

-- ==============================================================================
-- Help
-- ==============================================================================

-- Quick access to nvim-core help
command("CoreHelp", function()
    print([[
nvim-core - Zero-plugin Neovim configuration

Leader key: Space

File Navigation:
  <leader>pv   - File explorer
  <leader>pf   - Find file
  <leader>ps   - Grep search

Clipboard:
  <leader>y    - Yank to clipboard
  <leader>p    - Paste from clipboard

Windows:
  <C-h/j/k/l>  - Navigate windows
  <leader>sv   - Vertical split
  <leader>sh   - Horizontal split

Quick Actions:
  <leader>w    - Save
  <leader>q    - Quit
  <leader>x    - Make executable

For more: :help nvim-core
    ]])
end, {
    desc = "Show nvim-core help"
})
