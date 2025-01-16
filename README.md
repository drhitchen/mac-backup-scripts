# mac-backup-scripts

A collection of bash scripts for managing backups and restores on macOS. These scripts help automate the backup and restoration of:
- Homebrew formulae and casks
- VSCode extensions and configurations
- Dotfiles, configuration files, and user data

## Features

- **Backup**:
  - Dotfiles, config files, and data with `gtar` and exclusion rules.
  - Installed Homebrew formulae and casks.
  - VSCode extensions and settings.
- **Restore**:
  - Restore Homebrew formulae and casks.
  - Restore VSCode extensions and settings.
  - Restore dotfiles, configuration files, and user data with options for specific backups.

## Prerequisites

- **Homebrew**: Install from [brew.sh](https://brew.sh/).
- **VSCode**: Install from [code.visualstudio.com](https://code.visualstudio.com/).
- **GNU Tar (`gtar`)**:
  ```bash
  brew install gnu-tar
  ```

## Installation

Clone the repository:
```bash
git clone https://github.com/<your-username>/mac-backup-scripts.git
cd mac-backup-scripts
```

Make all scripts executable:
```bash
chmod +x *.sh
```

## Usage

### 1. Backup

#### Homebrew
Backup Homebrew formulae and casks:
```bash
./backup_brew.sh [backup_dir]
```
- `backup_dir`: Optional. The directory where backups are saved (default: `~/Backups`).

#### Dotfiles, Config, and Data
Backup dotfiles, config files, and user data:
```bash
./backup_mac.sh [backup_type] [backup_dir]
```
- `backup_type`: Optional. One of `dotfiles`, `config`, or `data`. Backs up all types if omitted.
- `backup_dir`: Optional. Directory where backups are saved (default: `~/Backups`).

#### VSCode
Backup VSCode extensions and settings:
```bash
./backup_vscode.sh [backup_dir]
```
- `backup_dir`: Optional. Directory where backups are saved (default: `~/Backups`).

### 2. Restore

#### Homebrew
Restore Homebrew formulae and casks:
```bash
./restore_brew.sh [backup_dir] [formulae_file] [casks_file]
```
- `backup_dir`: Optional. Directory where backups are stored (default: `~/Backups`).
- `formulae_file`: Optional. Path to the Homebrew formulae file (default: latest in `backup_dir`).
- `casks_file`: Optional. Path to the Homebrew casks file (default: latest in `backup_dir`).

#### Dotfiles, Config, and Data
Restore dotfiles, config files, and data:
```bash
./restore_mac.sh <backup_type> [specific_path] [restore_dir] [backup_file]
```
- `backup_type`: Required. One of `dotfiles`, `config`, or `data`.
- `specific_path`: Optional. Specific file or folder to restore.
- `restore_dir`: Optional. Directory where files are restored (default: `~`).
- `backup_file`: Optional. Path to the backup file (default: latest in `backup_dir`).

#### VSCode
Restore VSCode extensions and settings:
```bash
./restore_vscode.sh [backup_dir] [extensions_file] [config_file]
```
- `backup_dir`: Optional. Directory where backups are stored (default: `~/Backups`).
- `extensions_file`: Optional. Path to the extensions file (default: latest in `backup_dir`).
- `config_file`: Optional. Path to the config file (default: latest in `backup_dir`).

### 3. List Backups
List the contents of the most recent backups:
```bash
./list_latest_backups.sh [backup_type]
```
- `backup_type`: Optional. One of `dotfiles`, `config`, or `data`. Lists all if omitted.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
