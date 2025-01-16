#!/bin/bash

# Variables
BACKUP_DIR=~/Backups
BACKUP_TYPES=("dotfiles" "config" "data")
RESTORE_DIR=~ # Default restore location

# Ensure the backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Function to restore a backup
restore_backup() {
    local backup_type=$1
    local target_dir=$2
    local specific_path=$3
    local specified_backup=$4

    # Determine the backup file to restore from
    if [[ -n $specified_backup ]]; then
        backup_file="$specified_backup"
        if [[ ! -f $backup_file ]]; then
            echo "Specified backup file does not exist: $backup_file"
            exit 1
        fi
    else
        # Find the newest backup file for the given type
        backup_file=$(ls -t "$BACKUP_DIR"/${backup_type}_backup_*.tgz 2>/dev/null | head -n 1)
        if [[ -z $backup_file ]]; then
            echo "No backups found for type: $backup_type"
            exit 1
        fi
    fi

    echo "Restoring from $backup_file..."

    # Ensure the target directory exists
    if [[ ! -d $target_dir ]]; then
        echo "Target directory does not exist. Creating: $target_dir"
        mkdir -p "$target_dir"
    fi

    # If a specific path is provided, extract only that path
    if [[ -n $specific_path ]]; then
        echo "Restoring specific path: $specific_path"
        tar -xzvf "$backup_file" -C "$target_dir" --wildcards "$specific_path"
    else
        # Restore all contents
        echo "Restoring all contents to $target_dir"
        tar -xzvf "$backup_file" -C "$target_dir"
    fi

    echo "Restore for $backup_type completed."
    echo "----------------------------------------"
}

# Parse arguments
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <backup_type> [specific_path] [restore_dir] [specified_backup]"
    echo "Backup types: ${BACKUP_TYPES[*]}"
    exit 1
fi

backup_type=$1
specific_path=$2
restore_dir=${3:-$RESTORE_DIR}
specified_backup=$4

# Check if the provided backup type is valid
if [[ ! " ${BACKUP_TYPES[*]} " == *" $backup_type "* ]]; then
    echo "Invalid backup type: $backup_type"
    echo "Valid types: ${BACKUP_TYPES[*]}"
    exit 1
fi

# Perform the restore
restore_backup "$backup_type" "$restore_dir" "$specific_path" "$specified_backup"
