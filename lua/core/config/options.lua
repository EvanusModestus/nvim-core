-- ==============================================================================
-- Core Vim Options
-- ==============================================================================
-- All essential vim settings for a productive editing experience
-- No plugins required - all native Neovim features
-- ==============================================================================

local opt = vim.opt
local g = vim.g

-- ==============================================================================
-- Leader Keys
-- ==============================================================================
g.mapleader = " "          -- Space as leader key
g.maplocalleader = "\\"    -- Backslash as local leader

-- ==============================================================================
-- UI and Appearance
-- ==============================================================================
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Relative line numbers for easy navigation
opt.cursorline = true       -- Highlight current line
opt.signcolumn = "yes"      -- Always show sign column (prevents shifting)
opt.colorcolumn = "80"      -- Show column at 80 characters
opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8       -- Keep 8 columns visible left/right of cursor
opt.wrap = false            -- Don't wrap long lines
opt.linebreak = true        -- If wrap is on, break at word boundaries
opt.showmode = false        -- Don't show mode (we have statusline)
opt.showcmd = true          -- Show command in status line
opt.cmdheight = 1           -- Command line height
opt.laststatus = 2          -- Always show statusline
opt.termguicolors = true    -- Enable 24-bit RGB colors

-- ==============================================================================
-- Colorscheme
-- ==============================================================================
-- Built-in colorschemes: desert, slate, murphy, pablo, habamax, etc.
-- Try :colorscheme <Tab> to see all available options
vim.cmd.colorscheme('desert')

-- ==============================================================================
-- Indentation and Formatting
-- ==============================================================================
opt.tabstop = 4             -- Tab width = 4 spaces
opt.shiftwidth = 4          -- Indent width = 4 spaces
opt.softtabstop = 4         -- Soft tab = 4 spaces
opt.expandtab = true        -- Convert tabs to spaces
opt.smartindent = true      -- Smart auto-indenting
opt.autoindent = true       -- Copy indent from current line
opt.shiftround = true       -- Round indent to multiple of shiftwidth

-- ==============================================================================
-- Search Settings
-- ==============================================================================
opt.hlsearch = true         -- Highlight search results
opt.incsearch = true        -- Show search matches as you type
opt.ignorecase = true       -- Case-insensitive search
opt.smartcase = true        -- Case-sensitive if search contains uppercase

-- ==============================================================================
-- File Handling and Recovery
-- ==============================================================================

-- Swap Files (ENABLED for SSH crash recovery)
opt.swapfile = true         -- Enable swap files for crash recovery
opt.directory = vim.fn.stdpath("data") .. "/swap//"  -- Swap file directory
opt.updatecount = 50        -- Write to swap after 50 characters (frequent)
opt.updatetime = 250        -- Write swap file after 250ms of no typing (fast)

-- Create swap directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath("data") .. "/swap", "p")

-- Backup Files (disabled - we rely on swap + undo)
opt.backup = false          -- No backup files
opt.writebackup = false     -- No backup while editing

-- Persistent Undo (ENABLED - undo survives restarts)
opt.undofile = true         -- Persistent undo across sessions
opt.undodir = vim.fn.stdpath("data") .. "/undo"  -- Undo directory
opt.undolevels = 10000      -- Maximum number of changes that can be undone
opt.undoreload = 10000      -- Maximum lines to save for undo on buffer reload

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")

-- File Monitoring
opt.autoread = true         -- Auto-reload files changed outside vim
opt.hidden = true           -- Allow hidden buffers with unsaved changes

-- ==============================================================================
-- Completion and Wildmenu
-- ==============================================================================
opt.wildmenu = true         -- Enhanced command-line completion
opt.wildmode = "longest:full,full"  -- Complete longest common string, then full
opt.wildignore:append({
    "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
    "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**",
    "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.ico",
    "*.pdf", "*.doc", "*.docx", "*.ppt", "*.pptx",
    "*/node_modules/*", "*/.next/*", "*/dist/*"
})
opt.completeopt = "menuone,noselect"  -- Completion options

-- ==============================================================================
-- Window Splitting
-- ==============================================================================
opt.splitright = true       -- Vertical splits open to the right
opt.splitbelow = true       -- Horizontal splits open below

-- ==============================================================================
-- Performance
-- ==============================================================================
opt.updatetime = 250        -- Faster completion (default 4000ms)
opt.timeoutlen = 300        -- Time to wait for mapped sequence
opt.lazyredraw = false      -- Don't redraw during macros (can cause issues)

-- ==============================================================================
-- File Encoding
-- ==============================================================================
opt.encoding = "utf-8"      -- UTF-8 encoding
opt.fileencoding = "utf-8"  -- UTF-8 file encoding

-- ==============================================================================
-- Mouse Support
-- ==============================================================================
opt.mouse = "a"             -- Enable mouse in all modes

-- ==============================================================================
-- Better File Finding
-- ==============================================================================
opt.path:append("**")       -- Search recursively in current directory

-- ==============================================================================
-- Miscellaneous
-- ==============================================================================
opt.iskeyword:append("-")   -- Treat dash-separated words as one word
opt.formatoptions:remove({ "c", "r", "o" })  -- Don't auto-continue comments
opt.shortmess:append("c")   -- Don't show completion messages
opt.belloff = "all"         -- Disable bell sounds

-- ==============================================================================
-- Security (Disable potentially dangerous features)
-- ==============================================================================
opt.modeline = false        -- Disable modeline (security risk)
opt.exrc = false            -- Don't load .exrc, .nvimrc in current directory

-- ==============================================================================
-- Netrw (Built-in File Explorer) Settings - Optimized Configuration
-- ==============================================================================

-- Display and Layout
g.netrw_banner = 0              -- Hide banner (press I to toggle if needed)
g.netrw_liststyle = 3           -- Tree view (0=thin, 1=long, 2=wide, 3=tree)
g.netrw_winsize = 25            -- 25% width for split windows

-- Window Behavior
g.netrw_browse_split = 4        -- Open files in previous window (keeps netrw sidebar open)
                                -- 0=same, 1=hsplit, 2=vsplit, 3=tab, 4=previous
g.netrw_alto = 1                -- Splits appear below
g.netrw_altv = 1                -- Vertical splits to the right

-- Preview (disabled to prevent window conflicts)
g.netrw_preview = 0             -- Disable preview mode to avoid extra windows

-- File Operations
g.netrw_keepdir = 0             -- Keep current directory same as browsing directory
g.netrw_localcopydircmd = 'cp -r'   -- Enable recursive copy

-- Sort Options
g.netrw_sort_sequence = [[[\/]$,*]]  -- Directories first, then files
g.netrw_sort_options = 'i'      -- Case-insensitive sorting

-- Hide dotfiles by default (toggle with 'gh')
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

-- Performance
g.netrw_fastbrowse = 2          -- Medium speed directory caching
g.netrw_use_errorwindow = 0     -- Don't open error window for simple errors
