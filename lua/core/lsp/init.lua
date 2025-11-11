-- ==============================================================================
-- Native LSP Configuration (Zero Plugins)
-- ==============================================================================
-- Uses Neovim's built-in LSP client - no external plugins required
-- Language servers must be installed manually on the system
-- ==============================================================================

local M = {}

-- ==============================================================================
-- LSP UI Configuration
-- ==============================================================================

-- Diagnostic signs in gutter
local signs = {
    Error = "✗",
    Warn = "⚠",
    Hint = "➤",
    Info = "ℹ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic configuration (Enhanced for maximum clarity)
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        source = "if_many",
        spacing = 4,  -- Add spacing before virtual text
        -- Format virtual text to show severity
        format = function(diagnostic)
            local severity = vim.diagnostic.severity[diagnostic.severity]
            return string.format("[%s] %s", severity, diagnostic.message)
        end,
    },
    signs = true,
    underline = true,
    update_in_insert = false,  -- Don't show diagnostics while typing
    severity_sort = true,      -- Show errors before warnings
    float = {
        focusable = true,       -- Allow focusing diagnostic window
        style = "minimal",
        border = "rounded",
        source = "always",      -- Always show diagnostic source
        header = "",
        prefix = function(diagnostic, i, total)
            -- Show diagnostic count and severity
            local severity = vim.diagnostic.severity[diagnostic.severity]
            return string.format("%d/%d [%s] ", i, total, severity), "DiagnosticSign" .. severity
        end,
        suffix = "",
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
})

-- Hover and signature help windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
)

-- ==============================================================================
-- LSP Keybindings (Buffer-specific)
-- ==============================================================================

-- These keybindings only activate when LSP is attached to a buffer
M.on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

    -- Information
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" }))

    -- Code Actions
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format document" }))

    -- Workspace
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

    -- Highlight symbol under cursor
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end

    -- ==================================================================
    -- AUTO-FORMAT ON SAVE (if supported)
    -- ==================================================================
    if client.server_capabilities.documentFormattingProvider then
        local group = vim.api.nvim_create_augroup("LSPFormatting", { clear = false })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = group,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    timeout_ms = 2000,
                    filter = function(format_client)
                        -- Only use this client for formatting
                        return format_client.name == client.name
                    end,
                })
            end,
            desc = "Auto-format on save with " .. client.name,
        })
    end

    -- ==================================================================
    -- INLAY HINTS (if supported - Rust, TypeScript, etc.)
    -- ==================================================================
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        -- Enable inlay hints by default
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        -- Toggle inlay hints with <leader>ih
        vim.keymap.set("n", "<leader>ih", function()
            local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
            vim.notify(
                "Inlay hints " .. (not current and "enabled" or "disabled"),
                vim.log.levels.INFO
            )
        end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
    end

    -- ==================================================================
    -- CODELENS (if supported - Go, Rust, etc.)
    -- ==================================================================
    if client.server_capabilities.codeLensProvider then
        local group = vim.api.nvim_create_augroup("LSPCodeLens", { clear = false })

        -- Refresh codelens on buffer enter and save
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
            buffer = bufnr,
            group = group,
            callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
            desc = "Refresh codelens",
        })

        -- Run codelens with <leader>cl
        vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run,
            vim.tbl_extend("force", opts, { desc = "Run codelens" }))

        -- Refresh immediately on attach
        vim.lsp.codelens.refresh({ bufnr = bufnr })
    end

    -- ==================================================================
    -- SEMANTIC TOKENS (Enhanced syntax highlighting)
    -- ==================================================================
    if client.server_capabilities.semanticTokensProvider then
        -- Semantic tokens are automatically enabled, just notify
        vim.notify(
            string.format("LSP: %s attached with semantic tokens", client.name),
            vim.log.levels.INFO,
            { title = "LSP" }
        )
    end
end

-- ==============================================================================
-- Language Server Configurations
-- ==============================================================================

-- Common capabilities (enhanced completion)
M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Map server names to their actual executable commands
-- Many language servers have different executable names
local server_commands = {
    pyright = "pyright-langserver",
    lua_ls = "lua-language-server",
    tsserver = "typescript-language-server",
    bashls = "bash-language-server",
    clangd = "clangd",
    rust_analyzer = "rust-analyzer",
    gopls = "gopls",
    jsonls = "vscode-json-language-server",
    yamlls = "yaml-language-server",
    html = "vscode-html-language-server",
    cssls = "vscode-css-language-server",
}

-- List of language servers to auto-setup
-- Only servers that are installed on the system will be activated
M.servers = {
    -- Python
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                    typeCheckingMode = "basic",
                },
            },
        },
    },

    -- Lua
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },

    -- JavaScript/TypeScript
    tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
    },

    -- Bash
    bashls = {
        cmd = { "bash-language-server", "start" },
    },

    -- C/C++
    clangd = {
        cmd = { "clangd" },
    },

    -- Rust
    rust_analyzer = {
        cmd = { "rust-analyzer" },
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },

    -- Go
    gopls = {
        cmd = { "gopls" },
    },

    -- JSON
    jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
    },

    -- YAML
    yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
    },

    -- HTML/CSS
    html = {
        cmd = { "vscode-html-language-server", "--stdio" },
    },
    cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
    },

    -- Markdown
    marksman = {
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
    },
}

-- ==============================================================================
-- Setup Individual Language Server
-- ==============================================================================

-- Mapping of filetypes to language servers
local filetype_to_server = {
    python = "pyright",
    lua = "lua_ls",
    javascript = "tsserver",
    typescript = "tsserver",
    javascriptreact = "tsserver",
    typescriptreact = "tsserver",
    sh = "bashls",
    bash = "bashls",
    c = "clangd",
    cpp = "clangd",
    rust = "rust_analyzer",
    go = "gopls",
    json = "jsonls",
    yaml = "yamlls",
    html = "html",
    css = "cssls",
    markdown = "marksman",
}

function M.setup_server(server_name)
    local config = M.servers[server_name]
    if not config then
        return
    end

    -- Get command from config or use server_commands mapping
    local cmd = config.cmd
    if not cmd then
        local cmd_name = server_commands[server_name] or server_name
        cmd = { cmd_name }
    end

    -- Check if server executable exists
    local executable = cmd[1]
    if vim.fn.executable(executable) ~= 1 then
        -- Silently skip if server not installed
        return
    end

    -- Find project root directory
    local root_patterns = {
        '.git',
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        'Cargo.toml',
        'go.mod',
        'pyproject.toml',
        'setup.py',
        'requirements.txt',
        'Makefile',
    }

    local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
    if not root_dir then
        root_dir = vim.fn.getcwd()
    end

    -- Merge configurations
    local setup_config = vim.tbl_deep_extend("force", {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
    }, config)

    -- Start the language server
    local client_id = vim.lsp.start({
        name = server_name,
        cmd = cmd,
        root_dir = root_dir,
        on_attach = setup_config.on_attach,
        capabilities = setup_config.capabilities,
        settings = setup_config.settings or {},
        init_options = setup_config.init_options or {},
    })

    -- Verify server started
    if client_id then
        vim.notify(string.format("LSP: %s started (root: %s)", server_name, root_dir), vim.log.levels.INFO)
    else
        vim.notify(string.format("LSP: Failed to start %s", server_name), vim.log.levels.ERROR)
    end
end

-- ==============================================================================
-- Auto-start LSP for supported filetypes
-- ==============================================================================

vim.api.nvim_create_autocmd("FileType", {
    pattern = vim.tbl_keys(filetype_to_server),
    callback = function(args)
        local server = filetype_to_server[args.match]
        if server then
            M.setup_server(server)
        end
    end,
})

return M
