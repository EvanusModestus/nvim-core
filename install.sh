#!/bin/bash
# ==============================================================================
# nvim-core Installation Script
# ==============================================================================
# Installs nvim-core for Linux, macOS, and WSL
# Usage: curl -fsSL https://raw.githubusercontent.com/EvanusModestus/nvim-core/main/install.sh | bash
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/EvanusModestus/nvim-core.git"
INSTALL_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_DIR="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"

echo -e "${GREEN}==================================================================${NC}"
echo -e "${GREEN}  nvim-core Installation${NC}"
echo -e "${GREEN}  Zero-plugin, maximum security Neovim configuration${NC}"
echo -e "${GREEN}==================================================================${NC}"
echo ""

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}Error: Neovim is not installed${NC}"
    echo "Please install Neovim first: https://github.com/neovim/neovim/wiki/Installing-Neovim"
    exit 1
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -n 1 | grep -oP 'v\K[0-9]+\.[0-9]+')
REQUIRED_VERSION="0.9"

echo -e "Neovim version: ${GREEN}$NVIM_VERSION${NC}"
if [[ $(echo "$NVIM_VERSION < $REQUIRED_VERSION" | bc -l) -eq 1 ]]; then
    echo -e "${YELLOW}Warning: Neovim $REQUIRED_VERSION or higher is recommended${NC}"
fi

# Backup existing configuration
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Existing configuration found${NC}"
    echo -e "Backing up to: ${BACKUP_DIR}"
    mv "$INSTALL_DIR" "$BACKUP_DIR"
    echo -e "${GREEN}✓${NC} Backup created"
fi

# Clone repository
echo ""
echo "Installing nvim-core to: $INSTALL_DIR"
git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} nvim-core installed successfully"
else
    echo -e "${RED}✗${NC} Installation failed"
    # Restore backup if installation failed
    if [ -d "$BACKUP_DIR" ]; then
        mv "$BACKUP_DIR" "$INSTALL_DIR"
        echo -e "${GREEN}✓${NC} Restored previous configuration"
    fi
    exit 1
fi

# Create undo directory
UNDO_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/undo"
mkdir -p "$UNDO_DIR"
echo -e "${GREEN}✓${NC} Created undo directory"

# Optional: Install clipboard tools
echo ""
echo -e "${YELLOW}Clipboard Integration:${NC}"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! command -v xclip &> /dev/null && ! command -v xsel &> /dev/null; then
        echo -e "${YELLOW}  No clipboard tool detected${NC}"
        echo "  For system clipboard support, install one of:"
        echo "    - xclip:  sudo apt install xclip"
        echo "    - xsel:   sudo apt install xsel"
        echo "    - wl-clipboard (Wayland): sudo apt install wl-clipboard"
    else
        echo -e "${GREEN}  ✓ Clipboard tool detected${NC}"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}  ✓ macOS native clipboard (pbcopy/pbpaste)${NC}"
elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    if ! command -v win32yank.exe &> /dev/null; then
        echo -e "${YELLOW}  win32yank.exe not found${NC}"
        echo "  For WSL clipboard support, install win32yank:"
        echo "    https://github.com/equalsraf/win32yank"
    else
        echo -e "${GREEN}  ✓ win32yank detected${NC}"
    fi
fi

# Success message
echo ""
echo -e "${GREEN}==================================================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}==================================================================${NC}"
echo ""
echo "Launch Neovim with: nvim"
echo ""
echo "Quick reference:"
echo "  Leader key:  Space"
echo "  File explorer:  <leader>e"
echo "  Find files:  <leader>pf"
echo "  Help:  :CoreHelp"
echo ""
echo "For full documentation, visit:"
echo "  https://github.com/EvanusModestus/nvim-core"
echo ""

# Optional: Launch Neovim
read -p "Launch Neovim now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nvim
fi
