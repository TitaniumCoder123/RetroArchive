#!/bin/bash

# Safe update script for RetroArchive
echo "Starting RetroArchive update process..."

# Create necessary directories
mkdir -p "/userdata/roms/ports/RetroArchive/assets/systems"

# Download the entire project as a zip file
echo "Downloading latest version..."
if ! curl -L "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip" -o "/tmp/RetroArchive.zip"; then
    echo "Failed to download update"
    exit 1
fi

# Extract the zip file
echo "Extracting files..."
if ! unzip -o "/tmp/RetroArchive.zip" -d "/tmp/"; then
    echo "Failed to extract update"
    exit 1
fi

# Copy files without removing anything first (safer approach)
echo "Copying new files..."
cp -rf "/tmp/RetroArchive-main/retroarchive/"* "/userdata/roms/ports/RetroArchive/retroarchive/"

# Make the main scripts executable
echo "Setting executable permissions..."
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/retroarchive"
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/workingapps.sh"

# Update version file
if [ -f "/tmp/RetroArchive-main/retroarchive/version.txt" ]; then
    cp "/tmp/RetroArchive-main/retroarchive/version.txt" "/userdata/roms/ports/RetroArchive/retroarchive/version.txt"
fi

# Clean up
echo "Cleaning up..."
rm -f "/tmp/RetroArchive.zip"
rm -rf "/tmp/RetroArchive-main"

echo "Update complete! Restart RetroArchive to use the new version."