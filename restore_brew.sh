#!/bin/bash

# Default backup directory
DEFAULT_BACKUP_DIR=~/Backups

# Parse arguments
BACKUP_DIR=${1:-$DEFAULT_BACKUP_DIR}
FORMULAE_FILE=${2:-$(ls -t "$BACKUP_DIR"/brew_formulae_*.txt 2>/dev/null | head -n 1)}
CASKS_FILE=${3:-$(ls -t "$BACKUP_DIR"/brew_casks_*.txt 2>/dev/null | head -n 1)}

# Ensure backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Ensure formulae and cask files exist
if [[ ! -f "$FORMULAE_FILE" || ! -f "$CASKS_FILE" ]]; then
    echo "Backup files not found or invalid."
    echo "Usage: $0 [backup_dir] [formulae_file] [casks_file]"
    exit 1
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Restore formulae
echo "Restoring formulae from $FORMULAE_FILE..."
while read -r formula; do
    [[ -z "$formula" ]] && continue # Skip empty lines
    brew install "$formula" || echo "Failed to install: $formula"
done < "$FORMULAE_FILE"

# Restore casks
echo "Restoring casks from $CASKS_FILE..."
while read -r cask; do
    [[ -z "$cask" ]] && continue # Skip empty lines
    brew install --cask "$cask" || echo "Failed to install: $cask"
done < "$CASKS_FILE"

echo "Restore completed."
