#!/bin/bash
# Docker Compose Plugin
echo "Installing Docker Compose..."
# Ref: https://github.com/docker/compose/releases
wget https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 docker-compose
chmod +x docker-compose
mv docker-compose  /usr/bin/
docker-compose version
