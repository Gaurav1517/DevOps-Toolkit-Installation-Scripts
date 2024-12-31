#########INSTALL DOCKER IN RHEL 9 ########### 
# Update the system 
dnf update -y
# Before install you must uninstall these packages before you install the official version of Docker Engine. 
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc
#Set up the repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
#Install Docker Engine
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#Start & Enable Docker Engine.
sudo systemctl enable --now docker
# Check status docker service
systemctl status docker.service
# check version 
docker --version
# Verify that the installation is successful by running the hello-world image:
sudo docker run hello-world
