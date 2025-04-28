#!/bin/bash

# Debug: Log start time
echo "Check started at $(date)" >> debug.log

function change_check() {
    echo "Running integrity check..."
    
    BASELINE_FILE="./Baselines/${1}_baseline.txt"
    [ ! -f "$BASELINE_FILE" ] && {
        echo "Error: Baseline file missing"
        return 1
    }
    
    mkdir -p ./Reports
    > ./Reports/temp_Report.txt

    # Create current snapshot
    TARGET_DIR=$(head -1 "$BASELINE_FILE" | awk '{for(i=10;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//')
    find "$TARGET_DIR" -exec ls -lid {} \; > temp.txt 2>>debug.log || {
        echo "Error: Failed to create temp snapshot"
        return 1
    }

    total_files=$(wc -l < "$BASELINE_FILE")
    
    for FIELD in 2 4 5 6 9; do
        current_file=0
        echo -n "Checking field $FIELD: "
        
        while IFS= read -r BASE_REC; do
            ((current_file++))
            echo -ne "\rChecking field $FIELD: $current_file/$total_files files"
            
            CURRENT_REC=$(sed -n "${current_file}p" temp.txt)
            BASE_VAL=$(echo "$BASE_REC" | awk -v f="$FIELD" '{print $f}')
            CURRENT_VAL=$(echo "$CURRENT_REC" | awk -v f="$FIELD" '{print $f}')

            [ "$BASE_VAL" != "$CURRENT_VAL" ] && {
                FILE_PATH=$(echo "$BASE_REC" | awk '{for(i=10;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//')
                echo "Change detected in Flag $FIELD at: $FILE_PATH" >> ./Reports/temp_Report.txt
            }
        done < "$BASELINE_FILE"
        
        echo -e " \xE2\x9C\x93"  # Show checkmark
    done
    
    rm -f temp.txt
    echo "Check completed"
}

spotDiff() {
    local i=1
    while IFS= read -r BASE_REC; do
        CURRENT_REC=$(sed -n "${i}p" "$2")
        
        BASE_VAL=$(echo "$BASE_REC" | awk -v field="$3" '{print $field}')
        CURRENT_VAL=$(echo "$CURRENT_REC" | awk -v field="$3" '{print $field}')

        if [ "$BASE_VAL" != "$CURRENT_VAL" ]; then
            FILE_PATH=$(echo "$BASE_REC" | awk '{for(i=10;i<=NF;i++) printf "%s ",$i; print ""}' | sed 's/ $//')
            echo "Change detected in Flag $3 at: $FILE_PATH (Was: $BASE_VAL | Now: $CURRENT_VAL)" >> ./Reports/temp_Report.txt
        fi
        ((i++))
    done < "$1"
}

change_check "$(echo "$1" | sed 's/"//g')"  # Remove any quotes