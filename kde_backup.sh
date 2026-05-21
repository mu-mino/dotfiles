#!/bin/bash

# Config
BACKUP_DIR="$HOME/dotfiles/kde_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="kde_config_backup_$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# Files and folders to back up
CONFIG_PATHS=(
  "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
  "$HOME/.config/kdeglobals"
  "$HOME/.config/kwinrc"
  "$HOME/.config/kglobalshortcutsrc"
  "$HOME/.config/kscreenlockerrc"
  "$HOME/.config/ksmserverrc"
  "$HOME/.config/krunnerrc"
  "$HOME/.config/dolphinrc"
  "$HOME/.config/konsolerc"
  "$HOME/.config/systemsettingsrc"
  "$HOME/.config/autostart"
  "$HOME/.local/share/plasma"
  "$HOME/.local/share/icons"
  "$HOME/.local/share/aurorae"
  "$HOME/.local/share/konsole"
  "$HOME/.local/share/kwin/scripts"
  "$HOME/.local/share/wallpapers"
  "$HOME/.local/share/knewstuff3"
  "$HOME/.local/share/fonts"
  "$HOME/.bashrc"
  "$HOME/.zshrc"
)

# Create backup directory if needed
mkdir -p "$BACKUP_DIR"

# Create archive
echo "Creating KDE config backup at: $ARCHIVE_PATH"
tar -czf "$ARCHIVE_PATH" "${CONFIG_PATHS[@]}" 2>/dev/null

if [ $? -eq 0 ]; then
  echo " Backup successful!"
else
  echo " Backup failed. Check for missing files or permissions."
fi
