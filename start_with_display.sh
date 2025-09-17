#!/bin/bash
# Start virtual display for headless operation
echo "Starting virtual display..."
Xvfb :99 -screen 0 1024x768x24 -ac &
export DISPLAY=:99

# Wait for display to be ready
echo "Waiting for display to initialize..."
sleep 3

# Verify display is working
echo "Testing display..."
if xset q >/dev/null 2>&1; then
    echo "✓ Virtual display is working"
else
    echo "✗ Virtual display failed to start"
    exit 1
fi

# Start the donkey car application
echo "Starting DonkeyCar simulator..."
cd /app/mysim
python manage.py drive
