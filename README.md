# script components

## main
```sh
Usage: ./main.sh [--tor] [-I input_file] [-O output_file] [--help|-H]
  --tor              Run through Tor
  -I, --input        Specify the input file (default: wildcards)
  -O, --output       Specify the output file (default: subdomains)
  --help, -H         Display this help message
```

## enumerate subdomains
```sh
Usage: ./enumerate_subdomains.sh [-I input_file] [-O output_file] [--tor] [--help|-H]
  -I, --input        Specify the input file (default: wildcards)
  -O, --output       Specify the output file (default: subdomains)
  --tor              Run through Tor
  --help, -H         Display this help message
```

## check new subdomains
```sh
Usage: ./check_new_domains.sh [--input <input_file>] [--output <output_file>] [--check-against <old_domains_file>] [--help|-H]
  --input, -I        Specify the input file (default: domains.txt)
  --output, -O       Specify the output file (default: new_domains.txt)
  --check-against, -cA Specify the old domains file to check against (default: old_domains.txt)
  --help, -H         Display this help message
```

## utils

### set up tor
```sh
This is just a script to set up Tor proxy for the functions to run through it.
```