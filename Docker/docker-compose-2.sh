#!/bin/bash
### Docker Compose Installation on CentOS / RHEL ###
# Get pre-requisite packages.
sudo yum -y install curl wget

# Download the latest Compose on your Linux machine.
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url  | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -

# Make the binary file executable
chmod +x docker-compose-linux-x86_64

# Move the file to your PATH.
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose

# Confirm version.
docker-compose version
# Docker Compose version v2.28.1

# Add user to docker group:
sudo usermod -aG docker $USER
newgrp docker

# For Bash users
# Place the completion script in /etc/bash_completion.d/.
sudo mkdir -p /etc/bash_completion.d/
sudo curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# Source the file or re-login to enjoy the completion feature.
echo "source /etc/bash_completion.d/docker-compose" | tee -a ~/.bashrc
source /etc/bash_completion.d/docker-compose
