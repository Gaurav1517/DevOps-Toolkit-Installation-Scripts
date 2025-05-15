#!/bin/bash

# Download dependencies
yum install -y curl unzip

# Download and install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Optional: Add to PATH (usually not needed if installed to /usr/local/bin)
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Clean up
rm -rf aws awscliv2.zip

# Confirm installation
aws --version
