#!/bin/bash

# ANSI color codes
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# Banner
display_banner() {
    echo -e "${CYAN}"
    echo -e "     ██╗ ██████╗ ██╗  ██╗██████╗ ██╗  ██╗"
    echo -e "     ██║██╔═████╗██║ ██╔╝╚════██╗██║  ██║"
    echo -e "     ██║██║██╔██║█████╔╝  █████╔╝███████║"
    echo -e "██   ██║████╔╝██║██╔═██╗  ╚═══██╗╚════██║"
    echo -e "╚█████╔╝╚██████╔╝██║  ██╗██████╔╝     ██║"
    echo -e " ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝      ╚═╝"
    echo -e "${RESET}"
    echo -e "${BOLD}Security Tools Manager${RESET}\n"
    echo -e "${BOLD}==========================${RESET}\n"
}

# Function to check if a tool is installed
check_tool() {
    local tool_name="$1"
    local tool_path="$2"
    local check_command="$3"
    
    echo -ne "${BOLD}$tool_name${RESET}: "
    
    if [ -n "$check_command" ]; then
        # Use the provided command to check if the tool is installed
        if eval "$check_command" &>/dev/null; then
            echo -e "${GREEN}Installed${RESET}"
            return 0
        else
            echo -e "${RED}Not installed${RESET}"
            return 1
        fi
    elif [ -n "$tool_path" ]; then
        # Check if the tool path exists
        if [ -e "$tool_path" ]; then
            echo -e "${GREEN}Installed${RESET}"
            return 0
        else
            echo -e "${RED}Not installed${RESET}"
            return 1
        fi
    else
        # Check if the tool is in PATH
        if command -v "$tool_name" &>/dev/null; then
            echo -e "${GREEN}Installed${RESET}"
            return 0
        else
            echo -e "${RED}Not installed${RESET}"
            return 1
        fi
    fi
}

# Function to list all installed tools
list_tools() {
    echo -e "${MAGENTA}${BOLD}Listing All Installed Security Tools${RESET}\n"

    # Check system tools
    echo -e "\n${BOLD}System Requirements:${RESET}"
    check_tool "Go" "" "command -v go"
    check_tool "Git" "" "command -v git"
    check_tool "Python" "" "command -v python3"
    check_tool "Base development tools" "" "pacman -Q base-devel &>/dev/null || apt list --installed 2>/dev/null | grep -q build-essential"

    # Check security tools
    echo -e "\n${BOLD}Security Tools:${RESET}"
    check_tool "feroxbuster" "" "command -v feroxbuster"
    check_tool "ParamSpider" "$HOME/Tools/ParamSpider" ""
    check_tool "XSStrike" "$HOME/Tools/XSStrike" ""
    check_tool "sqlmap" "" "command -v sqlmap || command -v sqlmap-py || [ -d '$HOME/Tools/sqlmap' ]"
    check_tool "ghauri" "$HOME/Tools/ghauri" ""
    check_tool "waymore" "$HOME/Tools/waymore" ""
    check_tool "creepyCrawler" "$HOME/Tools/creepyCrawler" ""
    check_tool "ffuf" "" "command -v ffuf"
    check_tool "SSRFmap" "$HOME/Tools/SSRFmap" ""
    check_tool "wpscan" "" "command -v wpscan"
    check_tool "AWS CLI" "" "command -v aws"
    check_tool "trufflehog" "" "command -v trufflehog"
    
    # Check for additional tools in ~/Tools
    if [ -d "$HOME/Tools" ]; then
        for tool_dir in "$HOME/Tools"/*; do
            if [ -d "$tool_dir" ]; then
                tool_name=$(basename "$tool_dir")
                # Skip already checked tools
                if [[ "$tool_name" != "ParamSpider" && "$tool_name" != "XSStrike" && \
                      "$tool_name" != "ghauri" && "$tool_name" != "waymore" && \
                      "$tool_name" != "creepyCrawler" && "$tool_name" != "SSRFmap" && \
                      "$tool_name" != "sqlmap" ]]; then
                    check_tool "$tool_name" "$tool_dir" ""
                fi
            fi
        done
    fi

    # Check virtual environments
    echo -e "\n${BOLD}Python Virtual Environments:${RESET}"
    check_tool "ParamSpider venv" "$HOME/Tools/ParamSpider/venv" ""
    check_tool "XSStrike venv" "$HOME/Tools/XSStrike/venv" ""
    check_tool "ghauri venv" "$HOME/Tools/ghauri/venv" ""
    check_tool "waymore venv" "$HOME/Tools/waymore/venv" ""
    check_tool "creepyCrawler venv" "$HOME/Tools/creepyCrawler/venv" ""
    check_tool "SSRFmap venv" "$HOME/Tools/SSRFmap/venv" ""
    
    # Check for additional virtual environments
    if [ -d "$HOME/Tools" ]; then
        for venv_dir in "$HOME/Tools"/*/venv; do
            if [ -d "$venv_dir" ]; then
                tool_name=$(basename "$(dirname "$venv_dir")")
                # Skip already checked tools
                if [[ "$tool_name" != "ParamSpider" && "$tool_name" != "XSStrike" && \
                      "$tool_name" != "ghauri" && "$tool_name" != "waymore" && \
                      "$tool_name" != "creepyCrawler" && "$tool_name" != "SSRFmap" ]]; then
                    check_tool "$tool_name venv" "$venv_dir" ""
                fi
            fi
        done
    fi

    # Check symlinks
    echo -e "\n${BOLD}Symlinks:${RESET}"
    check_tool "xsstrike symlink" "/usr/local/bin/xsstrike" ""
    check_tool "sqlmap symlink" "/usr/local/bin/sqlmap" ""
    check_tool "sqlmap-py symlink" "/usr/local/bin/sqlmap-py" ""
    check_tool "creepycrawler symlink" "/usr/local/bin/creepycrawler" ""
    check_tool "ssrfmap symlink" "/usr/local/bin/ssrfmap" ""
    check_tool "paramspider symlink" "/usr/local/bin/paramspider" ""
    check_tool "ghauri symlink" "/usr/local/bin/ghauri" ""
    check_tool "waymore symlink" "/usr/local/bin/waymore" ""
    check_tool "ffuf symlink" "/usr/local/bin/ffuf" ""
    check_tool "trufflehog symlink" "/usr/local/bin/trufflehog" ""
    
    # Check for additional symlinks pointing to tools in ~/Tools
    for symlink in /usr/local/bin/*; do
        if [ -L "$symlink" ]; then
            target=$(readlink -f "$symlink")
            if [[ "$target" == "$HOME/Tools"* ]]; then
                symlink_name=$(basename "$symlink")
                # Skip already checked symlinks
                if [[ "$symlink_name" != "xsstrike" && "$symlink_name" != "sqlmap" && \
                      "$symlink_name" != "sqlmap-py" && "$symlink_name" != "creepycrawler" && \
                      "$symlink_name" != "ssrfmap" && "$symlink_name" != "paramspider" && \
                      "$symlink_name" != "ghauri" && "$symlink_name" != "waymore" && \
                      "$symlink_name" != "ffuf" && "$symlink_name" != "trufflehog" ]]; then
                    check_tool "$symlink_name symlink" "$symlink" ""
                fi
            fi
        fi
    done

    # Check wrapper scripts
    echo -e "\n${BOLD}Wrapper Scripts:${RESET}"
    check_tool "XSStrike wrapper" "$HOME/Tools/XSStrike/xsstrike_wrapper.sh" ""
    check_tool "creepyCrawler wrapper" "$HOME/Tools/creepyCrawler/creepycrawler_wrapper.sh" ""
    check_tool "SSRFmap wrapper" "$HOME/Tools/SSRFmap/ssrfmap_wrapper.sh" ""
    check_tool "ghauri wrapper" "$HOME/Tools/ghauri/ghauri_wrapper.sh" ""
    check_tool "paramspider wrapper" "$HOME/Tools/ParamSpider/paramspider_wrapper.sh" ""
    check_tool "waymore wrapper" "$HOME/Tools/waymore/waymore_wrapper.sh" ""
    
    # Check for additional wrapper scripts
    for wrapper in "$HOME/Tools"/*/*_wrapper.sh; do
        if [ -f "$wrapper" ]; then
            tool_dir=$(dirname "$wrapper")
            tool_name=$(basename "$tool_dir")
            wrapper_name=$(basename "$wrapper")
            # Skip already checked wrappers
            if [[ "$wrapper_name" != "xsstrike_wrapper.sh" && "$wrapper_name" != "creepycrawler_wrapper.sh" && \
                  "$wrapper_name" != "ssrfmap_wrapper.sh" && "$wrapper_name" != "ghauri_wrapper.sh" && \
                  "$wrapper_name" != "paramspider_wrapper.sh" && "$wrapper_name" != "waymore_wrapper.sh" ]]; then
                check_tool "$tool_name wrapper" "$wrapper" ""
            fi
        fi
    done

    echo -e "\n${BOLD}==========================${RESET}"
    echo -e "Report generated on: $(date)"
    echo -e "System: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
}

# Function to remove a tool
remove_tool() {
    local tool_name="$1"
    local tool_path="$2"
    local is_symlink="$3"
    
    echo -ne "${BOLD}Removing $tool_name${RESET}: "
    
    if [ "$is_symlink" = "true" ] && [ -L "$tool_path" ]; then
        # Remove symlink
        sudo rm -f "$tool_path" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Symlink removed${RESET}"
        else
            echo -e "${RED}Failed to remove symlink${RESET}"
        fi
    elif [ -d "$tool_path" ]; then
        # Remove directory
        rm -rf "$tool_path" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Removed${RESET}"
        else
            echo -e "${RED}Failed to remove${RESET}"
        fi
    elif [ -f "$tool_path" ]; then
        # Remove file
        rm -f "$tool_path" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Removed${RESET}"
        else
            echo -e "${RED}Failed to remove${RESET}"
        fi
    else
        echo -e "${YELLOW}Not found${RESET}"
    fi
}

# Function to uninstall all tools
uninstall_tools() {
    echo -e "${RED}${BOLD}Uninstalling All Security Tools${RESET}\n"

    # Confirm before proceeding
    echo -e "${RED}WARNING: This will remove all security tools installed by the installer.${RESET}"
    echo -e "${RED}This action cannot be undone.${RESET}"
    read -p "Do you want to continue? (y/n): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo -e "${YELLOW}Uninstallation cancelled.${RESET}"
        return
    fi

    # Remove tool directories
    echo -e "\n${BOLD}Removing Tool Directories:${RESET}"
    remove_tool "ParamSpider" "$HOME/Tools/ParamSpider" "false"
    remove_tool "XSStrike" "$HOME/Tools/XSStrike" "false"
    remove_tool "ghauri" "$HOME/Tools/ghauri" "false"
    remove_tool "waymore" "$HOME/Tools/waymore" "false"
    remove_tool "creepyCrawler" "$HOME/Tools/creepyCrawler" "false"
    remove_tool "SSRFmap" "$HOME/Tools/SSRFmap" "false"
    remove_tool "sqlmap" "$HOME/Tools/sqlmap" "false"
    
    # Check for any other tool directories in ~/Tools and offer to remove them
    if [ -d "$HOME/Tools" ]; then
        echo -e "\n${BOLD}Checking for other tools in ~/Tools:${RESET}"
        for tool_dir in "$HOME/Tools"/*; do
            if [ -d "$tool_dir" ]; then
                tool_name=$(basename "$tool_dir")
                # Skip already processed tools
                if [[ "$tool_name" != "ParamSpider" && "$tool_name" != "XSStrike" && \
                      "$tool_name" != "ghauri" && "$tool_name" != "waymore" && \
                      "$tool_name" != "creepyCrawler" && "$tool_name" != "SSRFmap" && \
                      "$tool_name" != "sqlmap" ]]; then
                    echo -ne "${YELLOW}Found additional tool: $tool_name. Remove? (y/n): ${RESET}"
                    read -r remove_choice
                    if [[ "$remove_choice" == "y" || "$remove_choice" == "Y" ]]; then
                        remove_tool "$tool_name" "$tool_dir" "false"
                    else
                        echo -e "${YELLOW}Skipping $tool_name${RESET}"
                    fi
                fi
            fi
        done
    fi

    # Remove symlinks
    echo -e "\n${BOLD}Removing Symlinks:${RESET}"
    remove_tool "xsstrike symlink" "/usr/local/bin/xsstrike" "true"
    remove_tool "sqlmap-py symlink" "/usr/local/bin/sqlmap-py" "true"
    remove_tool "sqlmap symlink" "/usr/local/bin/sqlmap" "true"
    remove_tool "creepycrawler symlink" "/usr/local/bin/creepycrawler" "true"
    remove_tool "ssrfmap symlink" "/usr/local/bin/ssrfmap" "true"
    remove_tool "paramspider symlink" "/usr/local/bin/paramspider" "true"
    remove_tool "ghauri symlink" "/usr/local/bin/ghauri" "true"
    remove_tool "waymore symlink" "/usr/local/bin/waymore" "true"
    remove_tool "ffuf symlink" "/usr/local/bin/ffuf" "true"
    remove_tool "trufflehog symlink" "/usr/local/bin/trufflehog" "true"
    
    # Check for any other tool symlinks in /usr/local/bin
    echo -e "\n${BOLD}Checking for other tool symlinks in /usr/local/bin:${RESET}"
    for symlink in /usr/local/bin/*; do
        if [ -L "$symlink" ]; then
            target=$(readlink -f "$symlink")
            if [[ "$target" == "$HOME/Tools"* ]]; then
                symlink_name=$(basename "$symlink")
                echo -ne "${YELLOW}Found symlink to a tool in ~/Tools: $symlink_name. Remove? (y/n): ${RESET}"
                read -r remove_choice
                if [[ "$remove_choice" == "y" || "$remove_choice" == "Y" ]]; then
                    remove_tool "$symlink_name symlink" "$symlink" "true"
                else
                    echo -e "${YELLOW}Skipping $symlink_name${RESET}"
                fi
            fi
        fi
    done

    # Check if Tools directory is empty and remove if it is
    if [ -d "$HOME/Tools" ] && [ -z "$(ls -A $HOME/Tools)" ]; then
        echo -e "\n${BOLD}Tools directory is empty, removing it...${RESET}"
        rmdir "$HOME/Tools" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Tools directory removed${RESET}"
        else
            echo -e "${RED}Failed to remove Tools directory${RESET}"
        fi
    else
        echo -e "\n${YELLOW}Tools directory still contains other files or directories, not removing it.${RESET}"
        echo -e "${YELLOW}You may want to check its contents manually.${RESET}"
    fi

    echo -e "\n${BOLD}===============================${RESET}"
    echo -e "${GREEN}Uninstallation complete!${RESET}"
    echo -e "Uninstallation completed on: $(date)"
}

# Function to display help
display_help() {
    echo -e "${BOLD}Usage:${RESET}"
    echo -e "  $0 [option]"
    echo -e "\n${BOLD}Options:${RESET}"
    echo -e "  ${CYAN}list${RESET}       List all installed security tools"
    echo -e "  ${CYAN}uninstall${RESET}  Uninstall all security tools"
    echo -e "  ${CYAN}help${RESET}       Display this help message"
    echo -e "\n${BOLD}Examples:${RESET}"
    echo -e "  $0 list       # List all installed tools"
    echo -e "  $0 uninstall  # Uninstall all tools"
}

# Main function
main() {
    display_banner

    # Check command line arguments
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}No option specified.${RESET}"
        display_help
        exit 1
    fi

    case "$1" in
        list)
            list_tools
            ;;
        uninstall)
            uninstall_tools
            ;;
        help)
            display_help
            ;;
        *)
            echo -e "${RED}Invalid option: $1${RESET}"
            display_help
            exit 1
            ;;
    esac
}

# Call main function with all arguments
main "$@"
