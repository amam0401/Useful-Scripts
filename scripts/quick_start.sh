#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi
input_ip=$1
quick_scan.sh $input_ip
aggressive_scan.sh $input_ip
update_target_ip.sh $input_ip
