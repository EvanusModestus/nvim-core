-- ==============================================================================
-- Windows-Specific Configuration
-- ==============================================================================

-- Use PowerShell as the default shell
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Windows clipboard (handled by Neovim natively on Windows)
-- No additional configuration needed

-- Set file path separator
vim.g.path_separator = "\\"

-- Python provider (if using Python)
if vim.fn.executable("python") == 1 then
    vim.g.python3_host_prog = vim.fn.exepath("python")
end
