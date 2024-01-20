#!/bin/bash

if ifconfig | grep -q "tun0"; then
    tun0_ip=$(ifconfig tun0 | awk '/inet / {print $2}')
    echo "IP address of tun0: $tun0_ip"
    myip=$tun0_ip
    replacement="export MYIP=$myip"
    zshrc_path="$HOME/.zshrc"
    if [ -e "$zshrc_path" ]; then
        if grep -q "MYIP" "$zshrc_path"; then
            sed -i "/MYIP/ c\export MYIP=$myip" "$zshrc_path"
            echo -e "${GREEN}VM IP Address updated to $myip${NC}"
            zsh -i
        else
            echo "$replacement" >> "$zshrc_path"
            echo -e "${GREEN}VM IP address \"$myip\" added to $zshrc_path${NC}"
            zsh -i
        fi
    else
        echo -e "${RED}Error: .zshrc file not found.${NC}"
        exit 1
    fi
else
    echo "tun0 interface not found."
fi
