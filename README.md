File Integrity Checker - Usage Guide
This is a comprehensive guide to help you understand and use the File Integrity Checker system.

What is This Project?
The File Integrity Checker is a Bash-based tool that:

Creates baselines (snapshots) of directories and their files

Monitors changes to files by comparing against baselines

Generates reports categorizing changes by priority

Helps detect unauthorized or accidental modifications to critical files

How to Use the File Integrity Checker
1. Installation
Clone the repository and make the scripts executable:

bash
git clone [your-repository-url]
cd [repository-name]
chmod +x *.sh
2. Running the Tool
Start the main interface:

bash
./main.sh
For directories requiring admin privileges:

bash
sudo ./main.sh
3. Main Menu Options
The system provides three main functions:

Option 1: Create Baseline
Select option 1 from the menu

Enter the directory path you want to baseline

The system will create a baseline file in ./Baselines/

Example:

What are you looking to do today? Create Baseline(1) Run Check(2) Generate report(3)
1
Please enter a Directory to create a baseline of: 
/path/to/your/directory
Option 2: Run Integrity Check
Select option 2 from the menu

Confirm you want to proceed (y/n)

Enter the directory path to check against its baseline

The system will compare current state with baseline

Results are stored in ./Reports/temp_Report.txt

Example:

What are you looking to do today? Create Baseline(1) Run Check(2) Generate report(3)
2
WARNING! Running a check destroys any data stored in the temp_Reports file. Do you wish to continue? (y/n)
y
Please enter the Directory you want to check: 
/path/to/your/directory
Option 3: Generate Report
Select option 3 from the menu

Confirm you want to create a report (y/n)

Enter a name for your report

The system generates a formatted report in ./Reports/

Example:

What are you looking to do today? Create Baseline(1) Run Check(2) Generate report(3)
3
Would you like to create a report out of your temp_Reports file?(y/n)
y
Please name your report
my_report_2025
4. Demo Mode
The system includes a demo mode to test functionality:

bash
./demo_integrity_check.sh
This will:

Create test files and directories

Create a baseline

Make intentional changes

Run an integrity check

Generate a sample report

Understanding the Output
Reports categorize changes by priority:

High Priority Changes (Flags 2,4,5)
File permissions changes

Owner/group changes

Inode number changes

Medium Priority Changes (Flags 3,6)
Hard link count changes

File size changes

Low Priority Changes (Flag 9)
Timestamp modifications

Technical Details
Baseline Format: Stores file metadata (inode, permissions, owner, size, etc.)

Comparison Method: Compares 9 key fields between baseline and current state

Error Handling: Includes debug logging and path conversion for Windows compatibility

Modular Design: Separate scripts for baseline creation, checking, and reporting
