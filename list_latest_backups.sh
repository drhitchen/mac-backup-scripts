#!/bin/bash

# Variables
BACKUP_DIR=~/Backups
BACKUP_TYPES=("dotfiles" "config" "data")

# Ensure the backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Function to find and list the newest backup for a given type
list_newest_backup() {
    local backup_type=$1

    # Find the newest backup file for the given type
    newest_file=$(ls -t "$BACKUP_DIR"/${backup_type}_backup_*.tgz 2>/dev/null | head -n 1)

    if [[ -z "$newest_file" ]]; then
        echo "No backups found for type: $backup_type"
        return
    fi

    echo "Contents of the newest $backup_type backup ($newest_file):"
    # List the contents of the tarball
    gtar -tzvf "$newest_file"

    # Calculate file count and total size
    file_count=$(gtar -tzf "$newest_file" | wc -l)
    total_size=$(gtar -tzvf "$newest_file" | awk '{sum += $3} END {print sum}')
    echo "File count: $file_count"
    echo "Total size: $total_size bytes"
    echo "----------------------------------------"
}

# Check if a specific type is provided as an argument
if [[ -n $1 ]]; then
    if [[ " ${BACKUP_TYPES[*]} " == *" $1 "* ]]; then
        list_newest_backup "$1"
        exit 0
    else
        echo "Invalid backup type: $1"
        echo "Valid types are: ${BACKUP_TYPES[*]}"
        exit 1
    fi
fi

# Iterate through each backup type and list the newest backup
for backup_type in "${BACKUP_TYPES[@]}"; do
    list_newest_backup "$backup_type"
done
