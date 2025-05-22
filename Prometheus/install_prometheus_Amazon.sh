#!/bin/bash
# Installing prometheus in Amazon Linux
set -e

VERSION="2.52.0"
USER="prometheus"
GROUP="prometheus"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/prometheus"
DATA_DIR="/var/lib/prometheus"
SERVICE_FILE="/etc/systemd/system/prometheus.service"
ARCHIVE="prometheus-${VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v${VERSION}/${ARCHIVE}"
EXTRACT_DIR="prometheus-${VERSION}.linux-amd64"

echo "🔧 Installing required packages..."
sudo dnf install -y wget curl tar --skip-broken --allowerasing

echo "👤 Creating Prometheus user and group..."
sudo groupadd --system $GROUP || true
sudo useradd --system --no-create-home --shell /sbin/nologin --gid $GROUP $USER || true

echo "📥 Downloading Prometheus v${VERSION}..."
wget -q --show-progress $DOWNLOAD_URL

echo "📂 Extracting Prometheus..."
tar xvf $ARCHIVE

echo "🚚 Moving binaries..."
sudo cp $EXTRACT_DIR/prometheus $INSTALL_DIR/
sudo cp $EXTRACT_DIR/promtool $INSTALL_DIR/

echo "📁 Setting up config and data directories..."
sudo mkdir -p $CONFIG_DIR $DATA_DIR
sudo cp -r $EXTRACT_DIR/consoles $CONFIG_DIR/
sudo cp -r $EXTRACT_DIR/console_libraries $CONFIG_DIR/
sudo cp $EXTRACT_DIR/prometheus.yml $CONFIG_DIR/

echo "🔐 Setting permissions..."
sudo chown -R $USER:$GROUP $CONFIG_DIR $DATA_DIR
sudo chown $USER:$GROUP $INSTALL_DIR/prometheus $INSTALL_DIR/promtool

echo "📝 Creating systemd service..."
sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$GROUP
Type=simple
ExecStart=$INSTALL_DIR/prometheus \\
  --config.file=$CONFIG_DIR/prometheus.yml \\
  --storage.tsdb.path=$DATA_DIR \\
  --web.console.templates=$CONFIG_DIR/consoles \\
  --web.console.libraries=$CONFIG_DIR/console_libraries

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Reloading systemd and starting Prometheus..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus

echo "✅ Prometheus installation complete!"
echo "🌐 Access Prometheus at: http://<your-server-ip>:9090"
