#!/bin/bash

INPUT_FILE="subdomains"
OUTPUT_FILE="new_subdomains"
OLD_DOMAINS_FILE="old_subdomains"
API_OUTPUT_FILE="new_apis"
NESSUS_OUTPUT_FILE="new_nessus_subdomains"

usage() {
    echo "Usage: $0 [-I input_file] [-O output_file] [-cA old_domains_file] [-aO api_output_file] [-nO nessus_output_file] [--help|-H]"
    echo "  -I,  --input          Specify the input file (default: wildcards)"
    echo "  -O,  --output         Specify the output file (default: subdomains)"
    echo "  -cA, --check-against  Specify the file to check against old domains"
    echo "  -aO, --api-output     Specify the API output file"
    echo "  -nO, --nessus-output  Specify the Nessus output file"
    echo "  -H,  --help           Display this help message"
    exit 1
}


while [[ "$#" -gt 0 ]]; do
    case $1 in
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        -cA|--check-against) OLD_DOMAINS_FILE="$2"; shift ;;
        -aO|--api-output) API_OUTPUT_FILE="$2"; shift ;;
        -nO|--nessus-output) NESSUS_OUTPUT_FILE="$2"; shift ;;
        -H|--help) usage ;;
        *) usage ;;
    esac
    shift
done

if [ ! -s "$INPUT_FILE" ]; then
    echo "The input file '$INPUT_FILE' is missing or empty."
    exit 1
fi
if [ ! -s "$OLD_DOMAINS_FILE" ]; then
    echo "The old domains file '$OLD_DOMAINS_FILE' is missing or empty."
    exit 1
fi

# Extract new subdomains
comm -13 <(sort "$OLD_DOMAINS_FILE") <(sort "$INPUT_FILE") | sort > "$OUTPUT_FILE"
if [ $? -ne 0 ]; then
    echo "Error during comparison of domains."
    exit 1
fi

# Filter for APIs
if grep -q "api" "$OUTPUT_FILE"; then
    grep "api" "$OUTPUT_FILE" > "$API_OUTPUT_FILE"
    echo "New domains have been saved to '$OUTPUT_FILE'."
    echo "New API domains have been saved to '$API_OUTPUT_FILE'."
else
    echo "No API domains found in '$OUTPUT_FILE'. No output file created."
fi

# comma-separeted domains with no protocol for nessus
sed 's|https\?://||g' "$OUTPUT_FILE" | paste -sd, - > "$NESSUS_OUTPUT_FILE"
