#!/bin/bash

# Script Name: paramhunter
# Made by Asiful

# Check if target.txt file exists
if [ ! -f target.txt ]; then
    echo "target.txt file not found!"
    exit 1
fi

# Read the domains from target.txt
while IFS= read -r TARGET; do
    # Check if urls.txt exists for the target
    if [ ! -f enum/"$TARGET"/urls.txt ]; then
        echo "urls.txt not found for $TARGET. Run urlhunter first."
        continue
    fi

    echo "Extracting parameters for fuzzing and testing from URLs for: $TARGET"

    grep -E '(\=|\?|/admin|/login|\.php$)' enum/"$TARGET"/urls.txt >> enum/"$TARGET"/param.txt
    cat enum/"$TARGET"/urls.txt | unfurl --unique keys >> enum/"$TARGET"/param.txt

    sort -u enum/"$TARGET"/param.txt -o enum/"$TARGET"/param.txt

done < target.txt
