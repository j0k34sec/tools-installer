# J0K34SEC All Tools Installer for Windows
# Installs comprehensive security tools suite

param(
    [string]$ToolsDir = "$env:USERPROFILE\Tools"
)

# Set error handling
$ErrorActionPreference = "Continue"

# Function for colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to display section
function Show-Section {
    param([string]$Title)
    Write-ColorOutput "`n[*] $Title" -Color Magenta
    Write-ColorOutput ("-" * 50) -Color Cyan
}

# Function to install Python tool from GitHub
function Install-PythonTool {
    param(
        [string]$RepoUrl,
        [string]$ToolName,
        [string]$Description,
        [string]$CloneDir
    )
    
    Write-ColorOutput "Installing $Description..." -Color Blue
    
    try {
        # Clone repository
        git clone $RepoUrl $CloneDir 2>$null
        
        if (Test-Path $CloneDir) {
            Push-Location $CloneDir
            
            # Create virtual environment
            python -m venv venv 2>$null
            
            # Activate and install requirements
            if (Test-Path "requirements.txt") {
                & ".\venv\Scripts\pip.exe" install -r requirements.txt --quiet 2>$null
            }
            
            # Create batch file for easy execution
            $batchFile = "$ToolsDir\bin\$ToolName.bat"
            $pythonScript = Get-ChildItem -Filter "*.py" | Select-Object -First 1
            
            if ($pythonScript) {
                @"
@echo off
cd /d "$CloneDir"
call venv\Scripts\activate.bat
python $($pythonScript.Name) %*
"@ | Out-File -FilePath $batchFile -Encoding ASCII
                
                Write-ColorOutput "    [OK] Installed successfully" -Color Green
            }
            
            Pop-Location
        }
    } catch {
        Write-ColorOutput "    [ERROR] Failed to install: $_" -Color Red
        return $false
    }
    
    return $true
}

# Function to install Go tool
function Install-GoTool {
    param(
        [string]$Package,
        [string]$ToolName,
        [string]$Description
    )
    
    Write-ColorOutput "Installing $Description..." -Color Blue
    
    try {
        $env:GO111MODULE = "on"
        go install $Package 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            # Create batch wrapper in Tools\bin (no admin required)
            $goPath = "$env:USERPROFILE\go\bin\$ToolName.exe"
            if (Test-Path $goPath) {
                $batchFile = "$ToolsDir\bin\$ToolName.bat"
                if (!(Test-Path $batchFile)) {
                    # Create batch file that calls the Go binary
                    @"
@echo off
"$goPath" %*
"@ | Out-File -FilePath $batchFile -Encoding ASCII
                }
                Write-ColorOutput "    [OK] Installed successfully" -Color Green
                return $true
            }
        }
    } catch {
        Write-ColorOutput "    [ERROR] Failed to install: $_" -Color Red
    }
    
    return $false
}

# Main installation
Show-Section "SECURITY TOOLS INSTALLATION"

# Create necessary directories
$directories = @("$ToolsDir\bin", "$ToolsDir\wordlists", "$ToolsDir\logs")
foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Track installation status
$installed = @()
$failed = @()

# Install Go-based tools
Show-Section "GO-BASED TOOLS"

$goTools = @{
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" = @("subfinder", "Subfinder - Subdomain discovery")
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest" = @("nuclei", "Nuclei - Vulnerability scanner")
    "github.com/projectdiscovery/httpx/cmd/httpx@latest" = @("httpx", "HTTPx - HTTP toolkit")
    "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest" = @("naabu", "Naabu - Port scanner")
    "github.com/ffuf/ffuf/v2@latest" = @("ffuf", "FFUF - Web fuzzer")
    "github.com/tomnomnom/waybackurls@latest" = @("waybackurls", "Waybackurls - URL discovery")
    "github.com/tomnomnom/assetfinder@latest" = @("assetfinder", "Assetfinder - Asset discovery")
    "github.com/lc/gau/v2/cmd/gau@latest" = @("gau", "GAU - Get All URLs")
    "github.com/jaeles-project/gospider@latest" = @("gospider", "GoSpider - Web spider")
}

foreach ($package in $goTools.Keys) {
    $toolInfo = $goTools[$package]
    if (Install-GoTool -Package $package -ToolName $toolInfo[0] -Description $toolInfo[1]) {
        $installed += $toolInfo[0]
    } else {
        $failed += $toolInfo[0]
    }
}

# Install Python-based tools
Show-Section "PYTHON-BASED TOOLS"

$pythonTools = @{
    "sqlmap" = @("https://github.com/sqlmapproject/sqlmap.git", "SQLMap - SQL injection tool")
    "xsstrike" = @("https://github.com/s0md3v/XSStrike.git", "XSStrike - XSS detection")
    "paramspider" = @("https://github.com/devanshbatham/ParamSpider.git", "ParamSpider - Parameter discovery")
}

foreach ($tool in $pythonTools.Keys) {
    $toolInfo = $pythonTools[$tool]
    $cloneDir = "$ToolsDir\$tool"
    
    if (Install-PythonTool -RepoUrl $toolInfo[0] -ToolName $tool -Description $toolInfo[1] -CloneDir $cloneDir) {
        $installed += $tool
    } else {
        $failed += $tool
    }
}

# Install Binary Tools
Show-Section "BINARY TOOLS"

# Function to install binary tool from GitHub releases
function Install-BinaryTool {
    param(
        [string]$RepoUrl,
        [string]$FileName,
        [string]$ToolName,
        [string]$Description
    )
    
    Write-ColorOutput "Installing $Description..." -Color Blue
    
    try {
        $toolDir = "$ToolsDir\$ToolName"
        if (!(Test-Path $toolDir)) {
            New-Item -ItemType Directory -Path $toolDir -Force | Out-Null
        }
        
        $downloadUrl = "$RepoUrl/releases/latest/download/$FileName"
        $zipPath = "$toolDir\$FileName"
        $exePath = "$toolDir\$ToolName.exe"
        
        # Download the release
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -ErrorAction Stop
        
        # Extract if it's a zip file
        if ($FileName.EndsWith(".zip")) {
            Expand-Archive -Path $zipPath -DestinationPath $toolDir -Force
            Remove-Item $zipPath -Force
            
            # Find the exe file in the extracted contents
            $exeFile = Get-ChildItem -Path $toolDir -Filter "*.exe" -Recurse | Select-Object -First 1
            if ($exeFile) {
                Move-Item $exeFile.FullName $exePath -Force
                # Clean up any remaining extraction folders
                Get-ChildItem -Path $toolDir -Directory | Remove-Item -Recurse -Force
            }
        } else {
            # If it's a direct exe, just rename it
            Move-Item $zipPath $exePath -Force
        }
        
        if (Test-Path $exePath) {
            # Create batch wrapper
            $batchFile = "$ToolsDir\bin\$ToolName.bat"
            @"
@echo off
REM $Description batch wrapper - J0K34SEC Tools Installer
REM This allows $ToolName to be called from any directory

"$exePath" %*
"@ | Out-File -FilePath $batchFile -Encoding ASCII
            
            Write-ColorOutput "    [OK] Installed successfully" -Color Green
            return $true
        }
    } catch {
        Write-ColorOutput "    [ERROR] Failed to install: $_" -Color Red
    }
    
    return $false
}

# Install binary tools
$binaryTools = @{
    "feroxbuster" = @("https://github.com/epi052/feroxbuster", "x86_64-windows-feroxbuster.exe.zip", "Feroxbuster - Fast content discovery")
}

foreach ($tool in $binaryTools.Keys) {
    $toolInfo = $binaryTools[$tool]
    if (Install-BinaryTool -RepoUrl $toolInfo[0] -FileName $toolInfo[1] -ToolName $tool -Description $toolInfo[2]) {
        $installed += $tool
    } else {
        $failed += $tool
    }
}

# Install SecLists
Show-Section "WORDLISTS"

Write-ColorOutput "Installing SecLists..." -Color Blue
$seclistsPath = "$ToolsDir\wordlists\SecLists"

if (!(Test-Path $seclistsPath)) {
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git $seclistsPath 2>$null
    if (Test-Path $seclistsPath) {
        Write-ColorOutput "    [OK] SecLists installed" -Color Green
        $installed += "SecLists"
    } else {
        Write-ColorOutput "    [ERROR] Failed to install SecLists" -Color Red
        $failed += "SecLists"
    }
} else {
    Write-ColorOutput "    [OK] SecLists already exists" -Color Green
}

# Final summary
Show-Section "INSTALLATION SUMMARY"

Write-ColorOutput "`nSuccessfully installed: $($installed.Count) tools" -Color Green
if ($installed.Count -gt 0) {
    Write-ColorOutput ($installed -join ", ") -Color White
}

if ($failed.Count -gt 0) {
    Write-ColorOutput "`nFailed to install: $($failed.Count) tools" -Color Red
    Write-ColorOutput ($failed -join ", ") -Color White
    Write-ColorOutput "`n[WARNING] Some tools failed to install. Check the log for details." -Color Yellow
}

Write-ColorOutput @"

Next steps:
1. Restart your terminal to refresh PATH
2. Run '.\manage_tools.ps1 list' to verify installations
3. Configure individual tools as needed

For tool documentation, visit:
- https://github.com/projectdiscovery
- https://github.com/sqlmapproject/sqlmap
- https://github.com/danielmiessler/SecLists

"@ -Color Cyan

Write-ColorOutput "[SUCCESS] Installation process completed!" -Color Green
