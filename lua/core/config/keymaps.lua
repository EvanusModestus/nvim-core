-- ==============================================================================
-- Core Keymaps
-- ==============================================================================
-- Comprehensive keybindings for efficient editing
-- All using native Neovim features - no plugins required
-- Leader key: Space
-- ==============================================================================

-- Set leader key (ensure it's set before any keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==============================================================================
-- File Navigation
-- ==============================================================================

-- File explorer (netrw) - Opens as left sidebar
keymap("n", "<leader>e", ":Lex<CR>", { desc = "Toggle file explorer sidebar" })
keymap("n", "<leader>E", ":Ex<CR>", { desc = "Open file explorer in current window" })

-- Find files (use built-in)
keymap("n", "<leader>pf", ":find ", { desc = "Find file" })

-- Grep/search in files
keymap("n", "<leader>ps", ":grep ", { desc = "Grep search" })

-- Switch between buffers
keymap("n", "<leader>bb", ":buffers<CR>:buffer ", { desc = "Switch buffer" })
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- ==============================================================================
-- Window Navigation
-- ==============================================================================

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Split windows
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal window sizes" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- ==============================================================================
-- Visual Mode - Line Movement
-- ==============================================================================

-- Move selected lines up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Maintain visual selection when indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- ==============================================================================
-- Editing Enhancements
-- ==============================================================================

-- Join lines and keep cursor position
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Paste without yanking in visual mode
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- Delete to void register (don't yank)
keymap({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete to void" })

-- Replace word under cursor globally
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })

-- ==============================================================================
-- System Clipboard Integration
-- ==============================================================================

-- Yank to system clipboard
keymap({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Paste from system clipboard
keymap({"n", "v"}, "<leader>p", [["+p]], { desc = "Paste from clipboard" })
keymap({"n", "v"}, "<leader>P", [["+P]], { desc = "Paste before from clipboard" })

-- ==============================================================================
-- Scrolling and Centering
-- ==============================================================================

-- Half page jump with centering
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Search result centering
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Center screen after search
keymap("n", "*", "*zz", { desc = "Search word forward" })
keymap("n", "#", "#zz", { desc = "Search word backward" })

-- ==============================================================================
-- Insert Mode Escapes
-- ==============================================================================

-- Better escape alternatives
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "jj", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- ==============================================================================
-- Quick Saves and Exits
-- ==============================================================================

-- Quick save
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>W", ":wa<CR>", { desc = "Save all files" })

-- Quick quit
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving" })

-- Save and quit
keymap("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })

-- ==============================================================================
-- Search and Replace
-- ==============================================================================

-- Clear search highlighting
keymap("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlight" })
keymap("n", "<Esc>", ":nohl<CR>", opts)

-- ==============================================================================
-- Spell Checking (for markdown/text files)
-- ==============================================================================
-- Note: Spell check is auto-enabled for markdown/text files in autocmds.lua
-- These keymaps work with native vim spell checking

-- Toggle spell check on/off
keymap("n", "<leader>z", ":set spell!<CR>", { desc = "Toggle spell check" })

-- Navigate spelling errors (vim defaults, but explicitly mapped for discoverability)
keymap("n", "]s", "]s", { desc = "Next misspelled word" })
keymap("n", "[s", "[s", { desc = "Previous misspelled word" })

-- Spell corrections and dictionary management
keymap("n", "z=", "z=", { desc = "Spelling suggestions" })
keymap("n", "zg", "zg", { desc = "Add word to dictionary" })
keymap("n", "zw", "zw", { desc = "Mark word as misspelling" })
keymap("n", "zug", "zug", { desc = "Remove word from dictionary" })

-- ==============================================================================
-- Quickfix and Location List
-- ==============================================================================

-- Quickfix navigation
keymap("n", "<C-k>", ":cnext<CR>zz", { desc = "Next quickfix" })
keymap("n", "<C-j>", ":cprev<CR>zz", { desc = "Previous quickfix" })
keymap("n", "<leader>k", ":lnext<CR>zz", { desc = "Next location" })
keymap("n", "<leader>j", ":lprev<CR>zz", { desc = "Previous location" })

-- Open/close quickfix and location lists
keymap("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix" })
keymap("n", "<leader>lo", ":lopen<CR>", { desc = "Open location list" })
keymap("n", "<leader>lc", ":lclose<CR>", { desc = "Close location list" })

-- ==============================================================================
-- File Operations
-- ==============================================================================

-- Make file executable
keymap("n", "<leader>x", ":!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Source current file
keymap("n", "<leader><leader>", ":so %<CR>", { desc = "Source current file" })

-- Edit vimrc
keymap("n", "<leader>ve", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit init.lua" })

-- ==============================================================================
-- Terminal Mode
-- ==============================================================================

-- Open terminal
keymap("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })

-- Terminal mode escape
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

-- ==============================================================================
-- Miscellaneous
-- ==============================================================================

-- Disable Ex mode
keymap("n", "Q", "<nop>", opts)

-- Stay in visual mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', opts)

-- Increment/decrement
keymap("n", "+", "<C-a>", { desc = "Increment number" })
keymap("n", "-", "<C-x>", { desc = "Decrement number" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Keep cursor in place when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Undo breakpoints (create undo points in insert mode)
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", "!", "!<c-g>u", opts)
keymap("i", "?", "?<c-g>u", opts)
