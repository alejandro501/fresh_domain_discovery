#!/bin/bash

setup_tor() {
    if [[ "$1" == true ]]; then
        export https_proxy=socks5://127.0.0.1:9050
        export http_proxy=socks5://127.0.0.1:9050
        echo "Running everything through Tor..."
    fi
}

usage() {
    echo "This is just a script to set up Tor proxy for the functions to run through it."
    exit 1
}

if [[ "$#" -gt 0 ]]; then
    case $1 in
        --help|-H) usage ;;
    esac
fi
