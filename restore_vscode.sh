#!/bin/bash

# Default backup directory
DEFAULT_BACKUP_DIR=~/Backups

# Parse arguments
BACKUP_DIR=${1:-$DEFAULT_BACKUP_DIR}
EXTENSIONS_FILE=${2:-$(ls -t "$BACKUP_DIR"/vscode_extensions_*.txt 2>/dev/null | head -n 1)}
CONFIG_FILE=${3:-$(ls -t "$BACKUP_DIR"/vscode_config_*.json 2>/dev/null | head -n 1)}

# Ensure backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Ensure backup files exist
if [[ ! -f "$EXTENSIONS_FILE" || ! -f "$CONFIG_FILE" ]]; then
    echo "Backup files not found or invalid."
    echo "Usage: $0 [backup_dir] [extensions_file] [config_file]"
    exit 1
fi

# Restore VSCode extensions
echo "Restoring VSCode extensions from $EXTENSIONS_FILE..."
while read -r extension; do
    [[ -z "$extension" ]] && continue # Skip empty lines
    code --install-extension "$extension" || echo "Failed to install: $extension"
done < "$EXTENSIONS_FILE"

# Restore VSCode settings
echo "Restoring VSCode settings from $CONFIG_FILE..."
cp "$CONFIG_FILE" "$HOME/Library/Application Support/Code/User/settings.json"

echo "Restore completed."
