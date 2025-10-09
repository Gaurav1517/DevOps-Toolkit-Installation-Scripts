#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to detect the package manager
detect_package_manager() {
    if command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v apt >/dev/null 2>&1; then
        echo "apt"
    else
        echo "Unsupported package manager. Exiting." >&2
        exit 1
    fi
}

# Detect package manager
PKG_MGR=$(detect_package_manager)

# Update system and install Apache
echo "Updating system and installing Apache using $PKG_MGR..."

case "$PKG_MGR" in
    dnf|yum)
        sudo $PKG_MGR update -y
        sudo $PKG_MGR install -y httpd
        sudo systemctl start httpd
        sudo systemctl enable httpd
        APACHE_SERVICE="httpd"
        ;;
    apt)
        sudo apt update -y
        sudo apt install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        APACHE_SERVICE="apache2"
        ;;
esac

# Get private IP address
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Create a custom index.html
echo "Creating index.html with server info..."

sudo bash -c "cat <<EOF > /var/www/html/index.html
<html>
<head>
    <title>WAF APPLICATION</title>
</head>
<body>
    <h1>Server Details</h1>
    <p><strong>Hostname:</strong> $(hostname)</p>
    <p><strong>Private IP Address:</strong> $PRIVATE_IP</p>
</body>
</html>
EOF"

# Restart Apache service
echo "Restarting Apache service ($APACHE_SERVICE)..."
sudo systemctl restart $APACHE_SERVICE

echo "Apache installation, configuration, and restart complete."





########### for rhel pakage script ##############
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
    <title>WAF APPLICATION</title>
</head>
<body>
    <h1>Server Details</h1>
    <p><strong>Hostname:</strong> $(hostname)</p>
    <p><strong>Private IP Address:</strong> $PRIVATE_IP</p>
</body>
</html>
EOF

# Restart Apache to apply changes
systemctl restart httpd
