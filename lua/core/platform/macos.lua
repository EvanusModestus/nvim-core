-- ==============================================================================
-- macOS-Specific Configuration
-- ==============================================================================

-- Set clipboard to use pbcopy/pbpaste
if vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1 then
    vim.g.clipboard = {
        name = "macOS-clipboard",
        copy = {
            ["+"] = "pbcopy",
            ["*"] = "pbcopy",
        },
        paste = {
            ["+"] = "pbpaste",
            ["*"] = "pbpaste",
        },
        cache_enabled = 0
    }
end

-- Set file path separator
vim.g.path_separator = "/"

-- Python provider (prefer python3)
if vim.fn.executable("python3") == 1 then
    vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- Use bash as default shell
vim.opt.shell = "/bin/bash"
