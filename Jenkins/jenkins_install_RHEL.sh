#!/bin/bash

# INSTALL JENKINS IN RHEL(Virtual Machine)

# Update machine
echo "Updating the system..."
sudo dnf update -y

# Add Jenkins repository
echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import GPG key for Jenkins
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade the system
echo "Upgrading the system..."
sudo dnf upgrade -y

# Install required dependencies for Jenkins
echo "Installing required dependencies..."
sudo dnf install -y fontconfig java-17-openjdk

# Set up JDK environment variables
echo "Configuring Java environment variables..."
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk" | sudo tee -a /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile
source /etc/profile

# Verify Java installation
echo "Verifying Java installation..."
echo "JAVA_HOME is set to: $JAVA_HOME"
java -version

# Install Jenkins
echo "Installing Jenkins..."
sudo dnf install -y jenkins

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable Jenkins to start at boot
echo "Enabling Jenkins service to start at boot..."
sudo systemctl enable jenkins.service

# Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins.service

# Check Jenkins service status
echo "Checking Jenkins service status..."
sudo systemctl status jenkins.service

# Configure firewall for Jenkins
echo "Configuring firewall for Jenkins..."
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# Verify firewall settings
echo "Verifying firewall configuration..."
sudo firewall-cmd --list-all --zone=public
sudo firewall-cmd --list-ports --zone=public

# Display access URL
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Access Jenkins at: http://$IP_ADDRESS:8080"
