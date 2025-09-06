# J0K34SEC Security Tools Installer

## 🎯 Project Overview
Cross-platform installer for essential security and bug hunting tools used in penetration testing and security research.

## 📁 Repository Structure

```
tools-installer/
├── install.py                     # Cross-platform Python launcher (MAIN ENTRY POINT)
├── main.sh                        # Linux/macOS installer script
├── main.ps1                       # Windows installer script  
├── manage_tools.sh                # Linux/macOS tool management
├── manage_tools.ps1               # Windows tool management
├── README.md                      # User documentation
├── logo.png                       # Project logo
├── .warp.md                       # Development context/notes
├── PROJECT_INFO.md                # This file
├── config/
│   └── gau.toml                   # GAU tool configuration
└── installers/
    ├── arch_installer             # Arch Linux specific installer
    ├── debian_tools_installer     # Debian/Ubuntu specific installer
    ├── kali_installer             # Kali Linux specific installer
    ├── go_tool_installer.sh       # Go-based tools installer
    └── windows/
        ├── all_tools_installer.ps1 # Windows comprehensive installer
        └── go_tools_installer.ps1  # Windows Go tools installer
```

## 🚀 Quick Start

### Universal Installation (Recommended)
```bash
python install.py
```

### Platform-Specific
- **Windows**: `powershell -ExecutionPolicy Bypass -File main.ps1`
- **Linux/macOS**: `bash main.sh`

## 🛠️ Tool Management
- **Windows**: `.\manage_tools.ps1 list`
- **Linux/macOS**: `./manage_tools.sh list`

## 📋 Installed Tools

### Go-based Tools
- Subfinder, Nuclei, HTTPx, Naabu, FFUF, Waybackurls, Assetfinder, GAU, GoSpider

### Python-based Tools  
- SQLMap, XSStrike, ParamSpider

### Wordlists
- SecLists

## 🔧 Development Notes
- All files are clean and production-ready
- No Unicode characters used (Windows compatibility)
- Batch wrappers used instead of symlinks (no admin required)
- Comprehensive error handling and logging
- Cross-platform compatibility maintained

## 📝 Version
Current Version: 1.0.0 - Production Ready
Last Updated: September 2025
