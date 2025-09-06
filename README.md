# J0K34SEC Security Tools Installer

<img src="https://github.com/jokerexe01/tools-installer/blob/main/logo.png" alt="Tools Installer Logo" width="500"/>

> **A comprehensive, cross-platform installer for essential security and bug hunting tools**

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## 🎯 Overview

This automated installer simplifies the setup process for a comprehensive suite of security tools used in:
- 🔍 **Bug Hunting & Penetration Testing**
- 🛡️ **Security Research & Red Team Operations**
- 🌐 **Web Application Security Assessment**
- 📊 **Network Reconnaissance & Vulnerability Scanning**

The installer automatically handles dependencies, environment configuration, and PATH management across multiple operating systems.

## ⭐ Key Features

- **🚀 One-Command Installation**: Single command installs everything you need
- **🔄 Cross-Platform Support**: Windows, Linux (Arch, Debian, Kali), and macOS
- **🤖 Intelligent Detection**: Auto-detects your OS and uses appropriate installation methods
- **📦 Multiple Installation Methods**: System packages, Go tools, Python virtual environments, and binary downloads
- **🛠️ Advanced Tool Management**: List, test, update, and uninstall tools with built-in management utilities
- **🎨 Beautiful Progress Visualization**: Spinners, progress bars, and color-coded output
- **📋 Comprehensive Logging**: Detailed logs with error tracking and troubleshooting info
- **⚡ No Admin Required**: User-level installations with smart PATH management
- **🔧 Self-Updating**: Automatically checks for and applies updates

## 🧰 Installed Security Tools

### 🕵️ Web Application Security
| Tool | Description | Type |
|------|-------------|------|
| **SQLMap** | Advanced SQL injection detection and exploitation | Python |
| **XSStrike** | Cross-site scripting (XSS) detection and exploitation | Python |
| **Ghauri** | Advanced blind SQL injection detection tool | Python |
| **ParamSpider** | Parameter discovery for web applications | Python |
| **WPScan** | WordPress vulnerability scanner | Ruby |

### 🔍 Discovery & Content Enumeration
| Tool | Description | Type |
|------|-------------|------|
| **Feroxbuster** | Fast content discovery with recursive scanning | Binary |
| **FFUF** | Fast web fuzzer written in Go | Go |
| **GoSpider** | Fast web crawler for URL discovery | Go |

### 🌍 Network & Infrastructure
| Tool | Description | Type |
|------|-------------|------|
| **Naabu** | Fast SYN/CONNECT port scanner | Go |
| **Nuclei** | Template-based vulnerability scanner | Go |
| **Httpx** | Fast HTTP toolkit for probing services | Go |

### 📊 Reconnaissance & OSINT
| Tool | Description | Type |
|------|-------------|------|
| **Subfinder** | Subdomain discovery using passive sources | Go |
| **Assetfinder** | Domain and subdomain discovery | Go |
| **Waybackurls** | Fetch URLs from Wayback Machine archives | Go |
| **GAU** | Get All URLs from multiple sources | Go |

### 📁 Wordlists & Resources
| Resource | Description | Size |
|----------|-------------|------|
| **SecLists** | Comprehensive collection of security testing lists | ~1GB |

### 🛠️ Installation Methods by Tool Type
- **🐍 Python Tools**: Isolated virtual environments with wrapper scripts
- **🟢 Go Tools**: Direct `go install` with automatic PATH management  
- **💻 Binary Tools**: GitHub releases with batch/script wrappers
- **📦 System Tools**: Native package managers (apt, pacman, choco, scoop)

## 🚀 Installation

### 📺 Prerequisites

| Platform | Requirements |
|----------|-------------|
| **All** | Git, Python 3.6+, Internet connection |
| **Linux** | Basic development tools (`base-devel`/`build-essential`), Bash shell |
| **Windows** | PowerShell 5.0+, Administrator privileges (recommended) |
| **macOS** | Xcode Command Line Tools, Homebrew (recommended) |

### ⚡ Quick Start (Universal Method)

**🎆 One-liner installation:**

```bash
# Clone and install in one command
git clone https://github.com/j0k34sec/tools-installer.git && cd tools-installer && python install.py
```

**🔧 Step-by-step installation:**

```bash
# 1. Clone the repository
git clone https://github.com/j0k34sec/tools-installer.git
cd tools-installer

# 2. Run the universal launcher (auto-detects your OS)
python install.py
# or python3 install.py on some Linux distributions
```

> 📝 **The universal launcher automatically detects your operating system and runs the appropriate platform-specific installer.**

### 💻 Platform-Specific Installation

<details>
<summary><strong>🐧 Linux/macOS Installation</strong></summary>

```bash
# Direct installation using bash
bash main.sh

# One-liner from GitHub
curl -fsSL https://raw.githubusercontent.com/j0k34sec/tools-installer/main/main.sh | bash

# Manual clone and run
git clone https://github.com/j0k34sec/tools-installer.git
cd tools-installer
bash main.sh
```

**Supported Distributions:**
- 🟢 Kali Linux 2022+
- 🟠 Ubuntu 20.04+
- 🔵 Debian 10+
- 🟣 Arch Linux / Manjaro
- 🟡 EndeavourOS

</details>

<details>
<summary><strong>💻 Windows Installation</strong></summary>

```powershell
# Standard PowerShell installation
.\main.ps1

# If execution policy blocks the script
powershell -ExecutionPolicy Bypass -File main.ps1

# Direct from GitHub (requires unrestricted execution policy)
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/j0k34sec/tools-installer/main/main.ps1'))

# One-liner clone and install
git clone https://github.com/j0k34sec/tools-installer.git; cd tools-installer; powershell -ExecutionPolicy Bypass -File main.ps1
```

**Supported Versions:**
- ✅ Windows 11 (All versions)
- ✅ Windows 10 (Build 1809+)
- ✅ Windows Server 2016+

</details>

## 🔧 Usage & Tool Management

### 🚀 Installation Process

The installer provides a **beautiful, interactive terminal interface** with:
- ✨ Real-time progress bars and spinners
- 🎨 Color-coded output for easy reading
- 📋 Detailed logging for troubleshooting
- 🔄 Automatic dependency resolution
- ⚡ Parallel installation for speed

Simply run the installer and follow the prompts!

### 🛠️ Tool Management Commands

<details>
<summary><strong>🐧 Linux/macOS Management</strong></summary>

```bash
# List all installed tools with status
bash manage_tools.sh list

# Test tool functionality
bash manage_tools.sh test

# Uninstall all tools
bash manage_tools.sh uninstall

# Show help and available commands
bash manage_tools.sh help

# Check specific tool installation
which nuclei && nuclei -version
which subfinder && subfinder -version
```

</details>

<details>
<summary><strong>💻 Windows Management</strong></summary>

```powershell
# List all installed tools with status
.\manage_tools.ps1 list

# Test tool functionality
.\manage_tools.ps1 test

# Show PATH configuration
.\manage_tools.ps1 path

# Clean installation files
.\manage_tools.ps1 clean

# Show help and available commands
.\manage_tools.ps1 help

# Check specific tool installation
Get-Command nuclei; nuclei -version
Get-Command feroxbuster; feroxbuster -V
```

</details>

### ⚙️ Tool Verification

After installation, verify your tools are working:

```bash
# Quick verification (works on all platforms)
nuclei -version           # Vulnerability scanner
subfinder -version        # Subdomain enumeration
feroxbuster -V           # Content discovery
ffuf -V                  # Web fuzzer
sqlmap --version         # SQL injection
```

### Post-Installation Setup

#### Linux/macOS

##### For Bash users
```bash
# Update your current shell environment
source ~/.bashrc

# You can also run the fix script to update your PATH
source ~/Tools/fix_go_tools.sh
```

##### For Zsh users
```bash
# Update your current shell environment
source ~/.zshrc

# You can also run the fix script to update your PATH
source ~/Tools/fix_go_tools.sh
```

#### Windows

```powershell
# The installer automatically updates PATH
# Restart PowerShell or Command Prompt to apply changes

# Verify installation
$env:PATH -split ';' | Select-String "Tools"
```

## ⚙️ Configuration & Directory Structure

### 📁 Installation Directories

<details>
<summary><strong>🐧 Linux/macOS Directory Structure</strong></summary>

```
~/Tools/                          # Main tools directory
├── sqlmap/                       # Python tools with virtual environments
│   ├── venv/                     # Isolated Python environment
│   └── sqlmap.py                 # Main tool script
├── XSStrike/
│   ├── venv/
│   └── xsstrike.py
├── wordlists/
│   └── SecLists/                 # Comprehensive wordlist collection
└── logs/
    └── install_errors.log       # Installation logs

~/go/bin/                         # Go tools directory
├── nuclei                        # Binary executables
├── subfinder
├── httpx
└── ...

/usr/local/bin/                   # System-wide symlinks
├── xsstrike -> ~/Tools/XSStrike/wrapper.sh
└── sqlmap-py -> ~/Tools/sqlmap/wrapper.sh
```

**Key Locations:**
- **Tools**: `~/Tools/`
- **Go Binaries**: `~/go/bin/`
- **Symlinks**: `/usr/local/bin/`
- **Logs**: `~/Tools/logs/`
- **Shell Config**: `~/.bashrc` / `~/.zshrc`

</details>

<details>
<summary><strong>💻 Windows Directory Structure</strong></summary>

```
%USERPROFILE%\Tools\              # Main tools directory
├── bin\                          # Batch wrappers for global access
│   ├── nuclei.bat                # Wrapper scripts
│   ├── feroxbuster.bat
│   └── sqlmap.bat
├── sqlmap\                       # Python tools with virtual environments
│   ├── venv\                     # Isolated Python environment
│   └── sqlmap.py                 # Main tool script
├── feroxbuster\                  # Binary tools
│   └── feroxbuster.exe           # Native executables
├── wordlists\                    
│   └── SecLists\                 # Wordlist collection
└── logs\                         # Installation and error logs

%USERPROFILE%\go\bin\             # Go tools directory
├── nuclei.exe                    # Go binary executables
├── subfinder.exe
└── httpx.exe
```

**Key Locations:**
- **Tools**: `%USERPROFILE%\Tools\`
- **Batch Wrappers**: `%USERPROFILE%\Tools\bin\` (in PATH)
- **Go Binaries**: `%USERPROFILE%\go\bin\`
- **Logs**: `%USERPROFILE%\Tools\logs\`
- **Package Managers**: Chocolatey / Scoop

</details>

## Updating

To update the installed tools and the installer itself:

### Cross-Platform
```bash
# Using the universal launcher
python install.py
```

### Platform-Specific

#### Linux/macOS
```bash
# Re-run the installer
bash main.sh
```

#### Windows
```powershell
# Re-run the installer
.\main.ps1
```

The script will detect existing installations and update them automatically.

## Troubleshooting

### Common Issues

1. **Tool not found after installation**
   
   **Linux/macOS:**
   ```bash
   # For Bash
   source ~/.bashrc
   source ~/Tools/fix_go_tools.sh
   
   # For Zsh
   source ~/.zshrc
   source ~/Tools/fix_go_tools.sh
   ```
   
   **Windows:**
   ```powershell
   # Restart PowerShell or run:
   $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User")
   ```
   
   Or simply restart your terminal to apply all changes.

2. **Permission errors during installation**
   
   **Linux/macOS:**
   - Make sure you have sudo privileges
   - Check the log file at `~/Tools/install_errors.log`
   
   **Windows:**
   - Run PowerShell as Administrator
   - Check execution policy: `Get-ExecutionPolicy`
   - If restricted: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

3. **PowerShell execution policy (Windows)**
   ```powershell
   # Bypass for single session
   powershell -ExecutionPolicy Bypass -File main.ps1
   
   # Or change policy permanently
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Python not found**
   
   **Windows:** Download from https://www.python.org/downloads/
   
   **Linux:** `sudo apt install python3` or `sudo pacman -S python`
   
   **macOS:** `brew install python3`

5. **Dependency issues**
   - The installer will attempt to install dependencies automatically
   - Check the log file for specific errors:
     - Linux/macOS: `~/Tools/install_errors.log`
     - Windows: `%USERPROFILE%\Tools\install_errors.log`

## Supported Platforms

| Platform | Version | Status |
|----------|---------|--------|
| **Linux** | | |
| Kali Linux | 2022+ | ✅ Fully Supported |
| Ubuntu | 20.04+ | ✅ Fully Supported |
| Debian | 10+ | ✅ Fully Supported |
| Arch Linux | Latest | ✅ Fully Supported |
| Manjaro | Latest | ✅ Fully Supported |
| **Windows** | | |
| Windows 11 | All | ✅ Fully Supported |
| Windows 10 | 1809+ | ✅ Fully Supported |
| Windows Server | 2016+ | ✅ Fully Supported |
| **macOS** | | |
| macOS | 10.15+ | ⚠️ Partial Support |

## 📁 Repository Structure

```
tools-installer/
├── 🔄 install.py                    # 🎆 Universal cross-platform launcher
├── 🐧 main.sh                      # Linux/macOS main installer
├── 💻 main.ps1                     # Windows PowerShell installer
├── 🛠️ manage_tools.sh              # Linux/macOS tool management
├── 🛠️ manage_tools.ps1             # Windows tool management
├── 📝 README.md                   # Project documentation
├── 📝 WARP.md                     # Warp development context
├── 📝 PROJECT_INFO.md             # Project overview
├── 🎨 logo.png                     # Project branding
├── ⚙️ config/
│   └── gau.toml                  # GAU tool configuration
└── 📦 installers/                  # Platform-specific installers
    ├── 🔷 arch_installer           # Arch Linux (pacman)
    ├── 🟠 debian_tools_installer   # Debian/Ubuntu (apt)
    ├── 🟢 kali_installer           # Kali Linux specialized
    ├── 🔄 go_tool_installer.sh     # Go-based tools installer
    └── 💻 windows/                  # Windows-specific installers
        ├── all_tools_installer.ps1   # Comprehensive Windows installer
        └── go_tools_installer.ps1    # Windows Go tools installer
```

### 🎯 Key Components

| Component | Purpose | Platforms |
|-----------|---------|----------|
| `install.py` | 🎆 Universal launcher with OS detection | All |
| `main.sh/ps1` | 🚀 Main installation orchestrators | Linux/macOS, Windows |
| `manage_tools.*` | 🛠️ Tool management and verification | All |
| `installers/` | 📦 OS-specific installation logic | Platform-specific |
| `config/` | ⚙️ Tool configurations and templates | All |

## 🤝 Contributing & Development

**Contributions are highly welcome!** This project thrives on community input and improvements.

### 🚀 Quick Contribution Guide

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/tools-installer.git
cd tools-installer

# 2. Create feature branch
git checkout -b feature/awesome-new-tool

# 3. Make your changes
# Add new tools, fix bugs, improve documentation

# 4. Test thoroughly
python install.py  # Test universal launcher
bash main.sh       # Test Linux installer (if applicable)
.\main.ps1          # Test Windows installer (if applicable)

# 5. Commit and push
git add .
git commit -m "✨ Add awesome new security tool"
git push origin feature/awesome-new-tool

# 6. Create pull request
# Go to GitHub and create a PR with detailed description
```

### 🛠️ Development Areas

| Area | Description | Difficulty |
|------|-------------|------------|
| **New Tools** | Add more security tools to the installer | 🟢 Easy |
| **Platform Support** | Add support for new Linux distributions | 🟡 Medium |
| **UI/UX** | Improve progress bars, animations, colors | 🟢 Easy |
| **Error Handling** | Better error messages and recovery | 🟡 Medium |
| **Testing** | Automated testing and CI/CD | 🟠 Hard |
| **Documentation** | Improve docs and add examples | 🟢 Easy |

### 📝 Adding New Security Tools

<details>
<summary><strong>Adding Go-based Tools</strong></summary>

```bash
# 1. Edit the appropriate installer file:
# - installers/go_tool_installer.sh (Linux/macOS)
# - installers/windows/all_tools_installer.ps1 (Windows)

# 2. Add to the tools list:
$goTools = @{
    "github.com/user/tool@latest" = @("toolname", "Tool description")
}

# 3. Update management scripts:
# - manage_tools.sh
# - manage_tools.ps1

# 4. Test installation and functionality
```

</details>

<details>
<summary><strong>Adding Python-based Tools</strong></summary>

```bash
# 1. Add to Python tools section in installer
$pythonTools = @{
    "toolname" = @("https://github.com/user/repo.git", "Tool description")
}

# 2. Tool will automatically get:
# - Virtual environment in ~/Tools/toolname/venv/
# - Batch wrapper for global access
# - Requirements installation

# 3. Update tool management scripts to include new tool
```

</details>

<details>
<summary><strong>Adding Binary Tools</strong></summary>

```bash
# 1. Add to binary tools section (Windows example)
$binaryTools = @{
    "toolname" = @("https://github.com/user/repo", "filename.zip", "Tool description")
}

# 2. Tool will automatically:
# - Download from GitHub releases
# - Extract if needed
# - Create batch wrapper
# - Add to PATH
```

</details>

### 🎯 Adding New Platform Support

1. **Create platform installer**: Add new file in `installers/` directory
2. **Update OS detection**: Modify `install.py` to detect new platform
3. **Add management support**: Update tool management scripts
4. **Update documentation**: Add platform info to README.md
5. **Test thoroughly**: Ensure all tools install and work correctly

## 📡 Support & Community

### 💬 Getting Help

- **🐛 Bug Reports**: [GitHub Issues](https://github.com/j0k34sec/tools-installer/issues)
- **✨ Feature Requests**: [GitHub Discussions](https://github.com/j0k34sec/tools-installer/discussions)
- **📚 Documentation**: Check the [WARP.md](./WARP.md) for development context
- **🔍 Troubleshooting**: See the troubleshooting section above

### 📊 Project Status

![GitHub last commit](https://img.shields.io/github/last-commit/j0k34sec/tools-installer)
![GitHub issues](https://img.shields.io/github/issues/j0k34sec/tools-installer)
![GitHub stars](https://img.shields.io/github/stars/j0k34sec/tools-installer)
![GitHub forks](https://img.shields.io/github/forks/j0k34sec/tools-installer)

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License - Free to use, modify, and distribute
✅ Commercial use    ✅ Modification    ✅ Distribution    ✅ Private use
```

## 🙏 Acknowledgments

### 🏆 Special Thanks

- **Security Tool Developers**: Massive thanks to all the developers creating these amazing security tools
- **Community Contributors**: Everyone who has contributed code, bug reports, and suggestions
- **Beta Testers**: Users who helped test the installer on various platforms
- **Inspiration**: Various security tool installers and automation scripts in the community

### 🛠️ Built With

- **Python 3.x** - Universal launcher and cross-platform compatibility
- **Bash/PowerShell** - Platform-specific installation logic
- **Go** - Many of the security tools are built with Go
- **GitHub Actions** - Continuous integration and releases
- **Love & Coffee** ☕ - The essential ingredients

---

<div align="center">

### 🎆 **"Simplifying Security Tool Installation for Everyone"** 🎆

**Created with ❤️ by [J0K34SEC](https://github.com/j0k34sec)**

*Making cybersecurity accessible, one installation at a time*

---

⭐ **If this project helped you, please give it a star!** ⭐

[![GitHub stars](https://img.shields.io/github/stars/j0k34sec/tools-installer?style=social)](https://github.com/j0k34sec/tools-installer/stargazers)

</div>

