# Neovim Dependencies Installer for Windows
# This script installs all required tools for Neovim with Mason, LSPs, and Treesitter support

# Require administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Neovim Dependencies Installer" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Check if Chocolatey is installed
function Test-Chocolatey {
    $chocoPath = Get-Command choco -ErrorAction SilentlyContinue
    if ($chocoPath) {
        Write-Host "✓ Chocolatey is installed" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Chocolatey is not installed" -ForegroundColor Yellow
        Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Host "✓ Chocolatey installed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "✗ Failed to install Chocolatey" -ForegroundColor Red
            return $false
        }
    }
}

# Check if a command exists
function Test-CommandExists {
    param([string]$command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

# Install packages
function Install-Package {
    param(
        [string]$name,
        [string]$chocoPackage,
        [string]$wingetId,
        [string]$testCommand
    )
    
    if (Test-CommandExists $testCommand) {
        Write-Host "✓ $name is already installed" -ForegroundColor Green
        return
    }
    
    Write-Host "Installing $name..." -ForegroundColor Cyan
    
    if (Test-Chocolatey) {
        choco install $chocoPackage -y
    } elseif ($wingetId) {
        winget install $wingetId -e
    }
    
    if (Test-CommandExists $testCommand) {
        Write-Host "✓ $name installed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to install $name" -ForegroundColor Red
    }
}

Write-Host "Checking and installing dependencies..." -ForegroundColor Cyan
Write-Host ""

# Install ripgrep (rg)
Install-Package "ripgrep (rg)" "ripgrep" "BurntSushi.ripgrep.MSVC" "rg"

# Install C Compiler (WinLibs)
if (Test-CommandExists "gcc") {
    Write-Host "✓ C compiler (gcc) is already installed" -ForegroundColor Green
} else {
    Write-Host "Installing C compiler (WinLibs)..." -ForegroundColor Cyan
    winget install --id=BrechtSanders.WinLibs.POSIX.UCRT -e -y
    if (Test-CommandExists "gcc") {
        Write-Host "✓ C compiler installed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to install C compiler" -ForegroundColor Red
    }
}

# Install tree-sitter CLI
Install-Package "tree-sitter CLI" "tree-sitter" "" "tree-sitter"

# Install Node.js
Install-Package "Node.js" "nodejs" "OpenJS.NodeJS" "node"

# Install 7-Zip (for decompression)
Install-Package "7-Zip" "7zip" "7zip.7zip" "7z"

# Install fd (file finder)
Install-Package "fd (file finder)" "fd" "sharkdp.fd" "fd"

Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Verify installations
Write-Host "Verifying installations..." -ForegroundColor Cyan
Write-Host ""

$tools = @(
    @{name="ripgrep"; cmd="rg"; flag="--version"},
    @{name="gcc"; cmd="gcc"; flag="--version"},
    @{name="tree-sitter"; cmd="tree-sitter"; flag="--version"},
    @{name="Node.js"; cmd="node"; flag="--version"},
    @{name="npm"; cmd="npm"; flag="--version"},
    @{name="7-Zip"; cmd="7z"; flag="--version"},
    @{name="fd"; cmd="fd"; flag="--version"}
)

foreach ($tool in $tools) {
    if (Test-CommandExists $tool.cmd) {
        $version = & $tool.cmd $tool.flag 2>&1 | Select-Object -First 1
        Write-Host "✓ $($tool.name): $version" -ForegroundColor Green
    } else {
        Write-Host "✗ $($tool.name): Not found in PATH" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart your terminal/PowerShell to refresh the PATH environment variable" -ForegroundColor White
Write-Host "2. Restart Neovim" -ForegroundColor White
Write-Host "3. Run ':checkhealth' in Neovim to verify everything is working" -ForegroundColor White
Write-Host "4. Run ':Mason' to install language servers and tools" -ForegroundColor White
