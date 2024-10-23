#!/bin/bash

# Script Name: fullhunter
# Made by Asiful
# This script runs all other scripts in one go: subfi, imap, portexplorer, urlhunter, and paramhunter

# Run subfi (subdomain.sh) to find subdomains
./subfi.sh
if [ $? -ne 0 ]; then
    echo "subfi script failed! Exiting."
    exit 1
fi

# Run imap (subdomain_to_ip.sh) to map subdomains to IP addresses
./imap.sh
if [ $? -ne 0 ]; then
    echo "imap script failed! Exiting."
    exit 1
fi

# Run portexplorer (ip_ports_scan.sh) to scan open ports of IPs
./portexplorer.sh
if [ $? -ne 0 ]; then
    echo "portexplorer script failed! Exiting."
    exit 1
fi

# Run urlhunter (subdomains_urls.sh) to collect URLs from subdomains
./urlhunter.sh
if [ $? -ne 0 ]; then
    echo "urlhunter script failed! Exiting."
    exit 1
fi

# Run paramhunter (extract_params_script.sh) to extract parameters from URLs
./paramhunter.sh
if [ $? -ne 0 ]; then
    echo "paramhunter script failed! Exiting."
    exit 1
fi

echo "All scripts completed successfully."
