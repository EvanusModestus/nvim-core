# ==============================================================================
# nvim-core Installation Script for Windows
# ==============================================================================
# Usage: iwr -useb https://raw.githubusercontent.com/EvanusModestus/nvim-core/main/install.ps1 | iex
# ==============================================================================

$ErrorActionPreference = "Stop"

# Configuration
$RepoUrl = "https://github.com/EvanusModestus/nvim-core.git"
$InstallDir = "$env:LOCALAPPDATA\nvim"
$BackupDir = "$InstallDir.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "==================================================================" -ForegroundColor Green
Write-Host "  nvim-core Installation" -ForegroundColor Green
Write-Host "  Zero-plugin, maximum security Neovim configuration" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Host ""

# Check if Neovim is installed
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Neovim is not installed" -ForegroundColor Red
    Write-Host "Please install Neovim first: https://github.com/neovim/neovim/wiki/Installing-Neovim"
    exit 1
}

# Check Neovim version
$nvimVersion = (nvim --version | Select-Object -First 1) -replace '.*v(\d+\.\d+).*', '$1'
Write-Host "Neovim version: $nvimVersion" -ForegroundColor Green

# Backup existing configuration
if (Test-Path $InstallDir) {
    Write-Host "Existing configuration found" -ForegroundColor Yellow
    Write-Host "Backing up to: $BackupDir"
    Move-Item -Path $InstallDir -Destination $BackupDir -Force
    Write-Host "✓ Backup created" -ForegroundColor Green
}

# Clone repository
Write-Host ""
Write-Host "Installing nvim-core to: $InstallDir"

try {
    git clone --depth 1 $RepoUrl $InstallDir 2>&1 | Out-Null
    Write-Host "✓ nvim-core installed successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Installation failed" -ForegroundColor Red
    # Restore backup if installation failed
    if (Test-Path $BackupDir) {
        Move-Item -Path $BackupDir -Destination $InstallDir -Force
        Write-Host "✓ Restored previous configuration" -ForegroundColor Green
    }
    exit 1
}

# Create undo directory
$UndoDir = "$env:LOCALAPPDATA\nvim-data\undo"
New-Item -ItemType Directory -Force -Path $UndoDir | Out-Null
Write-Host "✓ Created undo directory" -ForegroundColor Green

# Success message
Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Launch Neovim with: nvim"
Write-Host ""
Write-Host "Quick reference:"
Write-Host "  Leader key:  Space"
Write-Host "  File explorer:  <leader>e"
Write-Host "  Find files:  <leader>pf"
Write-Host "  Help:  :CoreHelp"
Write-Host ""
Write-Host "For full documentation, visit:"
Write-Host "  https://github.com/EvanusModestus/nvim-core"
Write-Host ""

# Optional: Launch Neovim
$launch = Read-Host "Launch Neovim now? (y/N)"
if ($launch -eq "y" -or $launch -eq "Y") {
    nvim
}
