#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

if [ "$#" -eq 2 ]; then
    echo -e "\n${GREEN}####################################################"
    echo -e "###---------) Starting Aggressive Scan (---------###"
    echo -e "####################################################${NC}\n"
    target=$1
    ports=$2
    nmap -A $target -p $ports
elif [ "$#" -eq 1 ]; then
    echo -e "\n${GREEN}####################################################"
    echo -e "###---------) Starting Aggressive Scan (---------###"
    echo -e "####################################################${NC}\n"
    target=$1
    nmap -A $target -v
else
    echo -e "${RED}Usage: $0 <IP> Optional:<PORTS>${NC}"
    echo "Ports must be separated by a comma."
    echo -e "Example: ${GREEN}$0 127.0.0.1 22,80${NC}"
    exit 1
fi
