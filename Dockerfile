# Use Ubuntu base image with Python 3.11
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies including X11 for virtual display
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    build-essential \
    xvfb \
    x11-utils \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

# Download and extract DonkeyCAR simulator
RUN wget https://github.com/tawnkramer/gym-donkeycar/releases/download/v22.11.06/DonkeySimLinux.zip
RUN unzip DonkeySimLinux.zip -d DonkeySimLinux

# Set working directory to simulator location
WORKDIR /app/DonkeySimLinux/DonkeySimLinux

# Make simulator executable
RUN chmod +x donkey_sim.x86_64

# Go back to app directory
WORKDIR /app

# Create and activate virtual environment with Python 3.11
RUN python -m venv donkey

# Activate virtual environment and install donkeycar
RUN /app/donkey/bin/pip install --upgrade pip
RUN /app/donkey/bin/pip install donkeycar[pc]

# Clone gym-donkeycar repository
RUN git clone https://github.com/tawnkramer/gym-donkeycar
WORKDIR /app/gym-donkeycar

# Install gym-donkeycar in development mode
RUN /app/donkey/bin/pip install -e .[gym-donkeycar]

# Go back to app directory
WORKDIR /app

# Create donkey car configuration
RUN /app/donkey/bin/donkey createcar --path /app/mysim

# Set working directory to car configuration
WORKDIR /app/mysim

# Copy and modify myconfig.py to enable simulator
RUN sed -i 's/DONKEY_GYM = False/DONKEY_GYM = True/' myconfig.py || echo "DONKEY_GYM = True" >> myconfig.py
RUN echo 'DONKEY_SIM_PATH = "/app/DonkeySimLinux/DonkeySimLinux/donkey_sim.x86_64"' >> myconfig.py
RUN echo 'DONKEY_GYM_ENV_NAME = "donkey-generated-track-v0"' >> myconfig.py

# Also add the configuration directly to config.py as a fallback
RUN echo '' >> config.py
RUN echo '# Simulator configuration' >> config.py
RUN echo 'DONKEY_GYM = True' >> config.py
RUN echo 'DONKEY_SIM_PATH = "/app/DonkeySimLinux/DonkeySimLinux/donkey_sim.x86_64"' >> config.py
RUN echo 'DONKEY_GYM_ENV_NAME = "donkey-generated-track-v0"' >> config.py
RUN echo 'CAMERA_TYPE = "MOCK"' >> myconfig.py
RUN echo 'CAMERA_TYPE = "MOCK"' >> config.py

# Disable data recording/saving functionality
RUN echo 'RECORD_DURING_AI = False' >> myconfig.py
RUN echo 'AUTO_RECORD_ON_THROTTLE = False' >> myconfig.py
RUN echo 'USE_JOYSTICK_AS_DEFAULT = True' >> myconfig.py
RUN echo 'JOYSTICK_DEADZONE = 0.0' >> myconfig.py
RUN echo 'RECORD_DURING_AI = False' >> config.py
RUN echo 'AUTO_RECORD_ON_THROTTLE = False' >> config.py
RUN echo 'USE_JOYSTICK_AS_DEFAULT = True' >> config.py
RUN echo 'JOYSTICK_DEADZONE = 0.0' >> config.py

# Copy startup script
COPY start_with_display.sh /app/start_with_display.sh
RUN chmod +x /app/start_with_display.sh

# Set the PATH to include the virtual environment
ENV PATH="/app/donkey/bin:$PATH"

# Expose any necessary ports (if needed for the simulator)
EXPOSE 9091

# Default command to run with virtual display
CMD ["/app/start_with_display.sh"]
