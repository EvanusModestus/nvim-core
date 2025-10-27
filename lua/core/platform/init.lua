-- ==============================================================================
-- Platform Detection and Configuration
-- ==============================================================================
-- Automatically detect and configure for Windows, Linux, macOS, WSL
-- ==============================================================================

local M = {}

-- Detect operating system
local function detect_os()
    if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
        return "windows"
    elseif vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
        return "macos"
    elseif vim.fn.has("unix") == 1 then
        -- Check if WSL
        local handle = io.popen("uname -r")
        if handle then
            local result = handle:read("*a")
            handle:close()
            if result:match("[Mm]icrosoft") or result:match("WSL") then
                return "wsl"
            end
        end
        return "linux"
    end
    return "unknown"
end

-- Store platform information globally
M.os = detect_os()
M.is_windows = M.os == "windows"
M.is_mac = M.os == "macos"
M.is_linux = M.os == "linux"
M.is_wsl = M.os == "wsl"
M.is_unix = M.is_linux or M.is_mac or M.is_wsl

-- Make platform info available globally
_G.platform = M

-- ==============================================================================
-- Platform-Specific Configurations
-- ==============================================================================

if M.is_windows then
    require('core.platform.windows')
elseif M.is_macos then
    require('core.platform.macos')
elseif M.is_wsl then
    require('core.platform.wsl')
elseif M.is_linux then
    require('core.platform.linux')
end

return M
