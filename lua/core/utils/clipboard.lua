-- ==============================================================================
-- Clipboard Utilities
-- ==============================================================================
-- Clipboard support including OSC 52 for SSH sessions
-- OSC 52 allows copying to system clipboard over SSH without X11 forwarding
-- ==============================================================================

local M = {}

-- ==============================================================================
-- OSC 52 Clipboard Support (Works over SSH!)
-- ==============================================================================

-- OSC 52 implementation for copying to system clipboard over SSH
-- This works with modern terminals: iTerm2, Windows Terminal, Alacritty, kitty, etc.
local function osc52_copy(lines)
    local text = table.concat(lines, '\n')
    local b64 = vim.base64.encode(text)
    -- OSC 52 escape sequence: ESC]52;c;BASE64\ESC\\
    local osc52 = string.format('\027]52;c;%s\027\\', b64)
    io.stdout:write(osc52)
    io.stdout:flush()
end

-- Detect if we're in an SSH session
local function is_ssh()
    return os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
end

-- Setup OSC 52 clipboard provider if in SSH session
if is_ssh() then
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = function(lines) osc52_copy(lines) end,
            ['*'] = function(lines) osc52_copy(lines) end,
        },
        paste = {
            -- Pasting from system clipboard over SSH is not supported via OSC 52
            -- User must paste using terminal (Ctrl+Shift+V or right-click)
            ['+'] = function() return {} end,
            ['*'] = function() return {} end,
        },
        cache_enabled = 0,
    }
end

-- ==============================================================================
-- Clipboard Helper Functions
-- ==============================================================================

-- Check if clipboard is available
function M.is_available()
    return vim.fn.has("clipboard") == 1
end

-- Get clipboard provider info
function M.get_provider()
    if vim.g.clipboard and vim.g.clipboard.name then
        return vim.g.clipboard.name
    end
    return "native"
end

-- Show clipboard status
function M.status()
    local available = M.is_available()
    local provider = M.get_provider()
    local ssh = is_ssh()

    print(string.format([[
Clipboard Status:
  Available: %s
  Provider: %s
  Platform: %s
  SSH Session: %s

%s
    ]],
        available and "Yes" or "No",
        provider,
        _G.platform.os,
        ssh and "Yes (OSC 52 enabled)" or "No",
        ssh and "Copy with <leader>y works! Paste using terminal (Ctrl+Shift+V)" or ""
    ))
end

-- Create user command to check clipboard
vim.api.nvim_create_user_command("ClipboardStatus", M.status, {
    desc = "Show clipboard status"
})

return M
