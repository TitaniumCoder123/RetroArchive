#!/bin/bash

# Create necessary directories
mkdir -p "/userdata/roms/ports/RetroArchive/assets/systems"

# Stop any running instances before updating
echo "Stopping running RetroArchive instances..."
pkill -f "retroarchive" || true
pkill -f "workingapps.sh" || true

# Wait longer for processes to fully terminate
sleep 5

# Force kill any remaining processes
pkill -9 -f "retroarchive" || true
pkill -9 -f "workingapps.sh" || true
sleep 2

# Download the entire project as a zip file using wget
echo "Downloading latest version..."
wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
     --no-check-certificate \
     --timeout=30 \
     -O "/tmp/RetroArchive.zip" \
     "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip"

# Extract the zip file
echo "Extracting files..."
unzip -o "/tmp/RetroArchive.zip" -d "/tmp/"

# Remove old files except for critical directories and the installer script
echo "Removing old files..."
find "/userdata/roms/ports/RetroArchive" -mindepth 1 -maxdepth 1 \
    ! -name "downloads" \
    ! -name "torrent_library" \
    ! -name "settings.json" \
    ! -name "install.sh" \
    -exec rm -rf {} +

# Force copy all files to the destination (overwrite existing files)
echo "Copying new files..."
cp -rf "/tmp/RetroArchive-main/"* "/userdata/roms/ports/RetroArchive/"

# Make the main scripts executable
echo "Setting executable permissions..."
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/retroarchive"
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/workingapps.sh"

# Create/update the launcher script for Batocera
echo "Creating launcher script..."
cat > "/userdata/roms/ports/RetroArchive.sh" << 'EOF'
#!/bin/bash
cd "/userdata/roms/ports/RetroArchive/retroarchive"
export DISPLAY=:0.0
./retroarchive
EOF

# Make the launcher script executable
chmod +x "/userdata/roms/ports/RetroArchive.sh"

# Update version file
if [ -f "/tmp/RetroArchive-main/retroarchive/version.txt" ]; then
    cp "/tmp/RetroArchive-main/retroarchive/version.txt" "/userdata/roms/ports/RetroArchive/retroarchive/version.txt"
fi

# Clean up
echo "Cleaning up..."
rm -f "/tmp/RetroArchive.zip"
rm -rf "/tmp/RetroArchive-main"

# Self-delete this installer script to prevent it from showing up in the menu
echo "Removing installer script..."
rm -f "$0" || echo "Could not remove installer script"

echo "Installation complete! Find 'RetroArchive' in your Batocera ports section."