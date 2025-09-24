#!/bin/bash
# Update system and install Apache
yum update -y
yum install -y httpd

# Start and enable Apache on boot
systemctl start httpd
systemctl enable httpd

# Get private IP address
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Create index.html with dynamic IP and static server name
cat <<EOF > /var/www/html/index.html
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to $PRIVATE_IP and SERVER-01</h1>
</body>
</html>
EOF
