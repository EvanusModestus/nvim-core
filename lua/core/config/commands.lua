-- ==============================================================================
-- Custom User Commands
-- ==============================================================================
-- Useful custom commands for common operations
-- ==============================================================================

local command = vim.api.nvim_create_user_command

-- ==============================================================================
-- File Operations
-- ==============================================================================

-- Sudo write (save file with sudo)
command("W", "w !sudo tee > /dev/null %", {
    desc = "Save file with sudo"
})

-- Show recovery information
command("RecoveryInfo", function()
    print([[
Swap File Recovery & Undo Configuration
========================================

Swap Files (Crash Recovery):
  • Location: ]] .. vim.fn.stdpath("data") .. [[/swap/
  • Update frequency: Every 50 characters or 250ms
  • Recover: nvim -r <filename> or choose (R)ecover when opening

Persistent Undo:
  • Location: ]] .. vim.fn.stdpath("data") .. [[/undo/
  • Undo levels: 10,000 changes
  • Survives: Neovim restarts, file closes
  • Navigate: u (undo), Ctrl+r (redo)
  • Undo tree: Use :earlier/:later with time (e.g., :earlier 5m)

Auto-Save:
  • Triggers: When switching buffers or losing focus
  • Protection: Against SSH disconnections
  • Manual save: <leader>w or :w

Recovery After Disconnection:
  1. Reconnect to server
  2. cd to your working directory
  3. nvim <your-file>
  4. Neovim will detect swap file and prompt:
     • (R)ecover - Restore from swap file
     • (D)elete - Delete swap file
     • (Q)uit - Exit without recovering
  5. Choose (R) to recover your unsaved work

Undo After Restart:
  • Open file: nvim <filename>
  • Press 'u' to undo - works even after closing nvim!
  • Undo history persists across sessions

Tips:
  • Swap files protect against crashes/disconnections
  • Undo files protect against mistakes
  • Both work together for maximum data safety
  • Auto-save provides additional protection
    ]])
end, {
    desc = "Show swap file and undo recovery information"
})

-- Delete current file and buffer
command("Delete", function()
    local file = vim.fn.expand("%:p")
    vim.cmd("bdelete!")
    vim.fn.delete(file)
end, {
    desc = "Delete current file and buffer"
})

-- Rename current file
command("Rename", function(opts)
    local old_name = vim.fn.expand("%:p")
    local new_name = opts.args
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    vim.cmd("bdelete " .. old_name)
end, {
    nargs = 1,
    complete = "file",
    desc = "Rename current file"
})

-- ==============================================================================
-- Buffer Operations
-- ==============================================================================

-- Delete all buffers except current
command("BufOnly", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, {})
        end
    end
end, {
    desc = "Delete all buffers except current"
})

-- Close all buffers
command("BufCloseAll", "%bd", {
    desc = "Close all buffers"
})

-- ==============================================================================
-- Window Operations
-- ==============================================================================

-- Close all other windows
command("WinOnly", "only", {
    desc = "Close all other windows"
})

-- ==============================================================================
-- Formatting
-- ==============================================================================

-- Remove trailing whitespace
command("TrimWhitespace", [[%s/\s\+$//e]], {
    desc = "Remove trailing whitespace"
})

-- Convert tabs to spaces
command("TabsToSpaces", "set expandtab | retab", {
    desc = "Convert tabs to spaces"
})

-- Convert spaces to tabs
command("SpacesToTabs", "set noexpandtab | retab!", {
    desc = "Convert spaces to tabs"
})

-- Format JSON
command("FormatJSON", "%!python3 -m json.tool", {
    desc = "Format JSON file"
})

-- ==============================================================================
-- Search and Replace
-- ==============================================================================

-- Case-insensitive search and replace
command("ReplaceAll", function(opts)
    vim.cmd(":%s/" .. opts.args .. "/gc")
end, {
    nargs = 1,
    desc = "Interactive search and replace"
})

-- ==============================================================================
-- Information
-- ==============================================================================

-- Show file info
command("FileInfo", function()
    local file = vim.fn.expand("%:p")
    local size = vim.fn.getfsize(file)
    local lines = vim.api.nvim_buf_line_count(0)
    local ft = vim.bo.filetype

    print(string.format([[
File: %s
Size: %d bytes
Lines: %d
Type: %s
    ]], file, size, lines, ft))
end, {
    desc = "Show file information"
})

-- ==============================================================================
-- Diff
-- ==============================================================================

-- Diff current buffer with file on disk
command("DiffOrig", function()
    local scratch = vim.api.nvim_create_buf(false, true)
    local orig = vim.api.nvim_get_current_buf()
    vim.cmd("vertical sbuffer " .. scratch)
    vim.cmd("read ++edit #")
    vim.cmd("0d_")
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end, {
    desc = "Diff with original file"
})

-- ==============================================================================
-- Quick Edits
-- ==============================================================================

-- Open init.lua
command("EditInit", "e ~/.config/nvim/init.lua", {
    desc = "Edit init.lua"
})

-- Open vimrc-equivalent
command("EditVimrc", "e ~/.config/nvim/init.lua", {
    desc = "Edit init.lua"
})

-- ==============================================================================
-- Terminal
-- ==============================================================================

-- Open horizontal terminal
command("TermH", "split | terminal", {
    desc = "Open horizontal terminal"
})

-- Open vertical terminal
command("TermV", "vsplit | terminal", {
    desc = "Open vertical terminal"
})

-- ==============================================================================
-- LSP Commands
-- ==============================================================================

-- Show LSP server status
command("LspStatus", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        print([[
No LSP servers attached to this buffer.

To install language servers:
  :LspInstall

To see available servers:
  :LspHelp
        ]])
        return
    end

    print("Active LSP servers for this buffer:")
    for _, client in ipairs(clients) do
        print(string.format("  • %s (root: %s)", client.name, client.config.root_dir or "unknown"))
    end
end, {
    desc = "Show active LSP servers"
})

-- Show LSP installation help
command("LspInstall", function()
    print([[
Language Server Installation Guide
==================================

nvim-core uses Neovim's native LSP client (zero plugins).
Language servers must be installed manually on your system.

Common Language Servers:
------------------------

Python (pyright):
  npm install -g pyright

Lua (lua-language-server):
  # Download from: https://github.com/LuaLS/lua-language-server/releases
  # Or install via package manager

JavaScript/TypeScript (tsserver):
  npm install -g typescript typescript-language-server

Bash (bash-language-server):
  npm install -g bash-language-server

C/C++ (clangd):
  sudo apt install clangd   # Debian/Ubuntu
  sudo dnf install clang-tools-extra   # Fedora

Rust (rust-analyzer):
  rustup component add rust-analyzer

Go (gopls):
  go install golang.org/x/tools/gopls@latest

JSON (vscode-langservers-extracted):
  npm install -g vscode-langservers-extracted

YAML (yaml-language-server):
  npm install -g yaml-language-server

Markdown (marksman):
  # Arch Linux
  yay -S marksman-bin
  # Or download from: https://github.com/artempyanykh/marksman/releases

After installing, restart nvim and open a file of that type.
Run :LspStatus to verify the server is running.

For more info: :LspHelp
    ]])
end, {
    desc = "Show language server installation instructions"
})

-- Show LSP keybindings help
command("LspHelp", function()
    print([[
Native LSP - Keybindings & Features
===================================

LSP provides:
  • Diagnostics (errors, warnings)
  • Code completion
  • Go to definition
  • Find references
  • Code actions (refactoring, fixes)
  • Symbol renaming
  • Hover documentation

Keybindings (when LSP is active):
---------------------------------

Navigation:
  gd           Go to definition
  gD           Go to declaration
  gi           Go to implementation
  gr           Find references
  gt           Go to type definition

Information:
  K            Hover documentation
  <leader>k    Signature help

Diagnostics:
  [d           Previous diagnostic
  ]d           Next diagnostic
  <leader>e    Show diagnostic (NOTE: conflicts with file explorer)
  <leader>dl   Diagnostics to location list

Code Actions:
  <leader>ca   Code action
  <leader>rn   Rename symbol
  <leader>f    Format document

Workspace:
  <leader>wa   Add workspace folder
  <leader>wr   Remove workspace folder
  <leader>wl   List workspace folders

Commands:
  :LspStatus   Show active LSP servers
  :LspInstall  Installation instructions
  :LspHelp     This help message

Note: <leader>e conflicts with file explorer.
      Consider using <leader>E for file explorer when LSP is active.

For installation: :LspInstall
    ]])
end, {
    desc = "Show LSP help and keybindings"
})

-- ==============================================================================
-- Help
-- ==============================================================================

-- Quick access to nvim-core help
command("CoreHelp", function()
    print([[
nvim-core - Zero-plugin Neovim configuration

Leader key: Space

File Navigation:
  <leader>e    - Toggle file explorer (sidebar)
  <leader>E    - File explorer (current window)
  <leader>pf   - Find file
  <leader>ps   - Grep search

Clipboard:
  <leader>y    - Yank to clipboard
  <leader>p    - Paste from clipboard

Windows:
  <C-h/j/k/l>  - Navigate windows
  <leader>sv   - Vertical split
  <leader>sh   - Horizontal split

Quick Actions:
  <leader>w    - Save
  <leader>q    - Quit
  <leader>x    - Make executable

LSP (if language servers installed):
  gd           - Go to definition
  K            - Hover documentation
  <leader>ca   - Code actions
  :LspHelp     - LSP keybindings
  :LspInstall  - Installation guide

Commands:
  :NetrwHelp       - netrw keybindings reference
  :LspStatus       - Show active LSP servers
  :LspHelp         - LSP help and keybindings
  :LspInstall      - Language server installation
  :RecoveryInfo    - Swap file & undo recovery guide
  :CoreHelp        - This help message

Recovery Features:
  • Swap files enabled (crash recovery after SSH disconnect)
  • 10,000 level undo/redo (persists across restarts)
  • Auto-save on buffer switch
  • Run :RecoveryInfo for details

For more: https://github.com/EvanusModestus/nvim-core
    ]])
end, {
    desc = "Show nvim-core help"
})

-- Netrw help - Essential keybindings for the file explorer
command("NetrwHelp", function()
    local netrw_help = [[
╔══════════════════════════════════════════════════════════════════════════════╗
║                    netrw File Explorer - Quick Reference                    ║
╚══════════════════════════════════════════════════════════════════════════════╝

Opening Files & Directories:
  <Enter>       Open file/directory under cursor
  o             Open in horizontal split below
  v             Open in vertical split to right
  p             Preview file (cursor stays in netrw)
  P             Open in previous window
  t             Open in new tab

Navigation:
  -             Go up to parent directory
  u             Go back in directory history
  U             Go forward in directory history
  <C-l>         Refresh file listing

File Operations:
  %             Create new file (type name, press Enter)
  d             Create new directory
  R             Rename file/directory under cursor
  D             Delete file/directory under cursor

Marking Files (for batch operations):
  mf            Mark file under cursor
  mt            Mark target directory for move/copy
  mc            Copy marked files to target directory
  mm            Move marked files to target directory
  mx            Execute shell command on marked files
  mu            Unmark all files

Display & Sorting:
  i             Cycle view: thin → long → wide → tree
  I             Toggle banner on/off
  gh            Toggle hidden files (dotfiles)
  s             Cycle sort: name → time → size
  r             Reverse sort order

Bookmarks:
  mb            Bookmark current directory
  qb            List all bookmarks
  gb            Jump to most recent bookmark

Search & Help:
  /pattern      Search for files matching pattern
  <F1>          Open full netrw documentation

════════════════════════════════════════════════════════════════════════════════

Current nvim-core Configuration:
  • Opens as left sidebar with <leader>e (25% width)
  • Tree view enabled by default
  • Files open in main window (sidebar stays open)
  • Directories sorted first, case-insensitive
  • Dotfiles hidden by default (press 'gh' to toggle)

Pro Tips:
  1. Use 'p' to preview files without opening them
  2. Mark multiple files with 'mf', set target with 'mt', copy with 'mc'
  3. Press 'I' to toggle banner if you need more screen space
  4. Use tree view (press 'i' until you see tree structure)
  5. Navigate with j/k, open with Enter - just like normal vim!

Press 'q' or <Esc> to close this help window.
    ]]

    -- Create scratch buffer for help
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(netrw_help, "\n"))
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

    -- Calculate centered floating window dimensions
    local width = math.min(80, vim.o.columns - 4)
    local height = math.min(45, vim.o.lines - 4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Open floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    -- Close keybindings
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
    vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end, {
    desc = "Show netrw file explorer help"
})
