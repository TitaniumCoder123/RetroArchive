#!/bin/bash

# Create necessary directories
mkdir -p "/userdata/roms/ports/RetroArchive/assets/systems"

# Download the entire project as a zip file
curl -L "https://github.com/TitaniumCoder123/RetroArchive/archive/refs/heads/main.zip" -o "/tmp/RetroArchive.zip"

# Extract the zip file
unzip -o "/tmp/RetroArchive.zip" -d "/tmp/"

# Copy all files to the destination
cp -r "/tmp/RetroArchive-main/"* "/userdata/roms/ports/RetroArchive/"

# Make the main script executable
chmod +x "/userdata/roms/ports/RetroArchive/retroarchive"

# Create a launcher script for Batocera
cat > "/userdata/roms/ports/RetroArchive.sh" << 'EOF'
#!/bin/bash
chmod +x /userdata/roms/ports/RetroArchive/retroarchive/retroarchive
cd /userdata/roms/ports/RetroArchive/retroarchive && export DISPLAY=:0.0; ./workingapps.sh
# Try to run the main executable, fall back to Python script if needed

fi
EOF
chmod +x "/userdata/roms/ports/RetroArchive.sh"

# Clean up
rm -f "/tmp/RetroArchive.zip"
rm -rf "/tmp/RetroArchive-main"

echo "Installation complete! Find 'RetroArchive' in your Batocera ports section."