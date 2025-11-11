-- ==============================================================================
-- Linux-Specific Configuration
-- ==============================================================================

-- Set up clipboard using xclip or xsel
if vim.fn.executable("xclip") == 1 then
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
-- Wayland support (wl-clipboard)
elseif vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = "wl-copy",
            ["*"] = "wl-copy --primary",
        },
        paste = {
            ["+"] = "wl-paste",
            ["*"] = "wl-paste --primary",
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
