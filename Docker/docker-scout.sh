#!/bin/bash
########## INSTALL DOCKER-SCOUT FOR DOCKER IMAGE SCANNING IN JENKINS
# Ref: https://docs.docker.com/scout/install/
# Note: docker should be installed in the system and login to docker hub
# docker login -u <username> -p <password>
# verify docker login by docker info | grep Username
sudo yum install -y curl
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
sudo sh install-scout.sh -b /usr/local/bin
docker scout --version
export PATH=$PATH:/usr/local/bin
source ~/.bashrc
sudo ln -s /usr/local/bin/docker-scout /usr/bin/docker-scout
ls -l /usr/bin/docker-scout
docker-scout version
