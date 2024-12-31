*********Docker installation in CentOS 9*********** 
# Ref: https://docs.docker.com/engine/install/centos/

# Update the machine.
sudo dnf update -y 
# You must uninstall these packages before you install the official version of Docker Engine.
 sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
#Install the dnf-plugins-core package (which provides the commands to manage your DNF repositories) and set up the repository.
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#To install the latest version, run:
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Daemon service Start & Enable 
sudo systemctl start --now docker.service
# Check the docker service status.
systemctl status docker.service
# Check the version
docker --version
# Verify that the installation is successful by running the hello-world image:
sudo docker run hello-world
