#!/bin/bash

# Parse arguments
BACKUP_FILE=$1
RESTORE_DIR=${2:-~}          # Default restore directory
CONFIRM=${3:-true}           # Default to true for prompting

# Validate backup file
if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "Backup file not found: $BACKUP_FILE"
    echo "Usage: $0 <backup_file> [restore_dir] [confirm]"
    exit 1
fi

# Ensure the restore directory exists
if [[ ! -d "$RESTORE_DIR" ]]; then
    echo "Restore directory does not exist. Creating: $RESTORE_DIR"
    mkdir -p "$RESTORE_DIR"
fi

# Function to handle folder removal based on confirmation setting
handle_existing_folder() {
    local folder=$1
    local repo_url=$2

    if [[ "$CONFIRM" == "true" ]]; then
        # Prompt the user
        echo "Directory $folder exists. Remove it to clone $repo_url? (y/N): "
        read -r confirm </dev/tty
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "Removing existing directory: $folder"
            rm -rf "$folder"
            return 0
        else
            echo "Skipping $repo_url..."
            return 1
        fi
    else
        # Automatically remove without prompting
        echo "Removing existing directory: $folder"
        rm -rf "$folder"
        return 0
    fi
}

# Read the backup file and restore repositories
while read -r line; do
    # Skip comments
    [[ "$line" =~ ^#.*$ ]] && continue

    # Check for `mkdir` and `git clone` commands
    if [[ "$line" =~ ^mkdir\ -p\ \"\$RESTORE_DIR/(.*)\"$ ]]; then
        relative_path=${BASH_REMATCH[1]}
        mkdir -p "$RESTORE_DIR/$relative_path"
    elif [[ "$line" =~ ^git\ clone\ (.*)\ \"\$RESTORE_DIR/(.*)\"$ ]]; then
        repo_url=${BASH_REMATCH[1]}
        target_path=${BASH_REMATCH[2]}

        # If the target folder exists, handle it based on confirmation setting
        if [[ -d "$RESTORE_DIR/$target_path" ]]; then
            if ! handle_existing_folder "$RESTORE_DIR/$target_path" "$repo_url"; then
                continue
            fi
        fi

        # Clone the repository
        echo "Cloning $repo_url into $RESTORE_DIR/$target_path..."
        git clone "$repo_url" "$RESTORE_DIR/$target_path"
    fi
done < "$BACKUP_FILE"

echo "Restore completed."
