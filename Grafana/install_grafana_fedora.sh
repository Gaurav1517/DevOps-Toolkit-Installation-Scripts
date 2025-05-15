#!/bin/bash

set -e  # Exit on any error

echo "📥 Downloading Grafana GPG key..."
wget -q -O gpg.key https://rpm.grafana.com/gpg.key
sudo rpm --import gpg.key

echo "📝 Creating Grafana repo file..."
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

echo "📦 Installing Grafana..."
sudo dnf install -y grafana

echo "🚀 Enabling and starting Grafana service..."
sudo systemctl enable --now grafana.service

echo "✅ Grafana installed and running. Access it via http://<your-server-ip>:3000"
# NOTE: Default user admin pass admin
