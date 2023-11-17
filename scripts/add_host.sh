#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'  # No Color

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root. Use sudo.${NC}"
    exit 1
fi

if [ "$#" -ne 2 ]; then
    echo -e "${RED}Usage: $0 <IP> <domain1,domain2,...>${NC}"
    echo -e "${YELLOW}NOTE: To update the IP of an existing entry in /etc/hosts or add another domain to an existing entry, make sure to include one of the existing domains in the second argument.${NC}"
    exit 1
fi

ip=$1
new_domains=$(echo "$2" | tr "," " ")

for domain in $new_domains; do
    if grep "$domain" /etc/hosts; then
        existing_domains=$(grep "$domain" /etc/hosts | cut -d ' ' -f 2- | tr ' ' '\n')
        existing_domains2=$(grep "$domain" /etc/hosts | cut -d ' ' -f 2-)
        all_domains="$existing_domains $new_domains"
        unique_domains=$(echo $all_domains | tr ' ' '\n' | sort -u | tr '\n' ' ' | xargs)
        sed -i "/$existing_domains2/c\\$ip $unique_domains" /etc/hosts
        echo -e "${GREEN}Updated entry for $ip with domains : $unique_domains${NC}"
        exit 0
    else
        echo "$ip $new_domains" | sudo tee -a /etc/hosts > /dev/null
        echo -e "${GREEN}Added new entry for $ip with domains : $unique_domains${NC}"
        exit 0
    fi
done
