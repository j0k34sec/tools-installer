# J0K34SEC Tools Management Script for Windows
param(
    [string]$Action = "help"
)

$ToolsDir = "$env:USERPROFILE\Tools"
$GoToolsDir = "$env:USERPROFILE\go\bin"

# Function for colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput @"
J0K34SEC Security Tools Manager - Windows Edition

USAGE:
    .\manage_tools_clean.ps1 <command>

COMMANDS:
    list        List all installed tools
    test        Test installed tools
    path        Show and manage PATH configuration
    clean       Clean up installation files
    help        Show this help message

EXAMPLES:
    .\manage_tools_clean.ps1 list
    .\manage_tools_clean.ps1 test
    .\manage_tools_clean.ps1 path
"@ -Color Cyan
}

function Show-InstalledTools {
    Write-ColorOutput "=== INSTALLED SECURITY TOOLS ===" -Color Magenta
    Write-ColorOutput ""
    
    # Check Go tools
    Write-ColorOutput "[*] Go-based Tools:" -Color Cyan
    if (Test-Path $GoToolsDir) {
        $goTools = Get-ChildItem $GoToolsDir -Filter "*.exe" | Select-Object Name
        if ($goTools.Count -gt 0) {
            foreach ($tool in $goTools) {
                $toolName = $tool.Name -replace "\.exe$", ""
                $batchFile = "$ToolsDir\bin\$toolName.bat"
                $status = if (Test-Path $batchFile) { "[OK]" } else { "[NO WRAPPER]" }
                $color = if ($status -eq "[OK]") { "Green" } else { "Yellow" }
                Write-ColorOutput "  $status $toolName" -Color $color
            }
        } else {
            Write-ColorOutput "  No Go tools found" -Color Gray
        }
    } else {
        Write-ColorOutput "  Go tools directory not found" -Color Red
    }
    
    Write-ColorOutput ""
    
    # Check Binary tools
    Write-ColorOutput "[*] Binary Tools:" -Color Cyan
    $binaryTools = @("feroxbuster")
    $foundBinary = $false
    
    foreach ($tool in $binaryTools) {
        $toolDir = "$ToolsDir\$tool"
        $batchFile = "$ToolsDir\bin\$tool.bat"
        
        if (Test-Path $toolDir) {
            $foundBinary = $true
            $status = if (Test-Path $batchFile) { "[OK]" } else { "[NO WRAPPER]" }
            $color = if ($status -eq "[OK]") { "Green" } else { "Yellow" }
            Write-ColorOutput "  $status $tool" -Color $color
        }
    }
    
    if (!$foundBinary) {
        Write-ColorOutput "  No binary tools found" -Color Gray
    }
    
    Write-ColorOutput ""
    
    # Check Python tools
    Write-ColorOutput "[*] Python-based Tools:" -Color Cyan
    $pythonTools = @("sqlmap", "xsstrike", "paramspider", "ghauri")
    $foundPython = $false
    
    foreach ($tool in $pythonTools) {
        $toolDir = "$ToolsDir\$tool"
        $batchFile = "$ToolsDir\bin\$tool.bat"
        
        if (Test-Path $toolDir) {
            $foundPython = $true
            $status = if (Test-Path $batchFile) { "[OK]" } else { "[NO WRAPPER]" }
            $color = if ($status -eq "[OK]") { "Green" } else { "Yellow" }
            Write-ColorOutput "  $status $tool" -Color $color
        }
    }
    
    if (!$foundPython) {
        Write-ColorOutput "  No Python tools found" -Color Gray
    }
    
    Write-ColorOutput ""
    
    # Check Wordlists
    Write-ColorOutput "[*] Wordlists:" -Color Cyan
    $seclistsPath = "$ToolsDir\wordlists\SecLists"
    if (Test-Path $seclistsPath) {
        Write-ColorOutput "  [OK] SecLists" -Color Green
    } else {
        Write-ColorOutput "  SecLists not found" -Color Gray
    }
    
    Write-ColorOutput ""
}

function Test-Tools {
    Write-ColorOutput "=== TESTING INSTALLED TOOLS ===" -Color Magenta
    Write-ColorOutput ""
    
    # Test batch wrappers
    if (Test-Path "$ToolsDir\bin") {
        $wrappers = Get-ChildItem "$ToolsDir\bin" -Filter "*.bat"
        
        if ($wrappers.Count -gt 0) {
            Write-ColorOutput "Testing tool wrappers:" -Color Cyan
            
            foreach ($wrapper in $wrappers) {
                $toolName = $wrapper.BaseName
                Write-Host "  Testing $toolName... " -NoNewline
                
                try {
                    $result = & $wrapper.FullName --help 2>$null
                    if ($LASTEXITCODE -eq 0 -or $result) {
                        Write-ColorOutput "[OK]" -Color Green
                    } else {
                        Write-ColorOutput "[FAILED]" -Color Red
                    }
                } catch {
                    Write-ColorOutput "[ERROR]" -Color Red
                }
            }
        } else {
            Write-ColorOutput "No tool wrappers found in $ToolsDir\bin" -Color Yellow
        }
    } else {
        Write-ColorOutput "Tools bin directory not found" -Color Red
    }
    
    Write-ColorOutput ""
}

function Show-PathInfo {
    Write-ColorOutput "=== PATH CONFIGURATION ===" -Color Magenta
    Write-ColorOutput ""
    
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $toolsBin = "$ToolsDir\bin"
    $goBin = "$env:USERPROFILE\go\bin"
    
    Write-ColorOutput "Tools bin directory: $toolsBin" -Color Cyan
    Write-ColorOutput "Go bin directory: $goBin" -Color Cyan
    Write-ColorOutput ""
    
    # Check if directories are in PATH
    Write-ColorOutput "PATH Status:" -Color Cyan
    
    $inUserPath = $userPath -like "*$toolsBin*"
    $inCurrentPath = $env:Path -like "*$toolsBin*"
    
    $userPathStatus = if ($inUserPath) { '[YES]' } else { '[NO]' }
    $userPathColor = if ($inUserPath) { "Green" } else { "Red" }
    Write-ColorOutput "  Tools\bin in User PATH: $userPathStatus" -Color $userPathColor
    
    $currentPathStatus = if ($inCurrentPath) { '[YES]' } else { '[NO]' }
    $currentPathColor = if ($inCurrentPath) { "Green" } else { "Red" }
    Write-ColorOutput "  Tools\bin in Current PATH: $currentPathStatus" -Color $currentPathColor
    
    $goInPath = $env:Path -like "*$goBin*"
    $goPathStatus = if ($goInPath) { '[YES]' } else { '[NO]' }
    $goPathColor = if ($goInPath) { "Green" } else { "Red" }
    Write-ColorOutput "  Go\bin in PATH: $goPathStatus" -Color $goPathColor
    
    Write-ColorOutput ""
    
    if (!$inCurrentPath) {
        Write-ColorOutput "To add Tools\bin to current session PATH, run:" -Color Yellow
        Write-ColorOutput "  `$env:Path += ';$toolsBin'" -Color White
    }
    
    if (!$inUserPath) {
        Write-ColorOutput "To permanently add Tools\bin to PATH, run:" -Color Yellow
        Write-ColorOutput "  [System.Environment]::SetEnvironmentVariable('Path', `$env:Path + ';$toolsBin', 'User')" -Color White
    }
}

function Clean-Installation {
    Write-ColorOutput "=== CLEANING INSTALLATION FILES ===" -Color Magenta
    Write-ColorOutput ""
    
    # Clean up log files
    $logsDir = "$ToolsDir\logs"
    if (Test-Path $logsDir) {
        $logFiles = Get-ChildItem $logsDir -Filter "*.txt"
        if ($logFiles.Count -gt 0) {
            Write-ColorOutput "Found $($logFiles.Count) log files" -Color Cyan
            $response = Read-Host "Delete old log files? (y/n)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                Remove-Item "$logsDir\*.txt" -Force
                Write-ColorOutput "[OK] Log files cleaned" -Color Green
            }
        } else {
            Write-ColorOutput "No log files to clean" -Color Gray
        }
    }
    
    # Check for broken batch wrappers
    if (Test-Path "$ToolsDir\bin") {
        $wrappers = Get-ChildItem "$ToolsDir\bin" -Filter "*.bat"
        $brokenWrappers = @()
        
        foreach ($wrapper in $wrappers) {
            $content = Get-Content $wrapper.FullName -Raw
            # Extract the path from the batch file
            if ($content -match '"([^"]*\.exe)"') {
                $targetPath = $matches[1]
                if (!(Test-Path $targetPath)) {
                    $brokenWrappers += $wrapper
                }
            }
        }
        
        if ($brokenWrappers.Count -gt 0) {
            Write-ColorOutput "Found $($brokenWrappers.Count) broken wrapper(s)" -Color Yellow
            foreach ($wrapper in $brokenWrappers) {
                Write-ColorOutput "  $($wrapper.Name)" -Color Gray
            }
            
            $response = Read-Host "Remove broken wrappers? (y/n)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                foreach ($wrapper in $brokenWrappers) {
                    Remove-Item $wrapper.FullName -Force
                    Write-ColorOutput "[OK] Removed $($wrapper.Name)" -Color Green
                }
            }
        } else {
            Write-ColorOutput "No broken wrappers found" -Color Green
        }
    }
    
    Write-ColorOutput ""
}

# Main execution
switch ($Action.ToLower()) {
    "list" { Show-InstalledTools }
    "test" { Test-Tools }
    "path" { Show-PathInfo }
    "clean" { Clean-Installation }
    "help" { Show-Help }
    default { 
        Write-ColorOutput "Unknown command: $Action" -Color Red
        Write-ColorOutput ""
        Show-Help
    }
}
