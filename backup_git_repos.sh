#!/bin/bash

# Default backup directory
DEFAULT_BACKUP_DIR=~/Backups
DATE=$(date +%Y%m%d_%H%M%S)

# Parse arguments
SEARCH_DIR=${1:-~}
BACKUP_DIR=${2:-$DEFAULT_BACKUP_DIR}
OUTPUT_FILE="$BACKUP_DIR/github_repos_backup_$DATE.sh"

# Ensure backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory does not exist. Creating: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# Function to calculate relative path
get_relative_path() {
    local target=$1
    local base=$2
    perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1]);' "$target" "$base"
}

# Find all Git repositories and store their relative paths
echo "#!/bin/bash" > "$OUTPUT_FILE"
echo "# Restore GitHub repositories backup script" >> "$OUTPUT_FILE"
echo "# Generated on $DATE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Searching for Git repositories in $SEARCH_DIR (skipping .venv and .cache)..."
find "$SEARCH_DIR" -type d \( -name ".venv" -o -name ".cache" \) -prune -o -type d -name ".git" -print | while read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    relative_path=$(get_relative_path "$repo_dir" "$SEARCH_DIR")
    pushd "$repo_dir" > /dev/null || continue
    remote_url=$(git config --get remote.origin.url)
    if [[ -n "$remote_url" ]]; then
        echo "# Clones into: $relative_path" >> "$OUTPUT_FILE"
        echo "mkdir -p \"\$RESTORE_DIR/$relative_path\"" >> "$OUTPUT_FILE"
        echo "git clone $remote_url \"\$RESTORE_DIR/$relative_path\"" >> "$OUTPUT_FILE"
    fi
    popd > /dev/null || continue
done

chmod +x "$OUTPUT_FILE"

echo "Backup script generated: $OUTPUT_FILE"
