#!/bin/bash

# cat <<"EOF"
#    ▀████▀        ▀████▀ ▀███▀                     
#      ██            ██   ▄█▀                       
#      ██  ▄██▀▀██▄  ██ ▄█▀        ██▀▀█▄      ▄██  
#      ██ ██▀    ▀██ █████▄       ███  ▀██    ████  
#      ██ ██      ▓█ ▓█  ██▓           ▄██  ▄█▀ ██  
# ██▓  ██ █▓      ▓█ ▓█   ▀▓▓▄       ▀▀██▄▄█▀   ██  
#      ▓▓ █▓      ▓▓ ▓▓    ▓▒▓         ▓█▓  ▓▓▀ █▓  
# ▓▓▓  ▓▓ ▓▓▓    ▓▓▓ ▓▓     ▒▓▓▓     ▀▀▓▓▓▓▓▀   ▓▓  
#  ▒▓▒ ▒   ▒▓▒ ▒ ▒▓▒ ▒ ▒      ▒ ▒       ▒ ▒ ▒ ▒ ▒ ▒ 
#                                ▒▒▒  ▒▒▒      ▒▒   
#                                 ▒▒▒▒▒▒       ▒▒  
# EOF

cat <<"EOF"
     ██╗ ██████╗ ██╗  ██╗██████╗ ██╗  ██╗
     ██║██╔═████╗██║ ██╔╝╚════██╗██║  ██║
     ██║██║██╔██║█████╔╝  █████╔╝███████║
██   ██║████╔╝██║██╔═██╗  ╚═══██╗╚════██║
╚█████╔╝╚██████╔╝██║  ██╗██████╔╝     ██║
 ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝      ╚═╝
                                         
EOF

#installs the requrments
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove
sudo apt install libcap-dev -y
TARGET=$(pwd)

#checking requirments

#checks if go installed or not
check_requrments() {
    export PATH=$PATH:/usr/local/go/bin

    if command -v go &>/dev/null; then
        echo -e "\e[32mGo is installed...\e[0m"
    else
        echo -e "\e[31mGo is not installed. You can install it from here ---> https://go.dev/doc/install\e[0m"
        exit 1
    fi

    #checking git
    if command -v git &>/dev/null; then
        echo -e "\e[32mGit is already installed...\e[0m"
    else
        echo -e "\e[31mGit is not installed...now installing\e[0m"
        sudo apt install git -y
    fi

    #checking python
    if command -v python3 &>/dev/null; then
        echo -e "\e[32mPython is already installed...\e[0m"
    else
        echo -e "\e[31mNow installing python3\e[0m.."
        sudo apt install python3
        python3 --version
    fi

    #checking is there Tools flder avaiable in the home directory if not then creating one
    TOOLS_DIR="$HOME/Tools"
    if [ -d "$TOOLS_DIR" ]; then
        echo -e "\e[32mTools directory already exists in your home directory.\e[0m"
    else
        echo -e "\e[31mTools directory does not exist in your home directory.\e[0m"
        mkdir -p "$TOOLS_DIR"
        echo -e "\e[32mTools directory has been created.\e[0m"
    fi
    check_kali_or_ubuntu
}

#checking if the user os is
check_kali_or_ubuntu() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "kali" ]; then
            echo -e "\e[32mThe system is running Kali Linux.\e[0m"
            #calling kali Linux for tool installetion
            ./installers/kali_installer
        elif [ "$ID" = "ubuntu" ]; then
            echo -e "\e[32mThe system is running Ubuntu.\e[0m"
            #calling ubuntu for tool installetion
            ./installers/other_linux_installer
        else
            echo -e "\e[31mThe system is not running Kali or Ubuntu. It is running $ID.\e[0m"
            ./installers/other_linux_installer
        fi
    else
        echo -e "\e[32mCannot determine the operating system...\e[0m"
    fi
}

#calling first function
check_requrments
