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

# Generate list of installed Homebrew formulae
echo "Backing up Homebrew formulae..."
brew list --formula > "$BACKUP_DIR/brew_formulae_$DATE.txt"

# Generate list of installed Homebrew casks
echo "Backing up Homebrew casks..."
brew list --cask > "$BACKUP_DIR/brew_casks_$DATE.txt"

# Output message
echo "Backup completed. Lists saved in $BACKUP_DIR:"
echo "- Formulae: $BACKUP_DIR/brew_formulae_$DATE.txt"
echo "- Casks: $BACKUP_DIR/brew_casks_$DATE.txt"
