#!/bin/bash -
# Author:       Christo Deale                  
# Date  :       2023-12-19            
# LogsRetention: Utility to Archive logs older than 3months

# Directory to store archived logs
ARCHIVE_DIR="/ArchiveLogs"

# List of log files to archive
LOG_FILES=(
    "/var/log/messages"
    "/var/log/secure"
    "/var/log/syslog"
    "/var/log/httpd/error_log"
    "/var/log/mysql/error.log"
)

# Create the ArchiveLogs directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Current date in YYYYMMDD format
CURRENT_DATE=$(date "+%Y%m%d")

# Calculate the date 3 months ago
THREE_MONTHS_AGO=$(date -d "3 months ago" "+%Y%m%d")

for log_file in "${LOG_FILES[@]}"; do
    # Check if the log file exists
    if [ -f "$log_file" ]; then
        # Find and archive logs older than 3 months
        find "$log_file" -type f -mtime +90 -exec sh -c 'tar -caf "$1/$(basename "$2")_'"$THREE_MONTHS_AGO"'_'"$CURRENT_DATE"'.tar.xz" -C "$1" "$(basename "$2")"' _ "$ARCHIVE_DIR/$(basename $(dirname "$log_file"))" {} \;
    fi
done
