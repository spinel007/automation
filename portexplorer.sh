#!/bin/bash

# This script is called ip_ports_scan.sh
# Made by Asiful

# Check if target.txt file exists
if [ ! -f target.txt ]; then
    echo "target.txt file not found!"
    exit 1
fi

# Read the domains from target.txt
while IFS= read -r TARGET; do
    # Check if ip.txt exists for the target
    if [ ! -f enum/"$TARGET"/ip.txt ]; then
        echo "ip.txt not found for $TARGET. Run subdomain_to_ip.sh first."
        continue
    fi

    echo "Performing a deep scan for open ports on: $TARGET"
    echo "Running searchsploit for detected services..."

    # Scan open ports for each IP using nmap
    while IFS= read -r IP; do
        nmap -Pn -p- -sV -A --open "$IP" | grep 'open' | awk '{print $1, $2, $3}' >> enum/"$TARGET"/open_port.txt
    done < enum/"$TARGET"/ip.txt

    # Run searchsploit for each open port and detected service
    while IFS= read -r line; do
        PORT=$(echo "$line" | awk '{print $1}')
        SERVICE=$(echo "$line" | awk '{print $2}')
        echo "Searching exploits for service: $SERVICE on port: $PORT"

        EXPLOITS=$(searchsploit "$SERVICE" -w | grep -i 'http')

        if [ ! -z "$EXPLOITS" ]; then
            echo "$IP:$PORT - $SERVICE" >> enum/"$TARGET"/port_exploit.txt
            echo "$EXPLOITS" >> enum/"$TARGET"/port_exploit.txt
            echo "------------------------------------------" >> enum/"$TARGET"/port_exploit.txt
        fi
    done < enum/"$TARGET"/open_port.txt

done < target.txt

echo "Open port scan and exploit search completed. Results saved in open_port.txt and port_exploit.txt for each target."

