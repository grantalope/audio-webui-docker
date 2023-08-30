# Use the official image as a parent image
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Metadata as described in best practices
LABEL version="1.0"
LABEL description="Docker image with CUDA, Python, and audio-webui"

# Set the working directory in the container
WORKDIR /app

# Install Python and pip
RUN --mount=type=cache,target=/var/cache/apt apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    wget \
    unzip \
    git \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/* 

# Upgrade setuptools and install wheel
RUN --mount=type=cache,target=/root/.cache/pip pip3 install --upgrade setuptools wheel

# Download and install audio-webui
RUN wget https://github.com/gitmylo/audio-webui/releases/download/Installers/audio-webui.zip
RUN unzip audio-webui.zip
RUN --mount=type=cache,target=/root/.cache/pip bash /app/install_linux_macos.sh

# Switch to the audio-webui directory
WORKDIR /app/audio-webui

# Copy environment variables and scripts
COPY ./.env /app
COPY ./run.sh /app

# Give execute permission to run.sh
RUN chmod +x /app/run.sh
