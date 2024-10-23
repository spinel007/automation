#!/bin/bash

# This script is called subdomain_to_ip.sh
# Made by Asiful

# Check if target.txt file exists
if [ ! -f target.txt ]; then
    echo "target.txt file not found!"
    exit 1
fi

# Read the domains from target.txt
while IFS= read -r TARGET; do
    # Check if subdomains.txt exists for the target
    if [ ! -f enum/"$TARGET"/subdomains.txt ]; then
        echo "No subdomains found for $TARGET. Skipping IP mapping."
        continue
    fi

    echo "Running IP mapping for: $TARGET"

    # Find IP addresses of all subdomains
    while IFS= read -r SUBDOMAIN; do
        dig +short "$SUBDOMAIN" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' >> enum/"$TARGET"/ips.txt
    done < enum/"$TARGET"/subdomains.txt

done < target.txt

# Combine all IP addresses into a single file and remove duplicates
cat enum/*/ips.txt | sort -u > enum/ips_combined.txt

# Cleanup
rm -rf enum/*/ips.txt

echo "All IPs saved to enum/ips_combined.txt"

