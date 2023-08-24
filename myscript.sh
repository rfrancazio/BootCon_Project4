#!/bin/bash

# Target IP
TARGET_IP="10.0.2.15"

# Begin Nmap scan
echo "Running Nmap scan on $TARGET_IP..."
nmap -sV -oA "nmap_scan" $TARGET_IP | tee "nmap_scan.log"
echo "Nmap scan completed. Check nmap_scan.log for results."

# Check for port 80
PORT_80_OPEN=$(grep "80/tcp open" "nmap_scan.log")

if [[ ! -z "$PORT_80_OPEN" ]]; then
    # Run Nikto scan if port 80 is open
    TARGET_URL="http://$TARGET_IP/DVWA"
    echo "Running Nikto scan on $TARGET_URL..."
    nikto -h $TARGET_URL -ask no -nointeractive | tee "nikto_scan.log"
    echo "Nikto scan completed. Check nikto_scan.log for results."

    # Run Gobuster directory brute-force
    echo "Running Gobuster directory brute-force on $TARGET_URL..."
    gobuster dir -u $TARGET_URL -w /usr/share/wordlists/dirb/common.txt -o "gobuster_scan.log" -q
    echo "Gobuster directory brute-force completed. Check gobuster_scan.log for results."
else
    echo "Port 80 is not open on $TARGET_IP. Skipping Nikto and Gobuster scans."
fi

echo "All scans completed."
