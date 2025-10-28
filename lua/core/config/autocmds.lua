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

        -- Note-taking abbreviations
        local abbrev = vim.cmd

        -- Todo/Checkbox items
        abbrev([[iabbrev <buffer> todo - [ ] ]])
        abbrev([[iabbrev <buffer> done - [x] ]])
        abbrev([[iabbrev <buffer> pending - [~] ]])
        abbrev([[iabbrev <buffer> cancelled - [-] ]])

        -- Lists
        abbrev([[iabbrev <buffer> ul - ]])
        abbrev([[iabbrev <buffer> ol 1. ]])
        abbrev([[iabbrev <buffer> task - [ ] ]])

        -- Headers (quick access)
        abbrev([[iabbrev <buffer> h1 # ]])
        abbrev([[iabbrev <buffer> h2 ## ]])
        abbrev([[iabbrev <buffer> h3 ### ]])
        abbrev([[iabbrev <buffer> h4 #### ]])

        -- Code blocks
        abbrev([[iabbrev <buffer> pycode ```python<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> jscode ```javascript<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> shcode ```bash<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> luacode ```lua<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> code ```<CR>```<Esc>O]])

        -- Links and references
        abbrev([[iabbrev <buffer> link [](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
        abbrev([[iabbrev <buffer> img ![](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
        abbrev([[iabbrev <buffer> ref [][]<Left><Left><Left>]])

        -- Note-taking templates
        abbrev([[iabbrev <buffer> note > **Note:** ]])
        abbrev([[iabbrev <buffer> warn > **Warning:** ]])
        abbrev([[iabbrev <buffer> tip > **Tip:** ]])
        abbrev([[iabbrev <buffer> important > **Important:** ]])

        -- Date/time stamps
        abbrev([[iabbrev <buffer> date <C-R>=strftime("%Y-%m-%d")<CR>]])
        abbrev([[iabbrev <buffer> time <C-R>=strftime("%H:%M")<CR>]])
        abbrev([[iabbrev <buffer> datetime <C-R>=strftime("%Y-%m-%d %H:%M")<CR>]])
        abbrev([[iabbrev <buffer> timestamp <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>]])

        -- Common formatting
        abbrev([[iabbrev <buffer> bold ****<Left><Left>]])
        abbrev([[iabbrev <buffer> italic **<Left>]])
        abbrev([[iabbrev <buffer> strike ~~~~<Left><Left>]])
        abbrev([[iabbrev <buffer> inline `<BS>]])

        -- Table template (simplified to avoid pipe escaping issues)
        abbrev([[iabbrev <buffer> table <Bar> Header 1 <Bar> Header 2 <Bar>]])

        -- Horizontal rule
        abbrev([[iabbrev <buffer> hr ---]])

        -- Meeting notes template
        abbrev([[iabbrev <buffer> meeting # Meeting Notes<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Attendees:** <CR><CR>## Agenda<CR>- [ ] <CR><CR>## Discussion<CR><CR>## Action Items<CR>- [ ] ]])

        -- Daily notes template
        abbrev([[iabbrev <buffer> daily # Daily Notes - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>## Tasks<CR>- [ ] <CR><CR>## Notes<CR><CR>## Tomorrow<CR>- [ ] ]])

        -- Project notes template
        abbrev([[iabbrev <buffer> project # Project: <CR><CR>## Overview<CR><CR>## Goals<CR>- [ ] <CR><CR>## Timeline<CR><CR>## Resources<CR>]])

        -- Auto-continuation for lists and checkboxes (like Microsoft Word)
        -- When you press Enter after a bullet/checkbox, it creates another one
        vim.keymap.set("i", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            -- Check for checkbox patterns: - [ ], - [x], - [~], - [-]
            local checkbox_pattern = "^(%s*)%- %[.%] (.*)$"
            local checkbox_empty = "^(%s*)%- %[.%]%s*$"
            local indent, content = line:match(checkbox_pattern)

            if indent and content then
                -- Line has content, create new checkbox
                local checkbox_type = line:match("^%s*%- %[(.-)%]")
                -- Always create unchecked checkbox for continuation
                return "<CR>" .. indent .. "- [ ] "
            elseif line:match(checkbox_empty) then
                -- Empty checkbox line, remove it and do normal Enter
                vim.api.nvim_set_current_line("")
                return "<CR>"
            end

            -- Check for bullet list: -
            local bullet_pattern = "^(%s*)%- (.+)$"
            local bullet_empty = "^(%s*)%- %s*$"
            indent, content = line:match(bullet_pattern)

            if indent and content then
                -- Line has content, create new bullet
                return "<CR>" .. indent .. "- "
            elseif line:match(bullet_empty) then
                -- Empty bullet line, remove it and do normal Enter
                vim.api.nvim_set_current_line("")
                return "<CR>"
            end

            -- Check for numbered list: 1., 2., etc.
            local number_pattern = "^(%s*)(%d+)%. (.+)$"
            local number_empty = "^(%s*)(%d+)%. %s*$"
            local num
            indent, num, content = line:match(number_pattern)

            if indent and num and content then
                -- Line has content, create new numbered item
                local next_num = tonumber(num) + 1
                return "<CR>" .. indent .. next_num .. ". "
            elseif line:match(number_empty) then
                -- Empty numbered line, remove it and do normal Enter
                vim.api.nvim_set_current_line("")
                return "<CR>"
            end

            -- Default: just press Enter normally
            return "<CR>"
        end, { buffer = true, expr = true, desc = "Auto-continue lists and checkboxes" })

        -- Tab: Indent list item (add 2 spaces)
        vim.keymap.set("i", "<Tab>", function()
            local line = vim.api.nvim_get_current_line()

            -- Check if line is a list item (checkbox, bullet, or numbered)
            if line:match("^%s*%- %[.%]") or line:match("^%s*%- ") or line:match("^%s*%d+%. ") then
                -- Add 2 spaces at the beginning
                vim.api.nvim_set_current_line("  " .. line)
                -- Move cursor forward by 2
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_win_set_cursor(0, {row, col + 2})
                return ""
            end

            -- Default: insert tab
            return "<Tab>"
        end, { buffer = true, expr = true, desc = "Indent list items" })

        -- Shift-Tab: Dedent list item (remove 2 spaces)
        vim.keymap.set("i", "<S-Tab>", function()
            local line = vim.api.nvim_get_current_line()

            -- Check if line is a list item with indentation
            if (line:match("^%s+%- %[.%]") or line:match("^%s+%- ") or line:match("^%s+%d+%. ")) and line:match("^  ") then
                -- Remove 2 spaces from the beginning
                vim.api.nvim_set_current_line(line:sub(3))
                -- Move cursor back by 2
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_win_set_cursor(0, {row, math.max(0, col - 2)})
                return ""
            end

            -- Default: do nothing or you could return <C-d> for normal dedent
            return ""
        end, { buffer = true, expr = true, desc = "Dedent list items" })
    end,
    desc = "Markdown settings and abbreviations"
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
