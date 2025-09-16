# DonkeyCar Simulator

A Docker setup for running the DonkeyCar Unity simulator with virtual display support.

## Quick Start

1. **Start the simulator:**
   ```bash
   docker-compose up --build
   ```

2. **Access the web interface:**
   - Open http://localhost:8887 in your browser
   - Use the interface to control the car manually

3. **Stop the simulator:**
   - Press `Ctrl+C` in the terminal

## What's Included

- **DonkeyCar Unity Simulator** - 3D racing environment
- **Virtual Display** - Runs headlessly without GUI requirements  
- **Web Interface** - Manual car control at http://localhost:8887
- **Gym Integration** - Programmatic access via port 9091

## How the Visual Solution Works

The Unity simulator requires a display to run, but Docker containers typically run headless. This setup solves it by:

1. **Xvfb Virtual Display** - Creates a "fake" screen inside the container (1024x768)
2. **Unity Renders Normally** - The 3D simulator runs with full GUI, rendering to the virtual screen
3. **Web Interface Access** - Instead of seeing Unity directly, you control the car through a web browser at http://localhost:8887

This way, the GUI application runs completely inside the container while you interact with it through the web interface.

## Files

- `docker-compose.yml` - Container configuration with port mapping
- `Dockerfile` - Complete simulator setup with virtual display
- `start_with_display.sh` - Startup script that creates virtual display
- `data/` - Directory for training data storage (data saving disabled)

## Usage

The simulator is ready for:
- Manual driving via web interface
- Training data collection
- Autonomous vehicle development
- Gym-donkeycar integration

The server runs at 20 Hz and automatically handles display requirements using Xvfb virtual display.
# DonkeyCar-Docker
