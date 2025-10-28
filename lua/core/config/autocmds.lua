-- ==============================================================================
-- Auto Commands
-- ==============================================================================
-- Automatic behaviors and file-type specific configurations
-- ==============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ==============================================================================
-- General Auto Commands
-- ==============================================================================

local general = augroup("General", { clear = true })

-- Auto-save when losing focus (SSH disconnection protection)
autocmd({ "FocusLost", "BufLeave" }, {
    group = general,
    pattern = "*",
    callback = function()
        -- Only save if buffer is modified, has a name, and is writable
        if vim.bo.modified and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
    desc = "Auto-save on focus lost or buffer leave"
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    group = general,
    pattern = "*",
    command = [[%s/\s\+$//e]],
    desc = "Remove trailing whitespace on save"
})

-- Highlight yanked text
autocmd("TextYankPost", {
    group = general,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
    desc = "Highlight yanked text"
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
    group = general,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Return to last edit position"
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
    group = general,
    pattern = "*",
    command = "tabdo wincmd =",
    desc = "Resize splits on window resize"
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
    group = general,
    pattern = { "qf", "help", "man", "lspinfo", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close with 'q' in certain filetypes"
})

-- ==============================================================================
-- File Type Specific Settings
-- ==============================================================================

local filetype_settings = augroup("FileTypeSettings", { clear = true })

-- Markdown
autocmd("FileType", {
    group = filetype_settings,
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.conceallevel = 2
    end,
    desc = "Markdown settings"
})

-- Git commit messages
autocmd("FileType", {
    group = filetype_settings,
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 72
    end,
    desc = "Git commit settings"
})

-- YAML
autocmd("FileType", {
    group = filetype_settings,
    pattern = { "yaml", "yml" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
    desc = "YAML 2-space indentation"
})

-- Python
autocmd("FileType", {
    group = filetype_settings,
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.textwidth = 88  -- Black formatter default
    end,
    desc = "Python settings"
})

-- Lua
autocmd("FileType", {
    group = filetype_settings,
    pattern = "lua",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
    desc = "Lua settings"
})

-- JSON
autocmd("FileType", {
    group = filetype_settings,
    pattern = "json",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
    desc = "JSON 2-space indentation"
})

-- ==============================================================================
-- Performance Optimizations
-- ==============================================================================

local performance = augroup("Performance", { clear = true })

-- Disable certain features for large files
autocmd("BufReadPre", {
    group = performance,
    pattern = "*",
    callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%"))
        if file_size > 1024 * 1024 then  -- 1MB
            vim.opt_local.spell = false
            vim.opt_local.swapfile = false
            vim.opt_local.undofile = false
            vim.opt_local.syntax = "off"
        end
    end,
    desc = "Optimize for large files"
})

-- ==============================================================================
-- Terminal Settings
-- ==============================================================================

local terminal = augroup("Terminal", { clear = true })

-- Start terminal in insert mode
autocmd("TermOpen", {
    group = terminal,
    pattern = "*",
    command = "startinsert",
    desc = "Start terminal in insert mode"
})

-- Disable line numbers in terminal
autocmd("TermOpen", {
    group = terminal,
    pattern = "*",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
    desc = "Disable UI elements in terminal"
})

-- ==============================================================================
-- Netrw Settings
-- ==============================================================================

local netrw = augroup("Netrw", { clear = true })

-- Enable line numbers in netrw for easier navigation
autocmd("FileType", {
    group = netrw,
    pattern = "netrw",
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end,
    desc = "Enable line numbers in netrw"
})

-- ==============================================================================
-- Quickfix Improvements
-- ==============================================================================

local quickfix = augroup("Quickfix", { clear = true })

-- Automatically open quickfix after grep
autocmd("QuickFixCmdPost", {
    group = quickfix,
    pattern = "[^l]*",
    command = "cwindow",
    desc = "Open quickfix after grep"
})

-- Automatically open location list
autocmd("QuickFixCmdPost", {
    group = quickfix,
    pattern = "l*",
    command = "lwindow",
    desc = "Open location list"
})
