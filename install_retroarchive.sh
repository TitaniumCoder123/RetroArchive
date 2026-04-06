#!/bin/bash

# Set the destination directory
DEST_DIR="/userdata/roms/ports/RetroArchive"
TEMP_DIR="/tmp/retroarchive_update"

# Create necessary directories
mkdir -p "$DEST_DIR/assets/systems"
mkdir -p "$TEMP_DIR"

# Download the entire project as a zip file
echo "Downloading RetroArchive update..."
curl -L "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip" -o "$TEMP_DIR/RetroArchive.zip"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download RetroArchive update."
    exit 1
fi

# Extract the zip file
echo "Extracting update..."
unzip -o "$TEMP_DIR/RetroArchive.zip" -d "$TEMP_DIR/"

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Failed to extract RetroArchive update."
    exit 1
fi

# Stop the running application if it's active
echo "Stopping running application..."
pkill -f "retroarchive"
pkill -f "workingapps.sh"
sleep 2

# Copy all files to the destination, preserving the directory structure
echo "Installing update..."
cp -rf "$TEMP_DIR/RetroArchive-main/"* "$DEST_DIR/"

# Make the main script executable
if [ -f "$DEST_DIR/retroarchive" ]; then
    chmod +x "$DEST_DIR/retroarchive"
fi

if [ -f "$DEST_DIR/retroarchive" ]; then
    chmod +x "$DEST_DIR/retroarchive"
fi

# Update the launcher script for Batocera
echo "Updating launcher script..."
cat > "/userdata/roms/ports/RetroArchive" << 'EOF'
#!/bin/bash
cd "/userdata/roms/ports/RetroArchive"
# Try to run the main executable, fall back to Python script if needed
if [ -f "retroarchive" ]; then
    ./retroarchive
elif [ -f "retroarchive" ]; then
    ./retroarchive
else
    echo "Error: No executable found in RetroArchive directory"
    sleep 5
fi
EOF

chmod +x "/userdata/roms/ports/RetroArchive/install_retroarchive.sh
chmod +x "/userdata/roms/ports/RetroArchive"

# Clean up
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Update complete! The application will restart automatically."
sleep 2

# Restart the application
cd "$DEST_DIR"
if [ -f "retroarchive" ]; then
    ./retroarchive &
elif [ -f "retroarchive" ]; then
    ./retroarchive &
fi