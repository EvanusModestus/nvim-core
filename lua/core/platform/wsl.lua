-- ==============================================================================
-- WSL-Specific Configuration
-- ==============================================================================

-- Use win32yank for clipboard if available
if vim.fn.executable("win32yank.exe") == 1 then
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0
    }
-- Fallback to xclip/xsel if available
elseif vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
        name = "xclip",
        copy = {
            ["+"] = "xclip -selection clipboard",
            ["*"] = "xclip -selection primary",
        },
        paste = {
            ["+"] = "xclip -selection clipboard -o",
            ["*"] = "xclip -selection primary -o",
        },
        cache_enabled = 0
    }
elseif vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
        name = "xsel",
        copy = {
            ["+"] = "xsel --clipboard --input",
            ["*"] = "xsel --primary --input",
        },
        paste = {
            ["+"] = "xsel --clipboard --output",
            ["*"] = "xsel --primary --output",
        },
        cache_enabled = 0
    }
end

-- Set file path separator
vim.g.path_separator = "/"

-- Python provider
if vim.fn.executable("python3") == 1 then
    vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- Use bash as default shell
vim.opt.shell = "/bin/bash"
