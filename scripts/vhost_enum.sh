#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'  # No Color

if [ "$#" -ne 2 ]; then
    echo -e "${RED}Usage: $0 <URL (with Domain name not IP)> <Wordlist>${NC}"
    exit 1
fi

TMP_FILE="/tmp/gobuster_output_$((RANDOM % (10000000000 - 1000000000 + 1) + 1000000000))"
gobuster vhost --url $1 --append-domain -w $2 -k --no-error 2>&1 | tee $TMP_FILE

domain=$(echo "$1" | awk -F[/:] '{print $4}')
subdomains=$(strings $TMP_FILE | grep 'Found' | cut -d ' ' -f 2 | tr '\n' ',')
subdomains="$domain,$subdomains"

echo -e "${YELLOW}Do you want to add the discovered vhosts to /etc/hosts? (yes/no) : ${NC}\c"
read answer

if [ "$answer" == "yes" ]; then
    echo -e "${YELLOW}Enter the target IP : ${NC}\c"
    read input_ip
    sudo ./add_host.sh $input_ip $subdomains
    rm $TMP_FILE
elif [ "$answer" == "no" ]; then
    rm $TMP_FILE
    echo -e "${GREEN}Exiting...${NC}"
else
    echo -e "${RED}Invalid input. Please enter 'yes' or 'no'.${NC}"
    rm $TMP_FILE
    echo -e "${GREEN}Exiting...${NC}"
fi
