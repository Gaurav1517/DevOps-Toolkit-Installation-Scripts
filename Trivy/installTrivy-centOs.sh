####### Install Trivy in CentOS #######
echo "Installing Trivy..."

# Add Trivy repository
cat << EOF | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

# Update the package list
sudo yum -y update

# Install Trivy
sudo yum -y install trivy

# Verify installation
echo "Verifying Trivy installation..."
trivy --version
