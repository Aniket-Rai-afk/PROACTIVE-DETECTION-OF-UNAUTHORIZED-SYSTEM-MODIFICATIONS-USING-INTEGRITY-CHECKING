#!/bin/bash

convert_path() {
    local input_path="${1//\\//}"  # Convert backslashes to forward slashes
    input_path="${input_path//D:/\/d}"  # Convert D: to /d
    input_path="${input_path//C:/\/c}"  # Convert C: to /c
    echo "$input_path"
}

createBaseline() {
    # Convert and clean path
    BASEPATH=$(convert_path "$1")
    BASEPATH="${BASEPATH%\"}"
    BASEPATH="${BASEPATH#\"}"
    
    echo "Debug: Trying path: $BASEPATH"

    if [ ! -d "$BASEPATH" ]; then
        echo "Error: Directory not found: $BASEPATH"
        return 1
    fi

    # Create Baselines directory with safe path handling
    ABSPATH="$(pwd)/Baselines"
    mkdir -p "$ABSPATH" || {
        echo "Error: Could not create Baselines directory"
        return 1
    }

    # Generate safe filename
    file="$(basename "$BASEPATH")_baseline.txt"
    file="${file// /_}"  # Replace spaces with underscores

    # Check if baseline exists
    if [ -f "$ABSPATH/$file" ]; then
        echo "Notice: Baseline already exists at $ABSPATH/$file"
        return 0
    fi

    echo "Creating baseline for: $BASEPATH"
    baselineWrite "$BASEPATH" > "$ABSPATH/$file" || {
        echo "Error: Failed to create baseline file"
        return 1
    }

    echo "Success: Baseline created at $ABSPATH/$file"
}

baselineWrite() {
    find "$1" -exec ls -lid {} \; 2>/dev/null
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

createBaseline "$1"