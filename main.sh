#!/bin/bash

source ./setup_tor.sh

INPUT_FILE="wildcards"
OUTPUT_FILE="subdomains"
USE_TOR=false

usage() {
    echo "Usage: $0 [--tor] [-I input_file] [-O output_file] [--help|-H]"
    echo "  --tor              Run through Tor"
    echo "  -I, --input        Specify the input file (default: $INPUT_FILE)"
    echo "  -O, --output       Specify the output file (default: $OUTPUT_FILE)"
    echo "  --help, -H         Display this help message"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --tor) USE_TOR=true ;;
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        -H|--help) usage ;;
        *) usage ;;
    esac
    shift
done

setup_tor "$USE_TOR"

./enumerate_subdomains.sh -I "$INPUT_FILE" -O "$OUTPUT_FILE" --tor "$USE_TOR"
./check_new_subdomains.sh
