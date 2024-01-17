#!/bin/bash
# (C) Copyright 2023-2024 Hewlett Packard Enterprise Development LP

set -o pipefail -o errexit -o nounset

if [[ ! -s low-medium-fs.log && ! -s low-medium-image.log ]]; then
    echo "ERROR: Both output files from trivy were zero bytes. This generally happens if trivy"
    echo "encounters an unhandled error such as an unsupported OS. Exiting with an error."
    echo "unsupported_os=1" >> "$GITHUB_OUTPUT"
    exit 1
fi
{
    grep -Eo 'LOW: [0-9]+' low-medium-fs.log low-medium-image.log | awk -F ': ' '{low+=$2} END {print "vulnerability_count_low="low}'
    grep -Eo 'MEDIUM: [0-9]+' low-medium-fs.log low-medium-image.log | awk -F ': ' '{medium+=$2} END {print "vulnerability_count_medium="medium}'
    grep -Eo 'UNKNOWN: [0-9]+' low-medium-fs.log low-medium-image.log | awk -F ': ' '{unknown+=$2} END {print "vulnerability_count_unknown="unknown}'
    if [[ -f .trivyignore ]]; then
       echo "vulnerability_count_ignored=$(grep -c '^\s*CVE' .trivyignore)"
    else
       echo "vulnerability_count_ignored=0"
    fi
}  >> "$GITHUB_OUTPUT"
