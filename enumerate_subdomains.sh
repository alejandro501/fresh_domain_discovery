#!/bin/bash

INPUT_FILE="wildcards"
OUTPUT_FILE="subdomains"
USE_TOR=false

usage() {
    echo "Usage: $0 [-I input_file] [-O output_file] [--tor] [--help|-H]"
    echo "  -I, --input        Specify the input file (default: wildcards)"
    echo "  -O, --output       Specify the output file (default: subdomains)"
    echo "  --tor              Run through Tor"
    echo "  --help, -H         Display this help message"
    exit 1
}

check_commands() {
    for cmd in subfinder httprobe; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "$cmd is not installed. Please install it first."
            exit 1
        fi
    done
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        --tor) USE_TOR=true ;;
        -H|--help) usage ;;
        *) usage ;;
    esac
    shift
done

if [ "$USE_TOR" = true ]; then
    export https_proxy=socks5://127.0.0.1:9050
    export http_proxy=socks5://127.0.0.1:9050
    echo "Running everything through Tor..."
fi

enumerate_subdomains() {
    check_commands

    if [ ! -f "$INPUT_FILE" ]; then
        echo "The input file '$INPUT_FILE' does not exist."
        exit 1
    fi

    echo "Starting subdomain enumeration..."

    mapfile -t domains < "$INPUT_FILE"
    : > temp_subdomains.txt

    for domain in "${domains[@]}"; do
        echo "Finding subdomains for: $domain"
        subfinder -d "$domain" -all | tee -a temp_subdomains.txt | sort -u

        if [[ $? -ne 0 ]]; then
            echo "Error occurred while finding subdomains for $domain."
        fi
    done

    echo "Probing live subdomains..."
    httprobe -c 50 --prefer-https < temp_subdomains.txt | anew "$OUTPUT_FILE"

    rm temp_subdomains.txt

    echo "Subdomain enumeration completed."
    echo "Results saved in '$OUTPUT_FILE'."
}

enumerate_subdomains
