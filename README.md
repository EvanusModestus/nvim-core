# nvim-core

> Zero-plugin, maximum security Neovim configuration for any platform

**nvim-core** is an absolutely secure, zero-plugin Neovim configuration designed for professionals who need powerful editing capabilities without any security risks. Perfect for production servers, client machines, air-gapped networks, and any environment where security is paramount.

## Why nvim-core?

- **Absolutely Secure**: Zero plugins = zero plugin vulnerabilities
- **Universal**: Works on Windows, Linux, macOS, and WSL
- **Instant Setup**: 10-second installation, works immediately
- **Full-Featured**: All the vim power you need, none of the risk
- **No Dependencies**: No external binaries required (optional: clipboard tools)
- **Production-Ready**: Safe for any server environment

## Quick Install

### Linux / macOS / WSL
```bash
curl -fsSL https://raw.githubusercontent.com/EvanusModestus/nvim-core/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
iwr -useb https://raw.githubusercontent.com/EvanusModestus/nvim-core/main/install.ps1 | iex
```

### Manual Installation
```bash
git clone https://github.com/EvanusModestus/nvim-core.git ~/.config/nvim
```

## Features

### Zero Plugins, Maximum Power

| Feature | Implementation |
|---------|----------------|
| **File Explorer** | Enhanced netrw (built-in) |
| **Fuzzy Finding** | Native wildmenu with path |
| **Grep Search** | Integrated ripgrep/grep |
| **Clipboard** | Cross-platform system clipboard + OSC 52 (SSH) |
| **Terminal** | Built-in terminal integration |
| **Statusline** | Custom statusline with git branch |
| **LSP Support** | Native Neovim LSP client with auto-detection |
| **Diagnostics** | Real-time error/warning highlighting |
| **Code Actions** | Refactoring, quick fixes, formatting |
| **Quickfix** | Enhanced quickfix navigation |
| **Autocomplete** | Native completion menu with LSP |

### Cross-Platform Support

- **Windows**: PowerShell integration, native clipboard
- **macOS**: pbcopy/pbpaste clipboard
- **Linux**: xclip/xsel/wl-clipboard support
- **WSL**: win32yank clipboard integration

## Markdown Power User Features

**nvim-core includes 150+ abbreviations and smart list behaviors** - perfect for technical writers, engineers, students, and educators!

### Smart List Behaviors

**Auto-Continuation** (works like Microsoft Word):
- Type `- [ ]` + text, press Enter → Creates another `- [ ]`
- Type `1.` + text, press Enter → Auto-increments to `2.`
- Press Enter on empty list item → Exits list
- Tab → Indent list item (2 spaces)
- Shift-Tab → Dedent list item

### Quick Abbreviations (150+)

Type these + space to auto-expand:

**Headers:** `h1` `h2` `h3` `h4` `h5` `h6`

**Todo/Tasks:** `todo` `done` `pending` `cancelled` `priority`

**Callouts:** `note` `tip` `warn` `important` `info` `danger` `success` `error` `question`

**Code Blocks (40+ languages):**
- Programming: `pycode` `jscode` `tscode` `rustcode` `gocode` `ccode` `cppcode` `javacode`
- Data: `sqlcode` `jsoncode` `yamlcode` `xmlcode` `tomlcode`
- Web: `htmlcode` `csscode` `scsscode`
- Shell: `shcode` `shellcode` `powershell` `console`
- Other: `dockercode` `gitcode` `diffcode` `vimcode` `mdcode`

**Date/Time (auto-inserts current):** `date` `time` `datetime` `timestamp`

**Formatting:** `bold` `italic` `strike` `inline` `link` `img` `kbd` `footnote`

**Technical:** `TODO` `FIXME` `NOTE` `BUG` `DEPRECATED` `output` `example` `badge`

### Professional Templates (30+)

**Workflow & Productivity:**
- `weekly` - Weekly review (accomplishments/challenges/goals)
- `weekplan` - Weekly planning with daily breakdown
- `sprint` - Agile sprint planning
- `retro` - Retrospective template
- `meeting` - Meeting notes with agenda
- `daily` - Daily notes
- `project` - Project template

**Technical Writer:**
- `tutorial` - Complete tutorial template
- `howto` - How-to guide
- `docpage` - Documentation page
- `changelog` - Changelog entry
- `release` - Release notes
- `apidoc` - API documentation

**Engineer:**
- `bugreport` - Bug report (steps/expected/actual)
- `feature` - Feature request
- `adr` - Architecture Decision Record
- `codereview` - Code review template
- `design` - Technical design document
- `postmortem` - Incident post-mortem

**Student:**
- `classnotes` - Class notes
- `studyguide` - Study guide
- `research` - Research notes
- `assignment` - Assignment tracker
- `readingnotes` - Reading notes

**Educator:**
- `lesson` - Lesson plan
- `syllabus` - Course syllabus
- `rubric` - Grading rubric
- `feedback` - Student feedback

**Personal:**
- `brainstorm` - Brainstorming session
- `problem` - Problem-solving framework
- `decision` - Decision log
- `booksummary` - Book summary
- `goals` - Goal setting (yearly/quarterly)

**Try it:** Open a markdown file, type `meeting` + space.

## Keybindings

### Leader Key: `Space`

#### File Navigation
- `<leader>e` - Open file explorer
- `<leader>pf` - Find files
- `<leader>ps` - Grep search
- `<leader>bb` - Switch buffers

#### System Clipboard
- `<leader>y` - Yank to clipboard
- `<leader>Y` - Yank line to clipboard
- `<leader>p` - Paste from clipboard

#### Window Management
- `<C-h/j/k/l>` - Navigate windows
- `<leader>sv` - Vertical split
- `<leader>sh` - Horizontal split
- `<leader>sx` - Close split

#### Visual Mode
- `J` / `K` - Move selected lines up/down
- `>` / `<` - Indent/dedent (maintains selection)

#### Quick Actions
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>x` - Make file executable
- `<leader>s` - Search/replace word under cursor

#### Terminal
- `<leader>tt` - Open terminal
- `<Esc>` - Exit terminal mode (in terminal)

**Full keymap reference**: `:CoreHelp`

#### LSP (when language servers installed)
- `gd` - Go to definition
- `K` - Hover documentation
- `[d` / `]d` - Previous/next diagnostic
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document

**LSP help**: `:LspHelp` | **Installation**: `:LspInstall` | **Status**: `:LspStatus`

## Requirements

### Required
- Neovim 0.9.0 or higher

### Optional (for enhanced features)
- **ripgrep** - Faster grep searching
- **xclip** or **xsel** (Linux) - System clipboard
- **win32yank** (WSL) - Windows clipboard integration
- **pbcopy**/**pbpaste** (macOS) - Built-in on macOS

### Installing Optional Tools

**Ubuntu/Debian:**
```bash
sudo apt install ripgrep xclip
```

**Fedora:**
```bash
sudo dnf install ripgrep xclip
```

**macOS:**
```bash
brew install ripgrep
```

**Windows:**
```powershell
choco install ripgrep
```

### LSP (Language Server Protocol) - Optional

nvim-core includes **native LSP support** (zero plugins, uses Neovim's built-in LSP client).

**Features when language servers are installed:**
- Real-time diagnostics (errors, warnings)
- Code completion
- Go to definition / Find references
- Hover documentation
- Code actions and refactoring
- Symbol renaming
- Document formatting

**Installation:**

Run `:LspInstall` in nvim to see installation instructions for common languages.

**Quick setup for popular languages:**

```bash
# Python
npm install -g pyright

# JavaScript/TypeScript
npm install -g typescript typescript-language-server

# Bash
npm install -g bash-language-server

# C/C++ (Ubuntu/Debian)
sudo apt install clangd
```

After installing language servers, they activate automatically when you open files of that type.

Run `:LspStatus` to verify servers are running.

## 📁 Structure

```
nvim-core/
├── init.lua                          # Entry point
├── lua/
│   └── core/
│       ├── config/
│       │   ├── options.lua           # All vim settings
│       │   ├── keymaps.lua          # Keybindings
│       │   ├── autocmds.lua         # Auto-commands
│       │   └── commands.lua         # Custom commands
│       ├── platform/
│       │   ├── init.lua             # Platform detection
│       │   ├── windows.lua          # Windows-specific
│       │   ├── macos.lua            # macOS-specific
│       │   ├── linux.lua            # Linux-specific
│       │   └── wsl.lua              # WSL-specific
│       ├── lsp/
│       │   └── init.lua             # Native LSP configuration
│       └── utils/
│           ├── clipboard.lua        # Clipboard helpers (OSC 52)
│           └── statusline.lua       # Simple statusline
├── install.sh                        # Linux/macOS/WSL installer
└── install.ps1                       # Windows installer
```

## Security Guarantees

| Security Aspect | Status |
|----------------|--------|
| **Plugins** | Zero |
| **External Downloads** | None (after install) |
| **Network Access** | Zero (core) / Optional (LSP servers) |
| **Telemetry** | Zero (telemetry disabled in all LSP configs) |
| **Remote Code Execution** | Zero |
| **Supply Chain Risk** | Minimal (single repo) |
| **Audit Complexity** | Simple (~800 lines of Lua) |

**LSP Security Note:** Language servers run as separate processes and may make network requests (e.g., for documentation). All LSP servers in nvim-core have telemetry explicitly disabled. Language servers are optional - nvim-core works fully without them.

**Safe for:**
- Production servers
- Client machines
- Air-gapped networks
- Highly regulated environments
- Untrusted systems

## Customization

nvim-core is designed to be easily customizable:

### Change Leader Key
Edit `lua/core/config/options.lua`:
```lua
vim.g.mapleader = ","  -- Change to comma
```

### Add Custom Keybindings
Edit `lua/core/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>custom", ":YourCommand<CR>")
```

### Modify Settings
Edit `lua/core/config/options.lua`:
```lua
vim.opt.relativenumber = false  -- Disable relative numbers
vim.opt.wrap = true              -- Enable line wrap
```

## Comparison

| | nvim-core | modulus-fidus-nvim | modulus-nvim |
|---|-----------|-------------------|--------------|
| **Plugins** | 0 | 20+ | 27+ |
| **Security** | Maximum | High | Medium |
| **Setup Time** | 10s | 5min | 5min |
| **Dependencies** | None | Some | Many |
| **Network After Install** | None | Yes (Mason) | Yes (Mason, updates) |
| **Production Servers** | Yes | Maybe | No |
| **Air-Gapped** | Easy | Possible | Hard |

## Commands Reference

### Custom Commands

- `:CoreHelp` - Show quick help
- `:ClipboardStatus` - Check clipboard integration
- `:W` - Save with sudo
- `:BufOnly` - Close all buffers except current
- `:TrimWhitespace` - Remove trailing whitespace
- `:FormatJSON` - Format JSON file
- `:FileInfo` - Show file information

### Built-in Commands

- `:find <file>` - Find and open file
- `:grep <pattern>` - Search in files
- `:buffers` - List open buffers
- `:terminal` - Open terminal

## Troubleshooting

### Clipboard Not Working

**Linux:**
```bash
# Install xclip or xsel
sudo apt install xclip

# Check status
:ClipboardStatus
```

**WSL:**
```bash
# Install win32yank
# See: https://github.com/equalsraf/win32yank
```

### Colors Not Working

Enable true color support in your terminal emulator.

### Performance Issues with Large Files

nvim-core automatically disables certain features for files >1MB.

## Contributing

Contributions welcome! Please:
1. Keep it plugin-free
2. Maintain cross-platform compatibility
3. Add clear comments
4. Test on multiple platforms

## License

MIT License - See LICENSE file

## Related Projects

- **[modulus-nvim](https://github.com/EvanusModestus/modulus-nvim)** - Full-featured modular config
- **[modulus-fidus-nvim](https://github.com/EvanusModestus/modulus-fidus-nvim)** - Enterprise-hardened config

---

**nvim-core** - Absolutely secure editing, anywhere.
