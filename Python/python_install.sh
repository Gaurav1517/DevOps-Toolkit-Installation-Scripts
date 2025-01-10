#!/bin/bash

# Exit script on any error
set -e

# Define Python version and source URL
PYTHON_VERSION="3.13.0"
PYTHON_SRC_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"

# Download Python source code
echo "Downloading Python ${PYTHON_VERSION}..."
wget $PYTHON_SRC_URL -O /tmp/Python-${PYTHON_VERSION}.tgz

# Extract Python tarball
echo "Extracting Python ${PYTHON_VERSION}..."
mkdir -p /opt/python-${PYTHON_VERSION}
tar -xvzf /tmp/Python-${PYTHON_VERSION}.tgz -C /opt/python-${PYTHON_VERSION} --strip-components=1

# Set environment variables
echo "Setting up environment variables..."
PYTHON_BIN_PATH="/opt/python-${PYTHON_VERSION}/bin"
echo "export PATH=\$PATH:${PYTHON_BIN_PATH}" >> ~/.bashrc
echo "export PYTHON_HOME=/opt/python-${PYTHON_VERSION}" >> ~/.bashrc
source ~/.bashrc

# Verify Python installation
echo "Verifying Python installation..."
if python3 --version; then
    echo "Python ${PYTHON_VERSION} installed successfully."
else
    echo "Python installation failed."
    exit 1
fi

# Install pip
echo "Installing pip for Python ${PYTHON_VERSION}..."
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
python3 /tmp/get-pip.py

# Verify pip installation
echo "Verifying pip installation..."
if pip3 --version; then
    echo "pip installed successfully."
else
    echo "pip installation failed."
    exit 1
fi

echo "Python and pip setup completed."
