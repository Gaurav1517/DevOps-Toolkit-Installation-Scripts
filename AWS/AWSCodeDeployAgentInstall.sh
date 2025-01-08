########## Install the CodeDeploy Agent #########
# Ref: https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html

#!/bin/bash
# Update the system
sudo yum update -y
# Install dependencies
sudo yum install ruby -y
sudo yum install wget -y
# Download and install CodeDeploy agent
# Note: must change the AWS Region with working region..
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
# Start and enable CodeDeploy agent
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
# Check CodeDeploy agent status
systemctl status codedeploy-agent
