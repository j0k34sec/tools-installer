#!/bin/bash

# Version information
CURRENT_VERSION="1.0.0"
REPO_URL="https://github.com/j0k34sec/tools-installer"
REPO_RAW_URL="https://raw.githubusercontent.com/j0k34sec/tools-installer/main"

# Define colors for output
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Set the target directory to the location of this script
TARGET="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print a fancy banner
print_banner() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo ' ╔═══════════════════════════════════════════════════════╗'
    echo ' ║                                                       ║'
    echo ' ║         ██╗ ██████╗ ██╗  ██╗██████╗ ██╗  ██╗          ║'
    echo ' ║         ██║██╔═████╗██║ ██╔╝╚════██╗██║  ██║          ║'
    echo ' ║         ██║██║██╔██║█████╔╝  █████╔╝███████║          ║'
    echo ' ║    ██   ██║████╔╝██║██╔═██╗  ╚═══██╗╚════██║          ║'
    echo ' ║    ╚█████╔╝╚██████╔╝██║  ██╗██████╔╝     ██║          ║'
    echo ' ║    ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝      ╚═╝           ║'
    echo ' ║                                                       ║'
    echo ' ║           Security Tools Installer v2.0               ║'
    echo ' ║                                                       ║'
    echo ' ╚═══════════════════════════════════════════════════════╝'
    echo -e "${RESET}\n"
    echo -e "${BOLD}${YELLOW}      Your Ultimate Security Tools Installer${RESET}\n"
    echo -e "${CYAN}===================================================${RESET}\n"
    sleep 1
}

# Function for spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\\'
    local message="$2"
    
    tput civis  # Hide cursor
    
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " ${CYAN}${BOLD}[%c]${RESET} ${BOLD}%s${RESET}\r" "$spinstr" "$message"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    
    printf "   ${GREEN}${BOLD}[✓]${RESET} ${BOLD}%s${RESET}\n" "$message"
    tput cnorm  # Show cursor
}

# Function to show progress bar
show_progress() {
    local current=$1
    local total=$2
    local message="$3"
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

# Function to display a section header
display_section() {
    local title="$1"
    echo -e "\n${BOLD}${MAGENTA}◉ ${title} ${RESET}"
    echo -e "${CYAN}$(printf '%.0s─' {1..50})${RESET}"
}

# Function to check for updates and self-update if needed
check_for_updates() {
    display_section "CHECKING FOR UPDATES"
    
    # Check if git and curl are installed
    if ! command -v git &>/dev/null; then
        echo -e "${YELLOW}${BOLD}⚠️ Git command not found. Skipping update check.${RESET}"
        echo -e "${YELLOW}  Install git with: sudo pacman -S git (Arch) or sudo apt install git (Debian/Ubuntu)${RESET}"
        return 1
    fi
    
    if ! command -v curl &>/dev/null; then
        echo -e "${YELLOW}Curl command not found. Skipping update check.${RESET}"
        echo -e "${YELLOW}Install curl with: sudo pacman -S curl (Arch) or sudo apt install curl (Debian/Ubuntu)${RESET}"
        return 1
    fi
    
    # If this is a git repository, use git to update
    if [ -d ".git" ]; then
        echo -e "${BLUE}Git repository detected. Checking for updates...${RESET}"
        git fetch origin --quiet 2>/dev/null
        
        LOCAL_REV=$(git rev-parse HEAD 2>/dev/null)
        REMOTE_REV=$(git rev-parse origin/main 2>/dev/null)
        
        if [ "$LOCAL_REV" != "$REMOTE_REV" ]; then
            echo -e "${GREEN}Update available!${RESET}"
            read -p "Do you want to update to the latest version? (y/n): " update_choice
            if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
                echo -e "${BLUE}Updating...${RESET}"
                git pull origin main
                echo -e "${GREEN}Update complete! Please run the script again.${RESET}"
                exit 0
            else
                echo -e "${YELLOW}Update skipped.${RESET}"
            fi
        else
            echo -e "${GREEN}You have the latest version.${RESET}"
        fi
    else
        # Not a git repository, try to check version from GitHub
        echo -e "${BLUE}Checking for updates from GitHub...${RESET}"
        
        # Try to get the version file from GitHub
        REMOTE_VERSION=$(curl -s "${REPO_RAW_URL}/version.txt" 2>/dev/null)
        
        if [ -z "$REMOTE_VERSION" ]; then
            echo -e "${YELLOW}Could not check for updates. Continuing with installation...${RESET}"
        elif [ "$REMOTE_VERSION" != "$CURRENT_VERSION" ]; then
            echo -e "${GREEN}Update available! Current: ${CURRENT_VERSION}, Latest: ${REMOTE_VERSION}${RESET}"
            read -p "Do you want to update to the latest version? (y/n): " update_choice
            if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
                echo -e "${BLUE}Downloading latest version...${RESET}"
                
                # Create a temporary directory for the update
                TMP_DIR=$(mktemp -d)
                
                # Clone the repository to the temporary directory
                if git clone --depth=1 "$REPO_URL" "$TMP_DIR" &>/dev/null; then
                    # Copy all files from the temporary directory to the current directory
                    cp -R "$TMP_DIR"/* .
                    rm -rf "$TMP_DIR"
                    echo -e "${GREEN}Update complete! Please run the script again.${RESET}"
                    exit 0
                else
                    echo -e "${RED}Failed to download update. Continuing with current version.${RESET}"
                    rm -rf "$TMP_DIR"
                fi
            else
                echo -e "${YELLOW}Update skipped.${RESET}"
            fi
        else
            echo -e "${GREEN}You have the latest version.${RESET}"
        fi
    fi
}

# Detect OS type and install basic requirements
install_basic_requirements() {
    display_section "INSTALLING BASIC REQUIREMENTS"
    
    # Check OS with progress bar animation
    local os_check_steps=4
    local current_step=0
    
    show_progress $current_step $os_check_steps "Detecting operating system"
    sleep 0.5
    current_step=$((current_step + 1))
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        show_progress $current_step $os_check_steps "Found OS: $PRETTY_NAME"
        sleep 0.5
        current_step=$((current_step + 1))
        
        if [ "$ID" = "arch" ] || [ "$ID" = "manjaro" ] || [ "$ID" = "endeavouros" ]; then
            show_progress $current_step $os_check_steps "Detected Arch-based system"
            sleep 0.5
            current_step=$((current_step + 1))
            show_progress $current_step $os_check_steps "Preparing to use pacman"
            sleep 0.5
            echo -e "${GREEN}${BOLD}🖥️ Detected Arch-based system. Using pacman...${RESET}"
            # Check if we have sudo access
            if ! sudo -v &>/dev/null; then
                echo -e "${RED}Error: This script requires sudo privileges to install packages.${RESET}"
                echo -e "${YELLOW}Please run with sudo or grant sudo privileges to continue.${RESET}"
                return 1
            fi
            
            # Use timeout and non-interactive flags to prevent hanging
            sudo pacman -Syu --noconfirm --noprogressbar --needed || {
                echo -e "${YELLOW}Pacman update failed. Continuing with installation...${RESET}"
            }
            
            echo -e "${BLUE}Installing required packages...${RESET}"
            if ! sudo pacman -S --noconfirm --noprogressbar --needed libcap curl git; then
                echo -e "${RED}Failed to install some packages. Some tools may not work correctly.${RESET}"
                echo -e "${YELLOW}Please install missing packages manually: libcap, curl, git${RESET}"
            fi
        else
            echo -e "${GREEN}Detected Debian/Ubuntu-based system. Using apt...${RESET}"
            # Check if we have sudo access
            if ! sudo -v &>/dev/null; then
                echo -e "${RED}Error: This script requires sudo privileges to install packages.${RESET}"
                echo -e "${YELLOW}Please run with sudo or grant sudo privileges to continue.${RESET}"
                return 1
            fi
            
            if ! sudo apt update -y; then
                echo -e "${YELLOW}APT update failed. Continuing with installation...${RESET}"
            fi
            
            if ! sudo apt upgrade -y; then
                echo -e "${YELLOW}APT upgrade failed. Continuing with installation...${RESET}"
            fi
            
            sudo apt autoremove -y || true
            
            echo -e "${BLUE}Installing required packages...${RESET}"
            if ! sudo apt install libcap-dev curl git -y; then
                echo -e "${RED}Failed to install some packages. Some tools may not work correctly.${RESET}"
                echo -e "${YELLOW}Please install missing packages manually: libcap-dev, curl, git${RESET}"
            fi
        fi
    else
        echo -e "${RED}Cannot determine OS type. Defaulting to apt...${RESET}"
        # Check if apt exists
        if ! command -v apt &>/dev/null; then
            echo -e "${RED}Error: apt not found. Cannot install dependencies.${RESET}"
            echo -e "${YELLOW}Please install the following packages manually: libcap-dev, curl, git${RESET}"
            return 1
        fi
        
        # Check if we have sudo access
        if ! sudo -v &>/dev/null; then
            echo -e "${RED}Error: This script requires sudo privileges to install packages.${RESET}"
            echo -e "${YELLOW}Please run with sudo or grant sudo privileges to continue.${RESET}"
            return 1
        fi
        
        if ! sudo apt update -y; then
            echo -e "${YELLOW}APT update failed. Continuing with installation...${RESET}"
        fi
        
        if ! sudo apt upgrade -y; then
            echo -e "${YELLOW}APT upgrade failed. Continuing with installation...${RESET}"
        fi
        
        sudo apt autoremove -y || true
        
        echo -e "${BLUE}Installing required packages...${RESET}"
        if ! sudo apt install libcap-dev curl git -y; then
            echo -e "${RED}Failed to install some packages. Some tools may not work correctly.${RESET}"
            echo -e "${YELLOW}Please install missing packages manually: libcap-dev, curl, git${RESET}"
            return 1
        fi
    fi
    
    return 0
}

# Install basic requirements
install_basic_requirements
REQUIREMENTS_STATUS=$?

# Function to check for requirements
check_requrments() {
    display_section "CHECKING REQUIREMENTS"
    
    # Add common Go installation paths to PATH
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

    echo -e "${BLUE}Checking for Go installation...${RESET}"
    if command -v go &>/dev/null; then
        # Get Go version with spinner
        {
            GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
        } & spinner $! "Checking Go version"
        
        echo -e "${GREEN}${BOLD}✅ Go is installed${RESET}"
        echo -e "${BLUE}${BOLD}➤ Go version:${RESET} ${GREEN}$GO_VERSION${RESET}"
        
        # Set GOPATH if not already set
        if [ -z "$GOPATH" ]; then
            export GOPATH=$HOME/go
            echo -e "${BLUE}${BOLD}➤ GOPATH set to:${RESET} ${GREEN}$GOPATH${RESET}"
        fi
    else
        echo -e "${RED}${BOLD}❌ Go is not installed!${RESET}"
        echo -e "${YELLOW}${BOLD}ℹ️ Installation options:${RESET}"
        echo -e "  ${CYAN}• Official website:${RESET} https://go.dev/doc/install"
        echo -e "  ${CYAN}• Arch Linux:${RESET} sudo pacman -S go"
        echo -e "  ${CYAN}• Debian/Ubuntu:${RESET} sudo apt install golang-go"
        
        # Show error animation
        echo -e "\n${RED}$(printf '%.0s─' {1..50})${RESET}"
        for i in {1..3}; do
            echo -ne "${RED}${BOLD}⚠️ Cannot continue without Go. Exiting in $((4-i)) seconds...${RESET}\r"
            sleep 1
        done
        echo -e "\n${RED}$(printf '%.0s─' {1..50})${RESET}"
        exit 1
    fi

    # Check for git
    if command -v git &>/dev/null; then
        echo -e "${GREEN}Git is already installed...${RESET}"
    else
        echo -e "${RED}Git is not installed...now installing${RESET}"
        # Detect OS type for installation
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" = "arch" ] || [ "$ID" = "manjaro" ] || [ "$ID" = "endeavouros" ]; then
                sudo pacman -S --noconfirm git || {
                    echo -e "${RED}Failed to install git. Please install it manually.${RESET}"
                    exit 1
                }
            else
                sudo apt install git -y || {
                    echo -e "${RED}Failed to install git. Please install it manually.${RESET}"
                    exit 1
                }
            fi
        else
            sudo apt install git -y || {
                echo -e "${RED}Failed to install git. Please install it manually.${RESET}"
                exit 1
            }
        fi
    fi

    # Check for python
    if command -v python3 &>/dev/null; then
        echo -e "${GREEN}Python is already installed...${RESET}"
        # Check Python version
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        echo -e "${BLUE}Python version: $PYTHON_VERSION${RESET}"
    else
        echo -e "${RED}Python3 not found. Now installing...${RESET}"
        # Detect OS type for installation
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" = "arch" ] || [ "$ID" = "manjaro" ] || [ "$ID" = "endeavouros" ]; then
                sudo pacman -S --noconfirm python || {
                    echo -e "${RED}Failed to install Python. Please install it manually.${RESET}"
                    exit 1
                }
            else
                sudo apt install python3 -y || {
                    echo -e "${RED}Failed to install Python. Please install it manually.${RESET}"
                    exit 1
                }
            fi
        else
            sudo apt install python3 -y || {
                echo -e "${RED}Failed to install Python. Please install it manually.${RESET}"
                exit 1
            }
        fi
        python3 --version
    fi

    #checking if Tools folder is available in the home directory, if not then creating one
    TOOLS_DIR="$HOME/Tools"
    if [ -d "$TOOLS_DIR" ]; then
        echo -e "${GREEN}Tools directory already exists in your home directory.${RESET}"
    else
        echo -e "${YELLOW}Tools directory does not exist in your home directory.${RESET}"
        mkdir -p "$TOOLS_DIR" || {
            echo -e "${RED}Failed to create Tools directory. Please check permissions.${RESET}"
            exit 1
        }
        echo -e "${GREEN}Tools directory has been created at: $TOOLS_DIR${RESET}"
    fi
    
    # Continue with OS-specific installation
    check_os_type
    return $?
}

#checking what OS the user is running
check_os_type() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "kali" ]; then
            echo -e "${GREEN}The system is running Kali Linux.${RESET}"
            # Check if installer script exists
            if [ ! -f "$TARGET/installers/kali_installer" ]; then
                echo -e "${RED}Error: Kali installer script not found at: $TARGET/installers/kali_installer${RESET}"
                echo -e "${YELLOW}Falling back to Debian tools installer...${RESET}"
                
                # Check if generic installer exists
                if [ -f "$TARGET/installers/debian_tools_installer" ]; then
                    "$TARGET/installers/debian_tools_installer"
                    return $?
                else
                    echo -e "${RED}Error: Debian tools installer not found either.${RESET}"
                    echo -e "${RED}Installation cannot continue. Please check your installation files.${RESET}"
                    return 1
                fi
            fi
            
            # Call Kali Linux installer
            "$TARGET/installers/kali_installer"
            return $?
            
        elif [ "$ID" = "ubuntu" ] || [ "$ID" = "debian" ] || [ "$ID" = "linuxmint" ]; then
            echo -e "${GREEN}The system is running $PRETTY_NAME.${RESET}"
            # Check if installer script exists
            if [ ! -f "$TARGET/installers/debian_tools_installer" ]; then
                echo -e "${RED}Error: Debian/Ubuntu installer script not found at: $TARGET/installers/debian_tools_installer${RESET}"
                echo -e "${RED}Installation cannot continue. Please check your installation files.${RESET}"
                return 1
            fi
            
            # Call Ubuntu/Debian installer
            "$TARGET/installers/debian_tools_installer"
            return $?
            
        elif [ "$ID" = "arch" ] || [ "$ID" = "manjaro" ] || [ "$ID" = "endeavouros" ]; then
            echo -e "${GREEN}The system is running Arch Linux or an Arch-based distribution: $PRETTY_NAME${RESET}"
            
            # Check for yay AUR helper
            if ! command -v yay &>/dev/null; then
                echo -e "${YELLOW}The yay AUR helper is not installed on your system.${RESET}"
                read -p "Would you like to install yay? (y/n): " install_yay
                
                if [[ "$install_yay" =~ ^[Yy]$ ]]; then
                    echo -e "${BLUE}Installing yay AUR helper...${RESET}"
                    
                    # Create temp directory
                    temp_dir=$(mktemp -d)
                    cd "$temp_dir"
                    
                    # Install git if not already installed
                    if ! command -v git &>/dev/null; then
                        echo -e "${BLUE}Installing git...${RESET}"
                        sudo pacman -S --noconfirm --needed git
                    fi
                    
                    # Clone yay repo and build
                    git clone https://aur.archlinux.org/yay.git
                    cd yay
                    makepkg -si --noconfirm
                    
                    # Clean up
                    cd "$TARGET"
                    rm -rf "$temp_dir"
                    
                    if command -v yay &>/dev/null; then
                        echo -e "${GREEN}yay has been successfully installed!${RESET}"
                    else
                        echo -e "${RED}Failed to install yay. Continuing with installation...${RESET}"
                    fi
                else
                    echo -e "${YELLOW}Skipping yay installation. Some tools might not be available.${RESET}"
                fi
            else
                echo -e "${GREEN}yay AUR helper is already installed.${RESET}"
            fi
            
            # Check if installer script exists
            if [ ! -f "$TARGET/installers/arch_installer" ]; then
                echo -e "${RED}Error: Arch installer script not found at: $TARGET/installers/arch_installer${RESET}"
                echo -e "${RED}Installation cannot continue. Please check your installation files.${RESET}"
                return 1
            fi
            
            # Call Arch installer
            "$TARGET/installers/arch_installer"
            return $?
            
        else
            echo -e "${YELLOW}The system is not running Kali, Ubuntu, or Arch. It is running $PRETTY_NAME ($ID).${RESET}"
            echo -e "${BLUE}Using the Debian tools installer...${RESET}"
            
            # Check if installer script exists
            if [ ! -f "$TARGET/installers/debian_tools_installer" ]; then
                echo -e "${RED}Error: Debian tools installer script not found at: $TARGET/installers/debian_tools_installer${RESET}"
                echo -e "${RED}Installation cannot continue. Please check your installation files.${RESET}"
                return 1
            fi
            
            # Call Debian tools installer
            "$TARGET/installers/debian_tools_installer"
            return $?
        fi
    else
        echo -e "${YELLOW}Cannot determine the operating system...${RESET}"
        echo -e "${BLUE}Using the Debian tools installer...${RESET}"
        
        # Check if installer script exists
        if [ ! -f "$TARGET/installers/debian_tools_installer" ]; then
            echo -e "${RED}Error: Debian tools installer script not found at: $TARGET/installers/debian_tools_installer${RESET}"
            echo -e "${RED}Installation cannot continue. Please check your installation files.${RESET}"
            return 1
        fi
        
        # Call Debian tools installer
        "$TARGET/installers/debian_tools_installer"
        return $?
    fi
}

# Create error log file
LOG_FILE="$HOME/Tools/install_errors.log"
> "$LOG_FILE"

# Display the banner
print_banner

echo -e "${BLUE}${BOLD}🚀 Starting J0K34 Security Tools Installer...${RESET}"
echo -e "${BLUE}${BOLD}📋 Installation log will be saved to:${RESET} ${CYAN}$LOG_FILE${RESET}"
echo -e "${CYAN}===================================================${RESET}"

# Error handling function with enhanced visuals
handle_error() {
    local exit_code=$1
    local error_msg=$2
    
    if [ $exit_code -ne 0 ]; then
        echo -e "\n${RED}${BOLD}⛔ ERROR:${RESET} $error_msg" | tee -a "$LOG_FILE"
        echo -e "${YELLOW}${BOLD}📋 Please check the log file:${RESET} ${CYAN}$LOG_FILE${RESET}"
        echo -e "${YELLOW}${BOLD}🔄 You can try running the installer again or check for specific errors.${RESET}"
        
        # Show error animation
        echo -e "\n${RED}$(printf '%.0s─' {1..50})${RESET}"
        echo -e "${RED}${BOLD}❌ Installation encountered a problem!${RESET}"
        echo -e "${RED}$(printf '%.0s─' {1..50})${RESET}\n"
    fi
}

# Check for updates first
check_for_updates
UPDATE_STATUS=$?

# Show fancy progress animation
echo -e "\n${CYAN}$(printf '%.0s─' {1..50})${RESET}"
echo -e "${BOLD}${CYAN}🔍 System Check Progress${RESET}"

for i in {1..10}; do
    show_progress $i 10 "Performing system checks"
    sleep 0.1
done

# Only continue if basic requirements were installed successfully
if [ "$REQUIREMENTS_STATUS" -eq 0 ]; then
    # Call the requirements check function
    check_requrments
    REQUIREMENTS_CHECK_STATUS=$?
    
    # Handle errors
    if [ "$REQUIREMENTS_CHECK_STATUS" -ne 0 ]; then
        handle_error "$REQUIREMENTS_CHECK_STATUS" "Failed to verify or install required dependencies."
        exit 1
    fi
else
    handle_error "$REQUIREMENTS_STATUS" "Failed to install basic requirements."
    exit 1
fi

# Final success message with animation
echo -e "\n${CYAN}$(printf '%.0s═' {1..50})${RESET}"
echo -e "${GREEN}${BOLD}✅ INSTALLATION COMPLETED SUCCESSFULLY!${RESET}"
echo -e "${BLUE}${BOLD}📋 For any issues, please check the log file:${RESET} ${CYAN}$LOG_FILE${RESET}"

# Countdown animation
for i in {1..5}; do
    echo -ne "${GREEN}${BOLD}🚀 Finalizing in $((6-i)) seconds...${RESET}\r"
    sleep 0.5
done

echo -e "\n\n${CYAN}${BOLD}Thank you for using J0K34SEC Tools Installer!${RESET}"
echo -e "${CYAN}$(printf '%.0s═' {1..50})${RESET}\n"
