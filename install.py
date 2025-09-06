#!/usr/bin/env python3
"""
J0K34SEC Security Tools Installer - Universal Launcher
Cross-platform launcher that detects the operating system and runs the appropriate installer
"""

import os
import sys
import platform
import subprocess
import shutil
from pathlib import Path

# ANSI color codes for terminal output
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def print_banner():
    """Display the installer banner"""
    banner = f"""{Colors.CYAN}{Colors.BOLD}
     ╔═══════════════════════════════════════════════════════╗
     ║                                                       ║
     ║         ██╗ ██████╗ ██╗  ██╗██████╗ ██╗  ██╗        ║
     ║         ██║██╔═████╗██║ ██╔╝╚════██╗██║  ██║        ║
     ║         ██║██║██╔██║█████╔╝  █████╔╝███████║        ║
     ║    ██   ██║████╔╝██║██╔═██╗  ╚═══██╗╚════██║        ║
     ║    ╚█████╔╝╚██████╔╝██║  ██╗██████╔╝     ██║        ║
     ║    ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝      ╚═╝         ║
     ║                                                       ║
     ║     Security Tools Installer - Universal Launcher    ║
     ║                                                       ║
     ╚═══════════════════════════════════════════════════════╝
    {Colors.RESET}
    {Colors.YELLOW}{Colors.BOLD}      Your Ultimate Security Tools Installer{Colors.RESET}
    {Colors.CYAN}==================================================={Colors.RESET}
    """
    print(banner)

def detect_os():
    """Detect the operating system and return relevant information"""
    system = platform.system().lower()
    os_info = {
        'system': system,
        'platform': platform.platform(),
        'version': platform.version(),
        'machine': platform.machine(),
        'processor': platform.processor()
    }
    
    # Additional Linux distribution detection
    if system == 'linux':
        try:
            with open('/etc/os-release', 'r') as f:
                os_release = {}
                for line in f:
                    if '=' in line:
                        key, value = line.strip().split('=', 1)
                        os_release[key] = value.strip('"')
                os_info['distribution'] = os_release.get('ID', 'unknown')
                os_info['dist_name'] = os_release.get('NAME', 'Unknown Linux')
                os_info['dist_version'] = os_release.get('VERSION_ID', '')
        except:
            os_info['distribution'] = 'unknown'
            os_info['dist_name'] = 'Unknown Linux'
    
    return os_info

def check_prerequisites(os_info):
    """Check if basic prerequisites are installed"""
    prereqs = {
        'git': 'Git version control',
        'python3': 'Python 3.x',
        'pip': 'Python package manager'
    }
    
    if os_info['system'] == 'windows':
        prereqs['powershell'] = 'PowerShell'
    else:
        prereqs['bash'] = 'Bash shell'
    
    print(f"\n{Colors.MAGENTA}◉ CHECKING PREREQUISITES{Colors.RESET}")
    print(f"{Colors.CYAN}{'─' * 50}{Colors.RESET}")
    
    missing = []
    for cmd, desc in prereqs.items():
        if shutil.which(cmd):
            print(f"{Colors.GREEN}✓{Colors.RESET} {desc}: {Colors.GREEN}Installed{Colors.RESET}")
        else:
            # Special handling for python3/python on Windows
            if cmd == 'python3' and os_info['system'] == 'windows':
                if shutil.which('python'):
                    print(f"{Colors.GREEN}✓{Colors.RESET} {desc}: {Colors.GREEN}Installed (as 'python'){Colors.RESET}")
                    continue
            print(f"{Colors.RED}✗{Colors.RESET} {desc}: {Colors.RED}Not installed{Colors.RESET}")
            missing.append(desc)
    
    return missing

def get_installer_path(os_info):
    """Get the appropriate installer script path based on OS"""
    script_dir = Path(__file__).parent.absolute()
    
    if os_info['system'] == 'windows':
        installer = script_dir / 'main.ps1'
        if not installer.exists():
            return None, "Windows installer (main.ps1) not found"
        return installer, 'powershell'
    
    elif os_info['system'] in ['linux', 'darwin']:
        installer = script_dir / 'main.sh'
        if not installer.exists():
            return None, "Linux/Unix installer (main.sh) not found"
        return installer, 'bash'
    
    else:
        return None, f"Unsupported operating system: {os_info['system']}"

def run_installer(installer_path, shell_type, os_info):
    """Execute the appropriate installer script"""
    print(f"\n{Colors.MAGENTA}◉ LAUNCHING INSTALLER{Colors.RESET}")
    print(f"{Colors.CYAN}{'─' * 50}{Colors.RESET}")
    
    if os_info['system'] == 'windows':
        # Check execution policy
        print(f"{Colors.BLUE}Checking PowerShell execution policy...{Colors.RESET}")
        try:
            result = subprocess.run(['powershell', '-Command', 'Get-ExecutionPolicy'], 
                                  capture_output=True, text=True)
            policy = result.stdout.strip()
            
            if policy in ['Restricted', 'AllSigned']:
                print(f"{Colors.YELLOW}⚠ PowerShell execution policy is {policy}{Colors.RESET}")
                print(f"{Colors.YELLOW}Attempting to bypass for this session...{Colors.RESET}")
                cmd = ['powershell', '-ExecutionPolicy', 'Bypass', '-File', str(installer_path)]
            else:
                cmd = ['powershell', '-File', str(installer_path)]
            
            print(f"{Colors.GREEN}Launching Windows installer...{Colors.RESET}")
            subprocess.run(cmd)
            
        except Exception as e:
            print(f"{Colors.RED}Error running Windows installer: {e}{Colors.RESET}")
            print(f"\n{Colors.YELLOW}You can run the installer manually:{Colors.RESET}")
            print(f"  powershell -ExecutionPolicy Bypass -File {installer_path}")
            return False
    
    else:
        # Unix-like systems (Linux, macOS)
        try:
            # Make sure the script is executable
            installer_path.chmod(0o755)
            
            print(f"{Colors.GREEN}Launching {os_info.get('dist_name', 'Unix')} installer...{Colors.RESET}")
            
            # Check if we need sudo
            if os.getuid() != 0:
                print(f"{Colors.YELLOW}Note: Some installations may require sudo privileges{Colors.RESET}")
            
            subprocess.run([shell_type, str(installer_path)])
            
        except Exception as e:
            print(f"{Colors.RED}Error running installer: {e}{Colors.RESET}")
            print(f"\n{Colors.YELLOW}You can run the installer manually:{Colors.RESET}")
            print(f"  bash {installer_path}")
            return False
    
    return True

def show_manual_instructions(os_info):
    """Display manual installation instructions"""
    print(f"\n{Colors.MAGENTA}◉ MANUAL INSTALLATION INSTRUCTIONS{Colors.RESET}")
    print(f"{Colors.CYAN}{'─' * 50}{Colors.RESET}")
    
    if os_info['system'] == 'windows':
        print(f"""
{Colors.YELLOW}For Windows:{Colors.RESET}
1. Open PowerShell as Administrator
2. Navigate to the installer directory:
   cd {Path.cwd()}
3. Run the installer:
   powershell -ExecutionPolicy Bypass -File main.ps1
   
{Colors.BLUE}Alternative: Use the management script{Colors.RESET}
   .\\manage_tools.ps1 list    # List installed tools
   .\\manage_tools.ps1 help    # Show help
""")
    else:
        dist = os_info.get('distribution', 'linux')
        print(f"""
{Colors.YELLOW}For {os_info.get('dist_name', 'Linux')}:{Colors.RESET}
1. Open a terminal
2. Navigate to the installer directory:
   cd {Path.cwd()}
3. Make the script executable:
   chmod +x main.sh
4. Run the installer:
   ./main.sh
   
{Colors.BLUE}Alternative: Use the management script{Colors.RESET}
   ./manage_tools.sh list    # List installed tools
   ./manage_tools.sh help    # Show help
""")

def main():
    """Main entry point"""
    try:
        # Clear screen
        os.system('cls' if platform.system() == 'Windows' else 'clear')
        
        # Display banner
        print_banner()
        
        # Detect OS
        print(f"{Colors.MAGENTA}◉ SYSTEM DETECTION{Colors.RESET}")
        print(f"{Colors.CYAN}{'─' * 50}{Colors.RESET}")
        
        os_info = detect_os()
        print(f"Operating System: {Colors.GREEN}{os_info['platform']}{Colors.RESET}")
        print(f"System Type: {Colors.GREEN}{os_info['system'].title()}{Colors.RESET}")
        
        if os_info['system'] == 'linux':
            print(f"Distribution: {Colors.GREEN}{os_info.get('dist_name', 'Unknown')}{Colors.RESET}")
        
        print(f"Architecture: {Colors.GREEN}{os_info['machine']}{Colors.RESET}")
        
        # Check prerequisites
        missing_prereqs = check_prerequisites(os_info)
        
        if missing_prereqs:
            print(f"\n{Colors.RED}⚠ Missing prerequisites:{Colors.RESET}")
            for prereq in missing_prereqs:
                print(f"  - {prereq}")
            
            print(f"\n{Colors.YELLOW}Please install the missing prerequisites and try again.{Colors.RESET}")
            
            if os_info['system'] == 'windows':
                print(f"\n{Colors.BLUE}Installation guides:{Colors.RESET}")
                print("  Git: https://git-scm.com/download/win")
                print("  Python: https://www.python.org/downloads/windows/")
            else:
                print(f"\n{Colors.BLUE}Install using your package manager:{Colors.RESET}")
                if os_info.get('distribution') in ['ubuntu', 'debian', 'kali']:
                    print("  sudo apt update && sudo apt install git python3 python3-pip")
                elif os_info.get('distribution') in ['arch', 'manjaro']:
                    print("  sudo pacman -S git python python-pip")
                elif os_info.get('distribution') in ['fedora', 'centos', 'rhel']:
                    print("  sudo dnf install git python3 python3-pip")
                else:
                    print("  Use your distribution's package manager to install: git, python3, pip")
        
        # Find and run the appropriate installer
        installer_path, shell_type = get_installer_path(os_info)
        
        if installer_path is None:
            print(f"\n{Colors.RED}Error: {shell_type}{Colors.RESET}")
            show_manual_instructions(os_info)
            return 1
        
        print(f"\n{Colors.GREEN}Found installer: {installer_path}{Colors.RESET}")
        
        # Ask for confirmation
        print(f"\n{Colors.YELLOW}Ready to install security tools for {os_info['system'].title()}.{Colors.RESET}")
        response = input(f"{Colors.CYAN}Do you want to continue? (y/n): {Colors.RESET}").lower()
        
        if response != 'y':
            print(f"{Colors.YELLOW}Installation cancelled.{Colors.RESET}")
            return 0
        
        # Run the installer
        if not run_installer(installer_path, shell_type, os_info):
            show_manual_instructions(os_info)
            return 1
        
        print(f"\n{Colors.GREEN}{Colors.BOLD}Installation process completed!{Colors.RESET}")
        print(f"{Colors.CYAN}Thank you for using J0K34SEC Security Tools Installer!{Colors.RESET}")
        
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}Installation interrupted by user.{Colors.RESET}")
        return 130
    except Exception as e:
        print(f"\n{Colors.RED}An error occurred: {e}{Colors.RESET}")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
