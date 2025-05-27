#!/bin/bash

# Define log file and colors
LOG_FILE="$HOME/Tools/go_tools_install.log"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Function to print a fancy banner
print_banner() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo '     ____ ___    ___________  ____  __    _____   '
    echo '    / __ \__ \  / ____/ __ \/ __ \/ /   / ___/   '
    echo '   / / / /_/ / / /   / / / / / / / /    \__ \    '
    echo '  / /_/ / __/ / /___/ /_/ / /_/ / /___ ___/ /    '
    echo ' /_____/____/\____/\____/\____/_____//____/     '
    echo '   ____ _   _________________ __    __    ___    '
    echo '  / __ \ | / / ___/_  __/   |/ /   / /   /   |   '
    echo ' / / / / |/ /\__ \ / / / /| / /   / /   / /| |   '
    echo '/ /_/ / /| /___/ // / / ___ / /___/ /___/ ___ |  '
    echo '\____/_/ |_/____//_/ /_/  |_\____/_____/_/  |_|  '
    echo -e "${RESET}\n"
    echo -e "${BOLD}${YELLOW}       J0K34SEC Security Tools Installer${RESET}\n"
    echo -e "${CYAN}====================================================="
    echo -e "${RESET}"
    # Wait a bit to let user appreciate the banner
    sleep 1
}

# Function for spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\\'
    local message="$2"
    local width=50
    local i=0
    
    # Calculate padding to center the message
    local padding=$((width - ${#message}))
    local pad_left=$((padding / 2))
    local pad_right=$((padding - pad_left))
    
    # Create padding strings
    local pad_left_str=$(printf "%${pad_left}s" "")
    local pad_right_str=$(printf "%${pad_right}s" "")
    
    tput civis  # Hide cursor
    
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " ${CYAN}${BOLD}[%c]${RESET} ${BOLD}%s%s%s${RESET}\r" "$spinstr" "$pad_left_str" "$message" "$pad_right_str"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        i=$((i + 1))
    done
    
    printf "   ${GREEN}${BOLD}[✓]${RESET} ${BOLD}%s%s%s${RESET}\n" "$pad_left_str" "$message" "$pad_right_str"
    tput cnorm  # Show cursor
}

# Function to show progress bar
show_progress() {
    local current=$1
    local total=$2
    local message="$3"
    local width=50
    local bar_size=30
    
    # Calculate percentage and number of filled/empty blocks
    local percent=$((current * 100 / total))
    local filled=$((current * bar_size / total))
    local empty=$((bar_size - filled))
    
    # Create the bar
    local bar=""
    for ((i=0; i<filled; i++)); do
        bar="${bar}█"
    done
    for ((i=0; i<empty; i++)); do
        bar="${bar}░"
    done
    
    # Print the progress bar
    printf "${CYAN}[${GREEN}%-${bar_size}s${CYAN}]${RESET} ${BOLD}%3d%%${RESET} %s\r" "$bar" "$percent" "$message"
    
    # Print newline if completed
    if [ "$current" -eq "$total" ]; then
        echo -e "\n${GREEN}${BOLD}[✓] Completed: ${message}${RESET}\n"
    fi
}

# Function to display a completion animation
show_completion() {
    local message="$1"
    local width=50
    
    echo -e "\n${CYAN}=${RESET}${BOLD}${YELLOW}=${RESET}${CYAN}=${RESET} ${BOLD}$message${RESET} ${CYAN}=${RESET}${BOLD}${YELLOW}=${RESET}${CYAN}=${RESET}"
    
    # Animation frames
    local frames=("🔄" "🔃" "🔂" "🔁" "✅")
    
    # Show animation
    for frame in "${frames[@]}"; do
        printf "\r  ${BOLD}${GREEN}%s${RESET} ${message}..." "$frame"
        sleep 0.3
    done
    
    echo -e "\n${GREEN}${BOLD}[✓] $message COMPLETE!${RESET}\n"
    echo -e "${CYAN}=====================================================\n${RESET}"
}

# Create or clear log file
> "$LOG_FILE"

# Function to log messages with enhanced visuals
log_message() {
    local message="$1"
    local type="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Save to log file without formatting
    echo "[$timestamp] [$type] $message" >> "$LOG_FILE"
    
    # Display formatted message on screen
    case "$type" in
        "error")
            echo -e "${BOLD}${RED}[✗] ERROR:${RESET} $message"
            ;;
        "warning")
            echo -e "${BOLD}${YELLOW}[!] WARNING:${RESET} $message"
            ;;
        "success")
            echo -e "${BOLD}${GREEN}[✓] SUCCESS:${RESET} $message"
            ;;
        "info")
            echo -e "${BOLD}${BLUE}[ℹ] INFO:${RESET} $message"
            ;;
        "step")
            echo -e "\n${CYAN}➤ ${BOLD}$message${RESET}"
            echo -e "${CYAN}$(printf '%.0s-' {1..50})${RESET}"
            ;;
        *)
            echo -e "$message"
            ;;
    esac
}

# Function to check if command exists
check_command() {
    local cmd="$1"
    if command -v "$cmd" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to run command with error handling and animation
run_command() {
    local cmd="$1"
    local error_msg="$2"
    local success_msg="$3"
    local show_spinner="${4:-true}"
    
    if [ "$show_spinner" = true ]; then
        # Run command in background and show spinner
        eval "$cmd" > /dev/null 2>> "$LOG_FILE" & 
        local cmd_pid=$!
        spinner $cmd_pid "${success_msg}..."
        wait $cmd_pid
        local status=$?
    else
        # Run command normally
        eval "$cmd"
        local status=$?
    fi
    
    if [ $status -eq 0 ]; then
        if [ -n "$success_msg" ] && [ "$show_spinner" != true ]; then
            log_message "$success_msg" "success"
        fi
        return 0
    else
        if [ -n "$error_msg" ]; then
            log_message "$error_msg" "error"
        fi
        return 1
    fi
}

install_go_tools() {
    # Show fancy banner
    print_banner
    
    log_message "Starting Go tools installation" "step"
    
    # Detect OS type for package installation
    detect_os() {
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" = "arch" ] || [ "$ID" = "manjaro" ] || [ "$ID" = "endeavouros" ]; then
                echo "arch"
            elif [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ] || [ "$ID" = "kali" ]; then
                echo "debian"
            else
                echo "unknown"
            fi
        else
            echo "unknown"
        fi
    }
    
    # Install dependencies based on OS
    install_dependency() {
        local package_name=$1
        local arch_package=$2
        local debian_package=$3
        
        local os_type=$(detect_os)
        
        log_message "Installing dependency: $package_name" "info"
        
        if [ "$os_type" = "arch" ]; then
            run_command "sudo pacman -S --noconfirm --needed $arch_package" \
                "Failed to install $package_name ($arch_package) on Arch Linux" \
                "Successfully installed $package_name on Arch Linux"
        elif [ "$os_type" = "debian" ]; then
            run_command "sudo apt-get update -y" \
                "Failed to update package lists on Debian/Ubuntu" \
                "Package lists updated successfully"
                
            run_command "sudo apt-get install -y $debian_package" \
                "Failed to install $package_name ($debian_package) on Debian/Ubuntu" \
                "Successfully installed $package_name on Debian/Ubuntu"
        else
            log_message "Unsupported OS. Please install $package_name manually." "error"
            return 1
        fi
        
        return $?
    }
    
    # Function to install a Go tool if not already installed
    install_tool_if_needed() {
        local tool_name=$1
        local install_command=$2
        
        if ! check_command "$tool_name"; then
            log_message "Installing $tool_name..." "info"
            
            # Check if Go is installed first
            if ! check_command "go"; then
                log_message "Go is not installed. Cannot install Go tools." "error"
                log_message "Please install Go first: https://go.dev/doc/install" "warning"
                return 1
            fi
            
            # Install any required dependencies for tools that need them
            case "$tool_name" in
                "naabu")
                    log_message "Installing dependencies for naabu..." "info"
                    install_dependency "libpcap" "libpcap" "libpcap-dev"
                    ;;
                "subfinder")
                    # No special dependencies
                    ;;
                "httpx")
                    # No special dependencies
                    ;;
                *)
                    # No special dependencies for other tools
                    ;;
            esac
            
            # Try to install the tool
            if run_command "$install_command" \
                "Failed to install $tool_name" \
                "$tool_name installed successfully"; then
                
                # Verify installation
                if check_command "$tool_name"; then
                    log_message "Verified $tool_name is working correctly" "success"
                    return 0
                else
                    log_message "$tool_name was installed but cannot be found in PATH" "warning"
                    log_message "This might be fixed after running the fix_current_session function" "info"
                    return 1
                fi
            else
                return 1
            fi
        else
            log_message "$tool_name is already installed" "success"
            return 0
        fi
    }

    # Check Go installation first
    if ! check_command "go"; then
        log_message "Go is not installed. Cannot install Go tools." "error"
        log_message "Please install Go first: https://go.dev/doc/install" "warning"
        return 1
    else
        # Log Go version
        GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        log_message "Found Go version: $GO_VERSION" "info"
        
        # Make sure GOPATH is set and in PATH
        if [ -z "$GOPATH" ]; then
            export GOPATH="$HOME/go"
            log_message "GOPATH not set, defaulting to $GOPATH" "info"
        fi
        
        # Make sure go/bin is in PATH for this session
        export PATH="$PATH:$GOPATH/bin"
        log_message "Added $GOPATH/bin to PATH for current session" "info"
    fi
    
    # Track installation success and failures
    TOTAL_TOOLS=17  # Total number of tools to install
    SUCCESSFUL_INSTALLS=0
    FAILED_INSTALLS=0
    CURRENT_TOOL=0
    
    # Show initial progress bar
    echo -e "\n${BOLD}${CYAN}Installation Progress:${RESET}"
    show_progress 0 $TOTAL_TOOLS "Preparing to install tools"
    
    # Install tools with tracking and progress bar
    install_and_track() {
        CURRENT_TOOL=$((CURRENT_TOOL+1))
        local tool_name=$1
        local install_command=$2
        
        # Show progress bar
        show_progress $CURRENT_TOOL $TOTAL_TOOLS "Installing $tool_name"
        
        if install_tool_if_needed "$tool_name" "$install_command"; then
            SUCCESSFUL_INSTALLS=$((SUCCESSFUL_INSTALLS+1))
        else
            FAILED_INSTALLS=$((FAILED_INSTALLS+1))
            log_message "Failed to install $tool_name" "error"
        fi
        
        # Small delay to make progress visible
        sleep 0.2
    }
    
    # Install tools
    log_message "Starting installation of Go security tools..." "step"
    
    install_and_track "subfinder" "GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    install_and_track "nuclei" "GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
    install_and_track "httpx" "GO111MODULE=on go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
    install_and_track "dalfox" "GO111MODULE=on go install github.com/hahwul/dalfox/v2@latest"
    install_and_track "waybackurls" "go install github.com/tomnomnom/waybackurls@latest"
    # Install assetfinder - a tool to find domains and subdomains related to a given domain
    log_message "Installing assetfinder (asset discovery tool)..." "step"
    install_and_track "assetfinder" "go install -v github.com/tomnomnom/assetfinder@latest"
    # Install gau - Get All URLs from web archives
    log_message "Installing gau (URL discovery tool)..." "step"
    install_and_track "gau" "GO111MODULE=on go install -v github.com/lc/gau/v2/cmd/gau@latest"
    
    # Copy gau configuration file to user's home directory if it exists
    if [ -f "$TARGET/config/gau.toml" ]; then
        log_message "Copying gau configuration file to home directory..." "info"
        cp "$TARGET/config/gau.toml" "$HOME/.gau.toml" 2>/dev/null
        if [ $? -eq 0 ]; then
            log_message "gau configuration file copied successfully" "success"
        else
            log_message "Failed to copy gau configuration file" "warning"
        fi
    else
        log_message "No gau configuration file found in $TARGET/config/" "warning"
        
        # Create a basic configuration file
        log_message "Creating basic gau configuration file..." "info"
        cat > "$HOME/.gau.toml" << 'EOF'
# Default configuration file for gau

# Providers to use (wayback, commoncrawl, otx, urlscan)
providers = ["wayback", "commoncrawl", "otx", "urlscan"]

# Maximum number of URLs to fetch
maxurls = 0

# Include subdomains
includeSubs = false

# Number of threads to use
threads = 10

# Blacklist extensions
blacklist = [
  "jpg",
  "jpeg",
  "gif",
  "css",
  "tif",
  "tiff",
  "png",
  "ttf",
  "woff",
  "woff2",
  "ico",
  "svg"
]

# JSON output format
json = false

# Proxy URL
proxy = ""

# Retries for HTTP client
retries = 5

# HTTP timeout in seconds
timeout = 15

# Randomize user agent
useragent = true
EOF
        if [ $? -eq 0 ]; then
            log_message "Basic gau configuration file created successfully" "success"
        else
            log_message "Failed to create gau configuration file" "warning"
        fi
    fi
    install_and_track "gf" "go install github.com/tomnomnom/gf@latest"
    install_and_track "dnsx" "GO111MODULE=on go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    install_and_track "naabu" "GO111MODULE=on go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    install_and_track "kxss" "go install github.com/Emoe/kxss@latest"
    install_and_track "katana" "GO111MODULE=on go install github.com/projectdiscovery/katana/cmd/katana@latest"
    log_message "Installing mantra (Kubernetes security tool)..." "step"
    install_and_track "mantra" "GO111MODULE=on go install -v github.com/Brosck/mantra@latest"
    install_and_track "subjs" "GO111MODULE=on go install -v github.com/lc/subjs@latest"
    
    # Install gospider - a fast web spider written in Go
    log_message "Installing gospider (web crawling and spidering tool)..." "step"
    install_and_track "gospider" "GO111MODULE=on go install -v github.com/jaeles-project/gospider@latest"
    
    # Install interactsh-client - a tool for detecting out-of-band interactions
    log_message "Installing interactsh-client (OOB interaction detection tool)..." "step"
    install_and_track "interactsh-client" "GO111MODULE=on go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
    
    # Install qsreplace - a tool for replacing query string values
    log_message "Installing qsreplace (query string replacement tool)..." "step"
    install_and_track "qsreplace" "go install -v github.com/tomnomnom/qsreplace@latest"
    
    # Show final progress bar
    show_progress $TOTAL_TOOLS $TOTAL_TOOLS "All tools processed"
    
    # Log summary with visual enhancement
    echo -e "\n${CYAN}=====================================================\n${RESET}"
    echo -e "${BOLD}${CYAN}Installation Summary:${RESET}\n"
    echo -e "${GREEN}✅ Successfully installed: ${BOLD}$SUCCESSFUL_INSTALLS${RESET} tools"
    echo -e "${RED}❌ Failed to install: ${BOLD}$FAILED_INSTALLS${RESET} tools"
    echo -e "${BLUE}🔢 Total tools processed: ${BOLD}$TOTAL_TOOLS${RESET}\n"
    
    # Visual success indicator
    if [ $FAILED_INSTALLS -eq 0 ]; then
        echo -e "${GREEN}${BOLD}🎉 ALL TOOLS INSTALLED SUCCESSFULLY! 🎉${RESET}"
    elif [ $SUCCESSFUL_INSTALLS -gt 0 ]; then
        echo -e "${YELLOW}${BOLD}⚠️  SOME TOOLS INSTALLED WITH WARNINGS ⚠️${RESET}"
    else
        echo -e "${RED}${BOLD}❌ INSTALLATION FAILED FOR ALL TOOLS ❌${RESET}"
    fi
    
    echo -e "${CYAN}=====================================================\n${RESET}"

    #calling copy tools in bin
    # Show animation for copying tools
    echo -e "\n"
    show_completion "Finalizing installation"
    copy_tools_bin
    
    # Final completion animation
    sleep 0.5
    echo -e "\n${BOLD}${GREEN}🚀 GO TOOLS SETUP COMPLETE 🚀${RESET}\n"
}

#function to copy files into bin file
copy_tools_bin() {
    log_message "Copying Go tools to system directories..." "info"
    
    # Define source and destination directories
    SOURCE_DIR="$HOME/go/bin"
    DEST_DIR="/usr/local/bin"

    # Check if the source directory exists
    if [ -d "$SOURCE_DIR" ]; then
        log_message "Source directory $SOURCE_DIR exists" "success"

        # Check if there are files to copy
        if [ -n "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]; then
            # Copy all files from source to destination
            log_message "Copying all Go tools from $SOURCE_DIR to $DEST_DIR..." "info"
            
            # Check if we have sudo access
            if ! sudo -v &>/dev/null; then
                log_message "This script requires sudo privileges to copy tools to $DEST_DIR" "error"
                log_message "Without sudo, tools will only be available in your local Go bin directory" "warning"
                log_message "You can manually copy files later with: sudo cp $SOURCE_DIR/* $DEST_DIR/" "info"
                return 1
            fi
            
            # Make sure destination directory exists
            if [ ! -d "$DEST_DIR" ]; then
                run_command "sudo mkdir -p $DEST_DIR" \
                    "Failed to create destination directory $DEST_DIR" \
                    "Created destination directory $DEST_DIR"
            fi
            
            # Copy files
            if run_command "sudo cp $SOURCE_DIR/* $DEST_DIR/ 2>/dev/null" \
                "Error copying files. Some tools might not be available" \
                "Files copied successfully"; then
                
                # Set proper permissions
                run_command "sudo chmod +x $DEST_DIR/*" \
                    "Failed to set executable permissions" \
                    "Permissions set correctly"
            fi
        else
            log_message "No files found in $SOURCE_DIR. Go tools might not have been installed properly" "error"
            return 1
        fi
    else
        log_message "Source directory $SOURCE_DIR does not exist" "warning"
        
        # Try to find Go binaries in alternative locations
        ALT_SOURCE_DIR="$(go env GOPATH 2>/dev/null)/bin"
        if [ -d "$ALT_SOURCE_DIR" ] && [ -n "$(ls -A "$ALT_SOURCE_DIR" 2>/dev/null)" ]; then
            log_message "Found alternative Go binaries directory at $ALT_SOURCE_DIR" "success"
            
            # Check if we have sudo access
            if ! sudo -v &>/dev/null; then
                log_message "This script requires sudo privileges to copy tools to $DEST_DIR" "error"
                log_message "Without sudo, tools will only be available in your local Go bin directory" "warning"
                log_message "You can manually copy files later with: sudo cp $ALT_SOURCE_DIR/* $DEST_DIR/" "info"
                return 1
            fi
            
            # Copy files from alternative location
            if run_command "sudo cp $ALT_SOURCE_DIR/* $DEST_DIR/ 2>/dev/null" \
                "Error copying files from alternative location. Some tools might not be available" \
                "Files copied from alternative location successfully"; then
                
                # Set proper permissions
                run_command "sudo chmod +x $DEST_DIR/*" \
                    "Failed to set executable permissions" \
                    "Permissions set correctly"
            fi
        else
            log_message "No Go binaries found in any location. Installation may have failed" "error"
            return 1
        fi
    fi
    
    # Add Go bin directory to PATH in shell configuration files
    update_path
    
    return 0
}

# Function to update PATH in shell configuration files
update_path() {
    # Determine which shell the user is using
    CURRENT_SHELL=$(basename "$SHELL" 2>/dev/null || echo "bash")
    GO_PATH_LINE='export PATH="$PATH:$HOME/go/bin"'
    
    log_message "Updating PATH in shell configuration files..." "info"
    
    # Track changes made
    local changes_made=0
    
    # Update .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "export PATH=.*\$HOME/go/bin" "$HOME/.bashrc" 2>/dev/null; then
            if run_command "echo '' >> '$HOME/.bashrc' && \
                         echo '# Go binaries path' >> '$HOME/.bashrc' && \
                         echo '$GO_PATH_LINE' >> '$HOME/.bashrc'" \
                "Failed to update .bashrc" \
                "Updated .bashrc with Go path"; then
                changes_made=1
            fi
        else
            log_message "PATH already configured in .bashrc" "success"
        fi
    else
        log_message ".bashrc not found, creating it" "warning"
        run_command "touch $HOME/.bashrc && \
                   echo '# Go binaries path' >> '$HOME/.bashrc' && \
                   echo '$GO_PATH_LINE' >> '$HOME/.bashrc'" \
            "Failed to create .bashrc" \
            "Created .bashrc with Go path"
        changes_made=1
    fi
    
    # Update .zshrc if user is using zsh
    if [ "$CURRENT_SHELL" = "zsh" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            if ! grep -q "export PATH=.*\$HOME/go/bin" "$HOME/.zshrc" 2>/dev/null; then
                if run_command "echo '' >> '$HOME/.zshrc' && \
                             echo '# Go binaries path' >> '$HOME/.zshrc' && \
                             echo '$GO_PATH_LINE' >> '$HOME/.zshrc'" \
                    "Failed to update .zshrc" \
                    "Updated .zshrc with Go path"; then
                    changes_made=1
                fi
            else
                log_message "PATH already configured in .zshrc" "success"
            fi
        else
            log_message ".zshrc not found, creating it" "warning"
            run_command "touch $HOME/.zshrc && \
                       echo '# Go binaries path' >> '$HOME/.zshrc' && \
                       echo '$GO_PATH_LINE' >> '$HOME/.zshrc'" \
                "Failed to create .zshrc" \
                "Created .zshrc with Go path"
            changes_made=1
        fi
    fi
    
    # Add to current session's PATH
    export PATH="$PATH:$HOME/go/bin"
    
    if [ $changes_made -eq 1 ]; then
        log_message "PATH updated. You need to restart your terminal or run 'source ~/.${CURRENT_SHELL}rc' for changes to take effect" "success"
    fi
    
    log_message "Go tools should now be accessible from anywhere" "success"
    
    return 0
}

# Create a fix script for current session
fix_current_session() {
    echo -e "\e[32mCreating a fix script for the current session...\e[0m"
    
    cat > "$HOME/Tools/fix_go_tools.sh" << 'EOF'
#!/bin/bash

# Add Go bin to PATH
export PATH="$PATH:$HOME/go/bin"

# Check if tools are accessible
echo "Checking Go tools accessibility..."
for tool in dalfox subfinder nuclei waybackurls httpx assetfinder gau gf dnsx naabu kxss katana mantra subjs; do
    if command -v "$tool" &>/dev/null; then
        echo "✅ $tool is accessible"
    else
        echo "❌ $tool is not accessible"
    fi
done

echo ""
echo "Your PATH has been updated for this session."
echo "To make this permanent, add the following line to your shell configuration file:"
echo 'export PATH="$PATH:$HOME/go/bin"'
EOF
    
    chmod +x "$HOME/Tools/fix_go_tools.sh"
    echo -e "\e[32mFix script created at $HOME/Tools/fix_go_tools.sh\e[0m"
    echo -e "\e[32mRun 'source ~/Tools/fix_go_tools.sh' to fix your current session.\e[0m"
}

#calling function
install_go_tools

# Create fix script for current session
fix_current_session

# Print final instructions
echo -e "\e[32m=================================================\e[0m"
echo -e "\e[32mInstallation complete!\e[0m"
echo -e "\e[32mIf tools are not accessible, run: source ~/Tools/fix_go_tools.sh\e[0m"
echo -e "\e[32m=================================================\e[0m"
