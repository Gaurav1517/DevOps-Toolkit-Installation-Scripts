# Install AWS CLI and Configure Environment Variable
#!/bin/bash
sudo apt update -y 
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Add AWS CLI to the PATH if not already present
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
  echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
  source ~/.bashrc
fi
aws --version
