########## Install the CodeDeploy Agent #########
# Ref: https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html

#!/bin/bash
sudo yum update -y
sudo yum install ruby -y
sudo yum install wget -y
# Note: must change the AWS Region with current working region..
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
systemctl status codedeploy-agent
