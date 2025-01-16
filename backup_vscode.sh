#!/bin/bash

# Default backup directory
DEFAULT_BACKUP_DIR=~/Backups
DATE=$(date +%Y%m%d_%H%M%S)

# Parse optional destination folder
BACKUP_DIR=${1:-$DEFAULT_BACKUP_DIR}

# Ensure backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory does not exist. Creating: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# Backup VSCode extensions
EXTENSIONS_FILE="$BACKUP_DIR/vscode_extensions_$DATE.txt"
echo "Backing up VSCode extensions..."
code --list-extensions > "$EXTENSIONS_FILE"

# Backup VSCode settings
CONFIG_FILE="$BACKUP_DIR/vscode_config_$DATE.json"
echo "Backing up VSCode settings..."
cp "$HOME/Library/Application Support/Code/User/settings.json" "$CONFIG_FILE"

# Output message
echo "Backup completed. Files saved in $BACKUP_DIR:"
echo "- Extensions: $EXTENSIONS_FILE"
echo "- Settings: $CONFIG_FILE"
