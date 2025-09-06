# Go-based Security Tools Installer for Windows
# Version: 1.0.0

param(
    [Parameter(Mandatory=$true)]
    [string]$ToolsDir
)

# Import color output function
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

# Function to show progress
function Show-InstallProgress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$ToolName
    )
    
    $percentComplete = ($Current / $Total) * 100
    Write-Progress -Activity "Installing Go Tools" -Status "Installing $ToolName" -PercentComplete $percentComplete
}

# Function to install a Go tool
function Install-GoTool {
    param(
        [string]$Package,
        [string]$Name,
        [string]$Description
    )
    
    Write-ColorOutput "  Installing $Name" -Color Yellow -NoNewline
    Write-ColorOutput " - $Description" -Color White -NoNewline
    
    try {
        $output = go install $Package 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput " ✓" -Color Green
            return $true
        } else {
            Write-ColorOutput " ✗" -Color Red
            Write-ColorOutput "    Error: $output" -Color Red
            return $false
        }
    } catch {
        Write-ColorOutput " ✗" -Color Red
        Write-ColorOutput "    Error: $_" -Color Red
        return $false
    }
}

# Main installation function
function Install-GoTools {
    Write-ColorOutput "`n◉ INSTALLING GO-BASED SECURITY TOOLS" -Color Magenta
    Write-ColorOutput ("─" * 50) -Color Cyan
    
    # Check if Go is installed
    if (!(Get-Command go -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "`n✗ Go is not installed!" -Color Red
        Write-ColorOutput "Please install Go first: https://go.dev/doc/install" -Color Yellow
        return $false
    }
    
    # Get Go version
    $goVersion = go version
    Write-ColorOutput "`n✓ Go is installed: $goVersion" -Color Green
    
    # Set GOPATH if not set
    if (!$env:GOPATH) {
        $env:GOPATH = "$env:USERPROFILE\go"
        [System.Environment]::SetEnvironmentVariable("GOPATH", $env:GOPATH, "User")
        Write-ColorOutput "✓ GOPATH set to: $env:GOPATH" -Color Green
    }
    
    # Add Go bin to PATH if not already there
    $goBin = "$env:GOPATH\bin"
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$goBin*") {
        [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$goBin", "User")
        $env:Path += ";$goBin"
        Write-ColorOutput "✓ Added $goBin to PATH" -Color Green
    }
    
    Write-ColorOutput "`nInstalling tools..." -Color Blue
    
    # Define Go tools to install
    $tools = @(
        @{
            Package = "github.com/ffuf/ffuf/v2@latest"
            Name = "FFUF"
            Description = "Fast web fuzzer"
        },
        @{
            Package = "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
            Name = "Subfinder"
            Description = "Subdomain discovery tool"
        },
        @{
            Package = "github.com/projectdiscovery/httpx/cmd/httpx@latest"
            Name = "Httpx"
            Description = "HTTP toolkit"
        },
        @{
            Package = "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
            Name = "Nuclei"
            Description = "Vulnerability scanner"
        },
        @{
            Package = "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
            Name = "Naabu"
            Description = "Port scanner"
        },
        @{
            Package = "github.com/tomnomnom/assetfinder@latest"
            Name = "Assetfinder"
            Description = "Find domains and subdomains"
        },
        @{
            Package = "github.com/tomnomnom/waybackurls@latest"
            Name = "Waybackurls"
            Description = "Fetch URLs from Wayback Machine"
        },
        @{
            Package = "github.com/tomnomnom/anew@latest"
            Name = "Anew"
            Description = "Append lines to file if unique"
        },
        @{
            Package = "github.com/tomnomnom/gf@latest"
            Name = "GF"
            Description = "Grep-friendly patterns"
        },
        @{
            Package = "github.com/tomnomnom/qsreplace@latest"
            Name = "Qsreplace"
            Description = "Query string replacer"
        },
        @{
            Package = "github.com/lc/gau/v2/cmd/gau@latest"
            Name = "GAU"
            Description = "Get All URLs"
        },
        @{
            Package = "github.com/jaeles-project/gospider@latest"
            Name = "GoSpider"
            Description = "Fast web spider"
        },
        @{
            Package = "github.com/hakluke/hakrawler@latest"
            Name = "Hakrawler"
            Description = "Web crawler for gathering URLs"
        },
        @{
            Package = "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
            Name = "DNSX"
            Description = "DNS toolkit"
        },
        @{
            Package = "github.com/projectdiscovery/katana/cmd/katana@latest"
            Name = "Katana"
            Description = "Next-generation crawling framework"
        },
        @{
            Package = "github.com/projectdiscovery/uncover/cmd/uncover@latest"
            Name = "Uncover"
            Description = "API wrapper for search engines"
        },
        @{
            Package = "github.com/projectdiscovery/notify/cmd/notify@latest"
            Name = "Notify"
            Description = "Stream output to multiple platforms"
        },
        @{
            Package = "github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
            Name = "Mapcidr"
            Description = "CIDR range processor"
        },
        @{
            Package = "github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
            Name = "Asnmap"
            Description = "ASN to CIDR mapping"
        },
        @{
            Package = "github.com/projectdiscovery/chaos-client/cmd/chaos@latest"
            Name = "Chaos"
            Description = "Chaos dataset client"
        },
        @{
            Package = "github.com/trufflesecurity/trufflehog/v3@latest"
            Name = "Trufflehog"
            Description = "Secret scanner"
        },
        @{
            Package = "github.com/gitleaks/gitleaks/v8@latest"
            Name = "Gitleaks"
            Description = "SAST tool for detecting secrets"
        }
    )
    
    $totalTools = $tools.Count
    $currentTool = 0
    $successCount = 0
    $failedTools = @()
    
    foreach ($tool in $tools) {
        $currentTool++
        Show-InstallProgress -Current $currentTool -Total $totalTools -ToolName $tool.Name
        
        if (Install-GoTool -Package $tool.Package -Name $tool.Name -Description $tool.Description) {
            $successCount++
        } else {
            $failedTools += $tool.Name
        }
    }
    
    Write-Progress -Activity "Installing Go Tools" -Completed
    
    # Configure GAU
    Write-ColorOutput "`nConfiguring GAU..." -Color Blue
    $gauConfig = "$env:USERPROFILE\.config\gau"
    if (!(Test-Path $gauConfig)) {
        New-Item -ItemType Directory -Path $gauConfig -Force | Out-Null
    }
    
    $gauTomlPath = "$PSScriptRoot\..\..\config\gau.toml"
    if (Test-Path $gauTomlPath) {
        Copy-Item -Path $gauTomlPath -Destination "$gauConfig\gau.toml" -Force
        Write-ColorOutput "✓ GAU configuration copied" -Color Green
    }
    
    # Download Nuclei templates
    Write-ColorOutput "`nDownloading Nuclei templates..." -Color Blue
    try {
        nuclei -update-templates 2>$null
        Write-ColorOutput "✓ Nuclei templates downloaded" -Color Green
    } catch {
        Write-ColorOutput "⚠ Failed to download Nuclei templates. Run 'nuclei -update-templates' manually" -Color Yellow
    }
    
    # Summary
    Write-ColorOutput "`n" + ("=" * 50) -Color Cyan
    Write-ColorOutput "Installation Summary:" -Color Yellow
    Write-ColorOutput "  Successfully installed: $successCount/$totalTools tools" -Color White
    
    if ($failedTools.Count -gt 0) {
        Write-ColorOutput "  Failed to install: $($failedTools -join ', ')" -Color Red
        Write-ColorOutput "`n  To retry failed installations, run:" -Color Yellow
        foreach ($failed in $failedTools) {
            $tool = $tools | Where-Object { $_.Name -eq $failed }
            Write-ColorOutput "    go install $($tool.Package)" -Color White
        }
    }
    
    Write-ColorOutput "`n✓ Go tools installation complete!" -Color Green
    Write-ColorOutput "Tools are installed in: $env:GOPATH\bin" -Color Blue
    
    return $true
}

# Run installation
Install-GoTools
