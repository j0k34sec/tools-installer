# J0K34SEC Security Tools Installer

<img src="https://github.com/jokerexe01/tools-installer/blob/main/logo.png" alt="Tools Installer Logo" width="500"/>

> An all-in-one installer for essential security and bug hunting tools

## Overview

This tool simplifies the installation process for various security tools used in bug hunting, penetration testing, and security research. It automatically installs and configures a comprehensive set of tools while handling dependencies and environment setup.

## Features

- **Multiple OS Support**: Works on Arch, Debian, Kali, and other Linux distributions
- **Smart Installation**: Detects your OS and installs tools using appropriate methods
- **Manual Installation**: Doesn't rely on package helpers like yay, uses direct source installation when needed
- **Dependency Management**: Automatically installs required dependencies
- **Tool Configuration**: Sets up proper configurations and PATH variables
- **Self-Updating**: Can update itself and installed tools

## Installed Tools

### Web Application Tools
- **SQLMap**: SQL injection detection and exploitation
- **XSStrike**: Cross-site scripting detection and exploitation
- **WPScan**: WordPress vulnerability scanner
- **Ghauri**: Advanced SQL injection tool
- **Feroxbuster**: Fast content discovery tool
- **FFUF**: Fast web fuzzer
- **ParamSpider**: Parameter discovery for web applications

### Network Tools
- **Naabu**: Fast port scanner
- **Nuclei**: Vulnerability scanner
- **Httpx**: HTTP toolkit

### Reconnaissance Tools
- **Subfinder**: Subdomain discovery tool
- **Assetfinder**: Asset discovery
- **Waybackurls**: Historical URL discovery
- **GAU**: Get All URLs
- **GoSpider**: Web spider

### Wordlists
- **SecLists**: Collection of multiple types of lists for security assessments

## Installation

### Prerequisites

- Linux-based operating system (Arch, Debian, Kali, or other distributions)
- Basic development tools (git, base-devel/build-essential)
- Python 3.6+
- Internet connection

### Quick Install

```bash
# Clone the repository
git clone https://github.com/j0k34sec/tools-installer.git
cd tools-installer

# Run the installer
bash main.sh
```

### One-Liner Installation

For those who prefer a one-line command to download and run the installer:

```bash
git clone https://github.com/j0k34sec/tools-installer.git && cd tools-installer && bash main.sh
```

Or using curl to download and execute in one command:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/j0k34sec/tools-installer/main/main.sh)"
```

## Usage

The installer provides an interactive terminal interface. Just follow the prompts to install the tools you need.

```bash
# Run the main installer
bash main.sh
```

### Post-Installation Setup

#### For Bash users
```bash
# Update your current shell environment
source ~/.bashrc

# You can also run the fix script to update your PATH
source ~/Tools/fix_go_tools.sh
```

#### For Zsh users
```bash
# Update your current shell environment
source ~/.zshrc

# You can also run the fix script to update your PATH
source ~/Tools/fix_go_tools.sh
```

## Configuration

The installer creates a `~/Tools` directory where most tools are installed. System packages are installed using the system's package manager (pacman, apt, etc.).

## Updating

To update the installed tools and the installer itself:

```bash
# Re-run the installer
bash main.sh

# The script will detect existing installations and update them
```

## Troubleshooting

### Common Issues

1. **Tool not found after installation**
   
   For Bash users:
   ```bash
   # Update your current shell environment
   source ~/.bashrc
   
   # Run the fix script
   source ~/Tools/fix_go_tools.sh
   ```
   
   For Zsh users:
   ```bash
   # Update your current shell environment
   source ~/.zshrc
   
   # Run the fix script
   source ~/Tools/fix_go_tools.sh
   ```
   
   Or simply restart your terminal to apply all changes.

2. **Permission errors during installation**
   - Make sure you have sudo privileges
   - Check the log file at `~/Tools/install_errors.log`

3. **Dependency issues**
   - The installer will attempt to install dependencies automatically
   - Check the log file for specific errors

## Contributing

Contributions are welcome! If you want to add other tools or improve the installer:

1. Fork the repository
2. Create a feature branch: `git checkout -b new-feature`
3. Commit your changes: `git commit -am 'Add new tool'`
4. Push to the branch: `git push origin new-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to all the developers of the security tools included
- Inspired by various security tool installers in the community

---

Created by [J0K34SEC](https://github.com/j0k34sec) - "Simplifying security tool installation for everyone."
