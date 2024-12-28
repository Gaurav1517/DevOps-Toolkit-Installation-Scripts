#!/bin/bash

# Step 1: Check if Podman is installed
echo "Checking if Podman is installed..."
if command -v podman &> /dev/null; then
    echo "Podman is installed."
    podman --version
else
    echo "Podman is not installed."
fi

# Step 2: Check if Podman is available in the repository
echo "Checking if Podman is available in the repository..."
dnf list podman &> /dev/null
if [ $? -eq 0 ]; then
    echo "Podman is available in the repository."
else
    echo "Podman is not available in the repository."
fi

# Step 3: Uninstall Podman
echo "Removing Podman..."
if dnf remove podman -y &> /dev/null; then
    echo "Podman has been successfully removed."
else
    echo "Podman is not installed or could not be removed."
fi

# Step 4: Remove Podman configuration, data, and binaries
echo "Removing Podman configuration, data, and binaries..."
rm -rf ~/.config/containers ~/.local/share/containers /etc/containers /var/lib/containers
rm -rf /usr/libexec/podman/
rm -f /usr/bin/podman
echo "Podman configuration, data, and binaries have been removed."

# Step 5: Verify Podman is uninstalled
echo "Verifying if Podman is completely uninstalled..."
if ! command -v podman &> /dev/null; then
    echo "Podman has been completely uninstalled."
else
    echo "Podman is still installed."
fi

echo "Script completed."

