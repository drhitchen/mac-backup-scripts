#!/bin/bash

# Ensure GNU Tar is installed
if ! command -v gtar &> /dev/null; then
    echo "GNU Tar (gtar) not found. Please install it with Homebrew: brew install gnu-tar"
    exit 1
fi

# Variables
DEFAULT_BACKUP_DIR=~/Backups
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_TYPES=("dotfiles" "config" "data")

# Parse arguments
backup_type=$1
backup_dir=${2:-$DEFAULT_BACKUP_DIR}

# Ensure backup directory exists
if [[ ! -d "$backup_dir" ]]; then
    echo "Backup directory does not exist. Creating: $backup_dir"
    mkdir -p "$backup_dir"
fi

# Define exclusions
EXCLUDES=(
    --exclude=".DS_Store"
    --exclude="*.swp"
    --exclude="*.tmp"
    --exclude="*.iso"
    --exclude="*.mp4"
    --exclude="*.dmg"
    --exclude="*.part"
    --exclude="venv"
    --exclude="__pycache__"
    --exclude=".git"
    --exclude="$HOME/.vscode/extensions"
    --exclude="$HOME/Documents/Snagit"
)

# Define directories for config files and data
CONFIG_DIRS=(
    "$HOME/.config"
    "$HOME/.ssh"
    "$HOME/.oh-my-zsh"
    "$HOME/.gnupg"
    "$HOME/Library/Application Support"
)

DATA_DIRS=(
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/Pictures"
    "$HOME/Music"
    "$HOME/bin"
    "$HOME/scripts"
)

# Backup dotfiles from the home directory
backup_dotfiles() {
    local tar_file="$backup_dir/dotfiles_backup_$DATE.tgz"
    echo "Creating backup for dotfiles..."
    find "$HOME" -maxdepth 1 -type f -name ".*" -print0 | \
        gtar "${EXCLUDES[@]}" --null --files-from=- -czvf "$tar_file"
    echo "Dotfiles backup completed: $tar_file"
}

# Backup config files
backup_config() {
    local tar_file="$backup_dir/config_backup_$DATE.tgz"
    echo "Creating backup for config files..."
    gtar czvf "$tar_file" "${EXCLUDES[@]}" "${CONFIG_DIRS[@]}"
    echo "Config files backup completed: $tar_file"
}

# Backup data
backup_data() {
    local tar_file="$backup_dir/data_backup_$DATE.tgz"
    echo "Creating backup for data..."
    gtar czvf "$tar_file" "${EXCLUDES[@]}" "${DATA_DIRS[@]}"
    echo "Data backup completed: $tar_file"
}

# Check if a specific type is provided
if [[ -n $backup_type ]]; then
    if [[ " ${BACKUP_TYPES[*]} " == *" $backup_type "* ]]; then
        case $backup_type in
            dotfiles)
                backup_dotfiles
                ;;
            config)
                backup_config
                ;;
            data)
                backup_data
                ;;
        esac
        echo "Backup completed for type: $backup_type"
        exit 0
    else
        echo "Invalid backup type: $backup_type"
        echo "Valid types are: ${BACKUP_TYPES[*]}"
        exit 1
    fi
fi

# If no type is specified, perform all backups
backup_dotfiles
backup_config
backup_data

echo "All backups completed. Files saved in $backup_dir"
