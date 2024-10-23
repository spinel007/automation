#!/bin/bash

# This script is called subfi.sh
# Made by Asiful

# Check if target.txt file exists
if [ ! -f target.txt ]; then
    echo "target.txt file not found!"
    exit 1
fi

# Read the domains from target.txt
while IFS= read -r TARGET; do
    # Create a folder under the target name
    mkdir -p enum/"$TARGET"
    echo "Running scan for: $TARGET"

    # Subdomain enumeration
    echo "Running subfinder for: $TARGET"
    subfinder -d "$TARGET" -all -nW -o enum/"$TARGET"/"$TARGET"_subfinder.txt

    echo "Running assetfinder for: $TARGET"
    assetfinder --subs-only "$TARGET" | tee enum/"$TARGET"/"$TARGET"_assetfinder.txt

    echo "Running amass for: $TARGET"
    amass enum -d "$TARGET" -o enum/"$TARGET"/"$TARGET"_amass.txt

    # Combine all subdomain enumeration results and sort them uniquely into a single file
    echo "Combining subdomain results for: $TARGET"
    cat enum/"$TARGET"/*_*.txt | sort -u > enum/"$TARGET"/subdomains.txt

    if [ ! -s enum/"$TARGET"/subdomains.txt ]; then
        echo "Warning: No subdomains found for $TARGET."
    fi

    echo "Subdomain enumeration completed for: $TARGET and saved as subdomains.txt"
done < target.txt

