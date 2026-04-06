#!/bin/bash

# Add debug output
echo "Starting RetroArchive update script..."
echo "Current directory: $(pwd)"
echo "User: $(whoami)"

# Set the destination directory
DEST_DIR="/userdata/roms/ports/RetroArchive"
echo "Destination: $DEST_DIR"

# Create necessary directories
mkdir -p "$DEST_DIR/assets/systems"

# Download the entire project as a zip file
echo "Downloading RetroArchive update..."
curl -L "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip" -o "/tmp/RetroArchive.zip"

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download RetroArchive update."
    exit 1
fi

# Extract the zip file
echo "Extracting update..."
unzip -o "/tmp/RetroArchive.zip" -d "/tmp/"

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Failed to extract RetroArchive update."
    exit 1
fi

# Copy all files to the destination
echo "Copying files..."
cp -r "/tmp/RetroArchive-main/"* "$DEST_DIR/"

# Make the main script executable
echo "Making scripts executable..."
chmod +x "$DEST_DIR/retroarchive"
chmod +x "$DEST_DIR/workingapps.sh"

# Create a launcher script for Batocera
echo "Creating launcher script..."
cat > "/userdata/roms/ports/RetroArchive.sh" << 'EOF'
#!/bin/bash
cd "/userdata/roms/ports/RetroArchive"
if [ -f "retroarchive" ]; then
    ./retroarchive
elif [ -f "workingapps.sh" ]; then
    ./workingapps.sh
else
    echo "Error: No executable found in RetroArchive directory"
    sleep 5
fi
EOF
chmod +x "/userdata/roms/ports/RetroArchive.sh"

# Clean up
echo "Cleaning up..."
rm -f "/tmp/RetroArchive.zip"
rm -rf "/tmp/RetroArchive-main"

echo "Installation complete! Find 'RetroArchive' in your Batocera ports section."