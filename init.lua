-- ==============================================================================
-- NVIM-CORE: Zero-Plugin, Maximum Security Neovim Configuration
-- ==============================================================================
-- A professional, cross-platform Neovim configuration with absolutely no plugins.
-- Designed for maximum security, portability, and reliability across any environment.
--
-- Author: EvanusModestus
-- Repository: https://github.com/EvanusModestus/nvim-core
-- License: MIT
-- ==============================================================================

-- Load platform detection first
require('core.platform')

-- Load core configuration
require('core.config.options')
require('core.config.keymaps')
require('core.config.autocmds')
require('core.config.commands')

-- Load utilities
require('core.utils.statusline')
require('core.utils.clipboard')

-- Load LSP configuration (native Neovim LSP - zero plugins)
require('core.lsp')

-- Initialization complete
vim.notify("nvim-core loaded successfully", vim.log.levels.INFO)
