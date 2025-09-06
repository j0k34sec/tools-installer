# J0K34SEC Security Tools Installer for Windows
# Version: 1.0.0
# Repository: https://github.com/j0k34sec/tools-installer

param(
    [switch]$SkipUpdate,
    [switch]$Force,
    [switch]$Verbose
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Version information
$CURRENT_VERSION = "1.0.0"
$REPO_URL = "https://github.com/j0k34sec/tools-installer"
$REPO_RAW_URL = "https://raw.githubusercontent.com/j0k34sec/tools-installer/main"

# Define colors for output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

# Function to print banner
function Show-Banner {
    Clear-Host
    Write-ColorOutput "==========================================================" -Color Cyan
    Write-ColorOutput "           J0K34SEC SECURITY TOOLS INSTALLER" -Color Cyan
    Write-ColorOutput "==========================================================" -Color Cyan
    Write-ColorOutput "         Windows Edition v1.0 - PowerShell Installer" -Color Yellow
    Write-ColorOutput "==========================================================" -Color Cyan
    Write-ColorOutput ""
    Start-Sleep -Seconds 1
}

# Function to show progress
function Show-Progress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Activity
    )
    
    $percentComplete = ($Current / $Total) * 100
    Write-Progress -Activity $Activity -Status "$percentComplete% Complete" -PercentComplete $percentComplete
}

# Function to display section header
function Show-Section {
    param([string]$Title)
    
    Write-ColorOutput "`n[*] $Title" -Color Magenta
    Write-ColorOutput ("-" * 50) -Color Cyan
}

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install Chocolatey
function Install-Chocolatey {
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "Installing Chocolatey package manager..." -Color Blue
        
        try {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            
            # Refresh environment variables
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            
            Write-ColorOutput "[OK] Chocolatey installed successfully" -Color Green
        } catch {
            Write-ColorOutput "Failed to install Chocolatey: $_" -Color Red
            return $false
        }
    } else {
        Write-ColorOutput "[OK] Chocolatey is already installed" -Color Green
    }
    return $true
}

# Function to install Scoop
function Install-Scoop {
    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "Installing Scoop package manager..." -Color Blue
        
        try {
            Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
            
            # Refresh environment variables
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            
            Write-ColorOutput "[OK] Scoop installed successfully" -Color Green
        } catch {
            Write-ColorOutput "Failed to install Scoop: $_" -Color Red
            return $false
        }
    } else {
        Write-ColorOutput "[OK] Scoop is already installed" -Color Green
    }
    return $true
}

# Function to install basic requirements
function Install-BasicRequirements {
    Show-Section "INSTALLING BASIC REQUIREMENTS"
    
    $requirements = @{
        "git" = "Git version control"
        "python" = "Python 3.x"
        "go" = "Go programming language"
        "nodejs" = "Node.js runtime"
    }
    
    $installed = @()
    $failed = @()
    
    foreach ($tool in $requirements.Keys) {
        Write-ColorOutput "Checking $($requirements[$tool])..." -Color Blue
        
        $command = Get-Command $tool -ErrorAction SilentlyContinue
        
        if (!$command) {
            Write-ColorOutput "Installing $($requirements[$tool])..." -Color Yellow
            
            try {
                if (Get-Command choco -ErrorAction SilentlyContinue) {
                    choco install $tool -y --no-progress | Out-Null
                    $installed += $tool
                    Write-ColorOutput "[OK] $($requirements[$tool]) installed" -Color Green
                } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
                    scoop install $tool | Out-Null
                    $installed += $tool
                    Write-ColorOutput "[OK] $($requirements[$tool]) installed" -Color Green
                } else {
                    throw "No package manager available"
                }
            } catch {
                Write-ColorOutput "[ERROR] Failed to install $($requirements[$tool])" -Color Red
                $failed += $tool
            }
        } else {
            Write-ColorOutput "[OK] $($requirements[$tool]) is already installed" -Color Green
            $installed += $tool
        }
    }
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($failed.Count -gt 0) {
        Write-ColorOutput "`nFailed to install: $($failed -join ', ')" -Color Red
        Write-ColorOutput "Please install these manually and run the script again." -Color Yellow
        return $false
    }
    
    return $true
}

# Function to create Tools directory
function Initialize-ToolsDirectory {
    $toolsDir = "$env:USERPROFILE\Tools"
    
    if (!(Test-Path $toolsDir)) {
        Write-ColorOutput "Creating Tools directory at $toolsDir..." -Color Blue
        New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
        Write-ColorOutput "[OK] Tools directory created" -Color Green
    } else {
        Write-ColorOutput "[OK] Tools directory already exists" -Color Green
    }
    
    # Create subdirectories
    $subdirs = @("bin", "scripts", "config", "logs", "wordlists")
    foreach ($dir in $subdirs) {
        $subdir = Join-Path $toolsDir $dir
        if (!(Test-Path $subdir)) {
            New-Item -ItemType Directory -Path $subdir -Force | Out-Null
        }
    }
    
    # Add to PATH if not already there
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $toolsBin = Join-Path $toolsDir "bin"
    
    if ($currentPath -notlike "*$toolsBin*") {
        Write-ColorOutput "Adding Tools\bin to PATH..." -Color Blue
        [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$toolsBin", "User")
        $env:Path += ";$toolsBin"
        Write-ColorOutput "[OK] PATH updated" -Color Green
    } else {
        # Ensure it's in current session PATH even if already in user PATH
        if ($env:Path -notlike "*$toolsBin*") {
            $env:Path += ";$toolsBin"
        }
        Write-ColorOutput "[OK] Tools\bin already in PATH" -Color Green
    }
    
    return $toolsDir
}

# Function to check Windows version
function Test-WindowsVersion {
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $version = $osInfo.Version
    $caption = $osInfo.Caption
    
    Write-ColorOutput "Operating System: $caption" -Color Blue
    Write-ColorOutput "Version: $version" -Color Blue
    
    # Check if Windows 10 or 11
    $majorVersion = [int]($version.Split('.')[0])
    if ($majorVersion -lt 10) {
        Write-ColorOutput "Warning: This installer is optimized for Windows 10 and later." -Color Yellow
        Write-ColorOutput "Some features may not work on older versions." -Color Yellow
        
        $response = Read-Host "Do you want to continue anyway? (y/n)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            exit 1
        }
    }
    
    return $true
}

# Function to run installer based on category
function Start-ToolInstallation {
    param([string]$ToolsDir)
    
    Show-Section "TOOL INSTALLATION"
    
    Write-ColorOutput @"
Select installation option:
1. Install All Tools (Recommended)
2. Install Go-based Tools Only
3. Custom Selection
0. Exit
"@ -Color Cyan
    
    $choice = Read-Host "Enter your choice (0-3)"
    
    switch ($choice) {
        "1" {
            Write-ColorOutput "Installing all security tools..." -Color Green
            $allToolsInstaller = "$PSScriptRoot\installers\windows\all_tools_installer.ps1"
            
            if (Test-Path $allToolsInstaller) {
                & $allToolsInstaller -ToolsDir $ToolsDir
            } else {
                Write-ColorOutput "[WARNING] All tools installer not found. Installing Go tools only..." -Color Yellow
                $goInstaller = "$PSScriptRoot\installers\windows\go_tools_installer.ps1"
                if (Test-Path $goInstaller) {
                    & $goInstaller -ToolsDir $ToolsDir
                } else {
                    Write-ColorOutput "[ERROR] No installer scripts found!" -Color Red
                }
            }
        }
        "2" {
            Write-ColorOutput "Installing Go-based tools..." -Color Green
            $goInstaller = "$PSScriptRoot\installers\windows\go_tools_installer.ps1"
            if (Test-Path $goInstaller) {
                & $goInstaller -ToolsDir $ToolsDir
            } else {
                Write-ColorOutput "[ERROR] Go tools installer not found!" -Color Red
            }
        }
        "3" {
            Write-ColorOutput "Custom installation not yet implemented." -Color Yellow
            Write-ColorOutput "Please run individual installer scripts manually." -Color Yellow
        }
        "0" {
            Write-ColorOutput "Installation cancelled." -Color Yellow
            exit 0
        }
        default {
            Write-ColorOutput "Invalid choice. Please try again." -Color Red
            Start-ToolInstallation -ToolsDir $ToolsDir
        }
    }
}

# Main execution
function Main {
    # Show banner
    Show-Banner
    
    # Check if running as administrator
    if (!(Test-Administrator)) {
        Write-ColorOutput "[WARNING] Not running as administrator." -Color Yellow
        Write-ColorOutput "Some installations may fail without admin privileges." -Color Yellow
        Write-ColorOutput "It's recommended to run this script as Administrator." -Color Yellow
        
        $response = Read-Host "`nDo you want to continue anyway? (y/n)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            Write-ColorOutput "Restarting as Administrator..." -Color Blue
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
            exit
        }
    }
    
    # Log file setup
    $logsDir = "$env:USERPROFILE\Tools\logs"
    if (!(Test-Path $logsDir)) {
        New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
    }
    $logFile = "$logsDir\install_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    Start-Transcript -Path $logFile -Append
    
    try {
        # Check Windows version
        Test-WindowsVersion
        
        # Install package managers
        Show-Section "PACKAGE MANAGERS"
        
        if (Test-Administrator) {
            $chocoInstalled = Install-Chocolatey
        } else {
            Write-ColorOutput "Skipping Chocolatey (requires admin rights)" -Color Yellow
            $chocoInstalled = $false
        }
        
        $scoopInstalled = Install-Scoop
        
        if (!$chocoInstalled -and !$scoopInstalled) {
            Write-ColorOutput "[ERROR] No package manager could be installed!" -Color Red
            Write-ColorOutput "Please install Chocolatey or Scoop manually." -Color Yellow
            Stop-Transcript
            exit 1
        }
        
        # Install basic requirements
        if (!(Install-BasicRequirements)) {
            Write-ColorOutput "Failed to install basic requirements. Check the log file: $logFile" -Color Red
            Stop-Transcript
            exit 1
        }
        
        # Initialize Tools directory
        $toolsDir = Initialize-ToolsDirectory
        
        # Start tool installation
        Start-ToolInstallation -ToolsDir $toolsDir
        
        # Final success message
        Show-Section "INSTALLATION COMPLETE"
        Write-ColorOutput @"
[SUCCESS] Installation completed successfully!

Installation log saved to: $logFile
Tools installed to: $toolsDir

To refresh your environment variables, either:
   - Restart your terminal
   - Run: refreshenv (if using cmd/PowerShell)

For tool management, run: .\manage_tools.ps1

Thank you for using J0K34SEC Security Tools Installer!
"@ -Color Green
        
    } catch {
        Write-ColorOutput "An error occurred: $_" -Color Red
        Write-ColorOutput "Check the log file for details: $logFile" -Color Yellow
    } finally {
        Stop-Transcript
    }
}

# Run main function
Main
