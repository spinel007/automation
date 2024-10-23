#!/bin/bash

# Script Name: urlhunter
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
        echo "subdomains.txt not found for $TARGET. Run subfi.sh first."
        continue
    fi

    echo "Collecting URLs from subdomains for: $TARGET"

    # Pull URLs from each subdomain using httpx, waybackurls, gau, and hakrawler
    while IFS= read -r SUBDOMAIN; do
        echo "Getting URLs for: $SUBDOMAIN"
        httpx -silent -u "$SUBDOMAIN" -sr -path | tee -a enum/"$TARGET"/urls.txt
        echo "$SUBDOMAIN" | waybackurls >> enum/"$TARGET"/urls.txt
        gau "$SUBDOMAIN" >> enum/"$TARGET"/urls.txt
        echo "$SUBDOMAIN" | hakrawler -plain >> enum/"$TARGET"/urls.txt
    done < enum/"$TARGET"/subdomains.txt

    # Remove duplicate URLs
    sort -u enum/"$TARGET"/urls.txt -o enum/"$TARGET"/urls.txt

done < target.txt

echo "URL collection completed and duplicates removed. Results saved in urls.txt for each target."
