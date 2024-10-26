#!/bin/bash

INPUT_FILE="subdomains"
OUTPUT_FILE="new_subdomains"
OLD_DOMAINS_FILE="old_subdomains"
API_OUTPUT_FILE="new_apis"

usage() {
    echo "Usage: $0 [--input <input_file>] [--output <output_file>] [--check-against <old_domains_file>] [--api-output <api_output_file>] [--help|-H]"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        -cA|--check-against) OLD_DOMAINS_FILE="$2"; shift ;;
        -aO|--api-output) API_OUTPUT_FILE="$2"; shift ;;
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
grep "api" "$OUTPUT_FILE" > "$API_OUTPUT_FILE"
if [ $? -eq 0 ]; then
    echo "New domains have been saved to '$OUTPUT_FILE'."
    echo "New API domains have been saved to '$API_OUTPUT_FILE'."
fi
