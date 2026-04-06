#!/bin/bash

# Create necessary directories
mkdir -p "/userdata/roms/ports/RetroArchive/assets/systems"

# Stop any running instances before updating
pkill -f "retroarchive" || true
pkill -f "workingapps.sh" || true
sleep 2

# Download the entire project as a zip file
curl -L "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip" -o "/tmp/RetroArchive.zip"

# Extract the zip file
unzip -o "/tmp/RetroArchive.zip" -d "/tmp/"

# Force copy all files to the destination (overwrite existing files)
cp -rf "/tmp/RetroArchive-main/"* "/userdata/roms/ports/RetroArchive/"

# Make the main scripts executable
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/retroarchive"
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive/workingapps.sh"

# Create/update the launcher script for Batocera
cat > "/userdata/roms/ports/RetroArchive.sh" << 'EOF'
#!/bin/bash
cd "/userdata/roms/ports/RetroArchive/retroarchive"
export DISPLAY=:0.0
./workingapps.sh
EOF

# Make the launcher script executable
chmod +x "/userdata/roms/ports/RetroArchive.sh"

# Clean up
rm -f "/tmp/RetroArchive.zip"
rm -rf "/tmp/RetroArchive-main"

echo "Installation complete! Find 'RetroArchive' in your Batocera ports section."