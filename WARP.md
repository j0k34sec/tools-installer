# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Architecture

### Cross-Platform Security Tools Installer
This is a comprehensive, cross-platform installer for security and bug hunting tools used in penetration testing and security research. The project uses a multi-layered architecture with OS-specific implementations wrapped by universal launchers.

### Core Entry Points
- **`install.py`**: Primary universal launcher that auto-detects OS and delegates to platform-specific installers
- **`main.sh`**: Linux/macOS installer with sophisticated progress bars and error handling
- **`main.ps1`**: Windows PowerShell installer with package manager integration
- **`manage_tools.sh/ps1`**: Tool management utilities for listing, testing, and uninstalling

### Platform-Specific Installer Architecture
The `installers/` directory contains OS-specific installers that handle the actual tool installation:
- **`arch_installer`**: Arch Linux (pacman-based) installer with Arch branding
- **`debian_tools_installer`**: Debian/Ubuntu (apt-based) installer
- **`kali_installer`**: Specialized Kali Linux installer
- **`go_tool_installer.sh`**: Dedicated Go-based tools installer
- **Windows installers**: PowerShell scripts in `installers/windows/`

### Tool Installation Strategy
The installer uses multiple installation methods depending on the tool:
- **System packages**: Via native package managers (apt, pacman, choco, scoop)
- **Go tools**: Using `go install` command with proper PATH management
- **Python tools**: Virtual environments in `~/Tools/` with wrapper scripts/batch files
- **Binary tools**: Pre-built binaries from GitHub releases with batch wrappers (Windows)
- **Git repositories**: Direct cloning and building from source
- **Binary downloads**: Direct downloads with proper permissions and PATH setup

## Common Development Commands

### Installation Commands
```bash
# Universal installation (recommended)
python install.py

# Platform-specific installation
bash main.sh              # Linux/macOS
powershell -ExecutionPolicy Bypass -File main.ps1  # Windows
```

### Tool Management Commands
```bash
# List installed tools with status
bash manage_tools.sh list       # Linux/macOS
.\manage_tools.ps1 list          # Windows

# Test tool functionality
bash manage_tools.sh test       # Linux/macOS
.\manage_tools.ps1 test          # Windows

# Uninstall all tools
bash manage_tools.sh uninstall  # Linux/macOS
.\manage_tools.ps1 uninstall     # Windows

# Show PATH configuration
.\manage_tools.ps1 path          # Windows only
```

### Development Testing Commands
```bash
# Check individual tool installation
which subfinder    # Linux/macOS
Get-Command subfinder  # Windows

# Verify Go tools PATH
echo $PATH | grep go   # Linux/macOS
$env:Path -split ';' | Select-String "go"  # Windows

# Check Python virtual environments
ls ~/Tools/*/venv/     # Linux/macOS
Get-ChildItem "$env:USERPROFILE\Tools\*\venv\"  # Windows

# View installation logs
tail -f ~/Tools/install_errors.log           # Linux/macOS
Get-Content "$env:USERPROFILE\Tools\logs\*.txt" -Tail 10  # Windows
```

## Installation Directory Structure

### Linux/macOS
- **Tools directory**: `~/Tools/`
- **Go binaries**: `~/go/bin/`
- **Symlinks**: `/usr/local/bin/`
- **Logs**: `~/Tools/install_errors.log`
- **Configuration**: Individual tool configs in `~/.config/`

### Windows
- **Tools directory**: `%USERPROFILE%\Tools\`
- **Go binaries**: `%USERPROFILE%\go\bin\`
- **Batch wrappers**: `%USERPROFILE%\Tools\bin\` (added to PATH)
- **Logs**: `%USERPROFILE%\Tools\logs\`
- **Configuration**: Tool-specific config directories

## Key Design Patterns

### Progress Visualization System
The installer features sophisticated visual feedback with:
- **Spinner animations**: For long-running operations
- **Progress bars**: For multi-step processes with completion percentages
- **Section headers**: Consistent formatting with Unicode characters
- **Color-coded output**: Success (green), errors (red), warnings (yellow), info (blue)

### Error Handling and Logging
- All operations log to dedicated log files with timestamps
- Comprehensive error messages with suggested solutions
- Graceful fallbacks when package managers aren't available
- Command existence checks before execution

### PATH Management Strategy
- **Linux/macOS**: Updates shell configuration files (.bashrc, .zshrc) and creates symlinks
- **Windows**: Updates user-level PATH environment variable and creates batch file wrappers
- **Cross-platform**: Avoids admin requirements by using user-level installations

### Virtual Environment Management
Python tools are isolated using virtual environments:
- Each tool gets its own venv in `~/Tools/<tool-name>/venv/`
- Wrapper scripts/batch files activate venv before tool execution
- Requirements installed per-tool to avoid conflicts

## Installed Security Tools

### Web Application Security
- **SQLMap**: SQL injection detection/exploitation
- **XSStrike**: XSS vulnerability scanner with advanced payloads
- **Ghauri**: Advanced SQL injection tool
- **WPScan**: WordPress vulnerability scanner
- **ParamSpider**: Parameter discovery for web applications
- **SSRFmap**: Server-Side Request Forgery exploitation toolkit

### Discovery & Reconnaissance
- **Feroxbuster**: Fast content discovery with recursion (binary tool)
- **FFUF**: Fast web fuzzer written in Go
- **Subfinder**: Subdomain enumeration using passive sources
- **Assetfinder**: Find domains and subdomains related to targets
- **Waybackurls**: Fetch URLs from Wayback Machine archives
- **GAU (Get All URLs)**: Fetch URLs from multiple sources
- **GoSpider**: Fast web spider for URL discovery

### Network & Infrastructure
- **Naabu**: Fast port scanner with SYN packets
- **Nuclei**: Template-based vulnerability scanner
- **Httpx**: HTTP toolkit for probing web services
- **AWS CLI**: Amazon Web Services command line interface
- **Trufflehog**: Secret scanning in git repositories

### Wordlists
- **SecLists**: Comprehensive collection of security testing lists

## Code Quality Standards

### Shell Script Standards
- Consistent color variable usage (RED, GREEN, YELLOW, etc.)
- Comprehensive error handling with logging
- Progress animations for user feedback
- Proper quoting and error checking
- Function-based architecture for maintainability

### PowerShell Standards
- Strict mode enabled for better error handling
- Consistent parameter validation
- Try-catch blocks for exception handling
- Write-ColorOutput function for consistent formatting
- Administrative privilege checks where needed

### Cross-Platform Compatibility
- OS detection using `/etc/os-release` (Linux) and `platform` module (Python)
- Package manager detection and fallback strategies
- Path handling differences between Unix and Windows
- Unicode character handling for Windows compatibility

## Troubleshooting Common Issues

### PATH Not Updated
```bash
# Linux/macOS - reload shell configuration
source ~/.bashrc  # or ~/.zshrc
source ~/Tools/fix_go_tools.sh

# Windows - refresh environment variables
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User")
```

### PowerShell Execution Policy (Windows)
```powershell
# Check current policy
Get-ExecutionPolicy

# Set for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Bypass for single session
powershell -ExecutionPolicy Bypass -File main.ps1
```

### Missing Dependencies
The installer automatically handles dependencies, but manual installation may be needed:
```bash
# Linux dependencies
sudo apt install build-essential git python3-pip golang-go  # Debian/Ubuntu
sudo pacman -S base-devel git python-pip go                # Arch

# Windows dependencies (via Chocolatey)
choco install git python golang nodejs
```

### Go Tools Not Found
```bash
# Verify Go installation
go version

# Check GOPATH
echo $GOPATH        # Linux/macOS
echo $env:GOPATH    # Windows

# Manually add to PATH if needed
export PATH=$PATH:$HOME/go/bin        # Linux/macOS
$env:PATH += ";$env:USERPROFILE\go\bin"  # Windows
```
