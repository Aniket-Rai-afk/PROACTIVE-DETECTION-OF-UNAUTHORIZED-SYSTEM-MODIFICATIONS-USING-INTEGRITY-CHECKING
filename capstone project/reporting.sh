#!/bin/bash

function print_section() {
    case $1 in
        "HIGH PRIORITY CHANGES")
            grep "Flag [245]" ./Reports/temp_Report.txt
            ;;
        "MEDIUM PRIORITY CHANGES")
            grep "Flag [36]" ./Reports/temp_Report.txt
            ;;
        "LOW PRIORITY CHANGES")
            grep "Flag [9]" ./Reports/temp_Report.txt | uniq  # Remove duplicate timestamp entries
            ;;
    esac
}

createReport() {
    echo "=== FILE INTEGRITY REPORT ==="
    echo "Generated: $(date)"
    echo "Baseline: $(ls ./Baselines/*_baseline.txt)"
    echo "============================"

    print_section "HIGH PRIORITY CHANGES" "Flag [245]"
    print_section "MEDIUM PRIORITY CHANGES" "Flag 6"
    print_section "LOW PRIORITY CHANGES" "Flag 9"

    [ ! -s ./Reports/temp_Report.txt ] && echo "No changes detected in any category"
}

createReport