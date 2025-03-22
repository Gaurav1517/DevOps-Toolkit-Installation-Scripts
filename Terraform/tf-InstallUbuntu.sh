##########Terraform Installation in ubuntu server##################
# Ref: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

# Update your system and install required packages:
sudo apt-get update && \
sudo apt-get install -y gnupg software-properties-common
# Install the HashiCorp GPG key:
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
# Verify the key's fingerprint:
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
#(Ensure the fingerprint matches the expected one. See the official guide for details.)
#Add the HashiCorp repository:
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Update package information:
sudo apt update
# Install Terraform:
sudo apt-get install terraform
# Check terraform version
terraform --version
#You can also install other HashiCorp tools like Vault, Consul, Nomad, and Packer with the same command.
# Verify the installation:
#Open a terminal and run:
terraform -help

# Enable tab completion
touch ~/.bashrc
#Then install the autocomplete package.
terraform -install-autocomplete
