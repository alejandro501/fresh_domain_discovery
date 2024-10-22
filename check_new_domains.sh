#!/bin/bash

INPUT_FILE="subdomains"
OUTPUT_FILE="new_subdomains"
OLD_DOMAINS_FILE="old_subdomains"

usage() {
    echo "Usage: $0 [--input <input_file>] [--output <output_file>] [--check-against <old_domains_file>] [--help|-H]"
    echo "  --input, -I        Specify the input file (default: domains.txt)"
    echo "  --output, -O       Specify the output file (default: new_domains.txt)"
    echo "  --check-against, -cA Specify the old domains file to check against (default: old_domains.txt)"
    echo "  --help, -H         Display this help message"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -I|--input) INPUT_FILE="$2"; shift ;;
        -O|--output) OUTPUT_FILE="$2"; shift ;;
        -cA|--check-against) OLD_DOMAINS_FILE="$2"; shift ;;
        -H|--help) usage ;;
        *) usage ;;
    esac
    shift
done

if [ ! -f "$INPUT_FILE" ]; then
    echo "The input file '$INPUT_FILE' does not exist."
    exit 1
fi

if [ ! -f "$OLD_DOMAINS_FILE" ]; then
    echo "The old domains file '$OLD_DOMAINS_FILE' does not exist."
    exit 1
fi

comm -13 <(sort "$OLD_DOMAINS_FILE") <(sort "$INPUT_FILE") | sort > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "New domains have been saved to '$OUTPUT_FILE'."
else
    echo "An error occurred during comparison."
fi
