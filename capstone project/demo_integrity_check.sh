#!/bin/bash

# Initialize
clear
mkdir -p test_demo
cd test_demo || exit

echo "=== FILE INTEGRITY CHECK DEMO ==="
echo "1. Creating test files..."
echo "Original content" > test_file.txt
mkdir test_dir
echo "Another file" > test_dir/file2.txt

echo "2. Creating baseline..."
../main.sh 1 "$PWD"

echo "3. Making changes..."
chmod 777 test_file.txt              # Permission (Flag 2)
echo "Modified" >> test_dir/file2.txt # Size (Flag 6)
touch -a test_file.txt               # Timestamp (Flag 9)

echo "4. Running integrity check..."
../main.sh 2 "$PWD"

echo "5. Generating report..."
echo "=== FINAL REPORT ==="
../main.sh 3
cat ../Reports/temp_Report.txt

# Cleanup (optional)
cd ..
# rm -rf test_demo