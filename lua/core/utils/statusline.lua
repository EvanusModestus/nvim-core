-- ==============================================================================
-- Simple Statusline (No Plugins Required)
-- ==============================================================================
-- A clean, informative statusline without any plugin dependencies
-- ==============================================================================

local M = {}

-- Git branch (if in git repo)
local function git_branch()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
        return "  " .. branch .. " "
    end
    return ""
end

-- File path
local function filepath()
    local path = vim.fn.expand("%:~:.")
    if path == "" then
        return "[No Name]"
    end
    return path
end

-- Modified flag
local function modified()
    if vim.bo.modified then
        return "[+]"
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return "[-]"
    end
    return ""
end

-- File type
local function filetype()
    local ft = vim.bo.filetype
    if ft == "" then
        return ""
    end
    return ft
end

-- File encoding
local function encoding()
    local enc = vim.bo.fileencoding
    if enc == "" then
        enc = vim.o.encoding
    end
    return enc
end

-- File format (unix/dos/mac)
local function fileformat()
    return vim.bo.fileformat
end

-- Current position
local function position()
    return "%l:%c"  -- line:column
end

-- Percentage through file
local function percentage()
    return "%p%%"
end

-- Build statusline
function M.build()
    return table.concat({
        " ",                    -- Padding
        filepath(),             -- File path
        " ",
        modified(),             -- Modified flag
        "%=",                   -- Right align
        git_branch(),           -- Git branch
        filetype(),             -- File type
        " | ",
        encoding(),             -- File encoding
        " | ",
        fileformat(),           -- File format
        " | ",
        position(),             -- Line:column
        " | ",
        percentage(),           -- Percentage
        " ",                    -- Padding
    })
end

-- Set statusline
vim.opt.statusline = "%!v:lua.require'core.utils.statusline'.build()"

return M
