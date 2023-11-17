#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <IP>${NC}"
    exit 1
fi

vmip="$1"
replacement="export VMIP=$vmip"
zshrc_path="$HOME/.zshrc"

if [ -e "$zshrc_path" ]; then
    if grep -q "VMIP" "$zshrc_path"; then
        sed -i "/VMIP/ c\export VMIP=$vmip" "$zshrc_path"
        echo -e "${GREEN}VM IP Address updated to $vmip${NC}"
        zsh -i
    else
        echo "$replacement" >> "$zshrc_path"
        echo -e "${GREEN}VM IP address \"$vmip\" added to $zshrc_path${NC}"
        zsh -i
    fi
else
    echo -e "${RED}Error: .zshrc file not found.${NC}"
    exit 1
fi
