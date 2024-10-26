#!/bin/bash

INPUT_FILE="wildcards"
OUTPUT_FILE="subdomains"
USE_TOR=false
OLD_DOMAINS_FILE="old_subdomains"
NEW_DOMAINS_FILE="new_subdomains"
API_OUTPUT_FILE="new_apis"

usage() {
    echo "Usage: $0 [--tor] [-I input_file] [-O output_file] [-cA old_domains_file] [--help|-H]"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --tor) USE_TOR=true ;;
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        -cA|--check-against) OLD_DOMAINS_FILE="$2"; shift ;;
        -H|--help) usage ;;
        *) usage ;;
    esac
    shift
done

# 1: Enumerate subdomains
subfinder -dL "$INPUT_FILE" | httprobe --prefer-https | anew "$OUTPUT_FILE"

# 2: Check for new subdomains
./check_new_subdomains.sh -I "$OUTPUT_FILE" -O "$NEW_DOMAINS_FILE" -cA "$OLD_DOMAINS_FILE" -aO "$API_OUTPUT_FILE"
