-- ==============================================================================
-- Clipboard Utilities
-- ==============================================================================
-- Additional clipboard helper functions
-- ==============================================================================

local M = {}

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

    print(string.format([[
Clipboard Status:
  Available: %s
  Provider: %s
  Platform: %s
    ]], available and "Yes" or "No", provider, _G.platform.os))
end

-- Create user command to check clipboard
vim.api.nvim_create_user_command("ClipboardStatus", M.status, {
    desc = "Show clipboard status"
})

return M
