##  Prometheus Installation (RHEL / CentOS)

### 1. Update and install required packages

```bash
sudo dnf update -y
sudo dnf install -y wget tar
```

---

### 2. Download and extract Prometheus

```bash
cd /opt
sudo wget https://github.com/prometheus/prometheus/releases/download/v3.6.0-rc.0/prometheus-3.6.0-rc.0.linux-amd64.tar.gz
sudo tar -xvzf prometheus-3.6.0-rc.0.linux-amd64.tar.gz
sudo mv prometheus-3.6.0-rc.0.linux-amd64 prometheus
```

---

### 3️. Create Prometheus system user

```bash
sudo useradd --no-create-home --shell /bin/false prometheus
```

---

### 4️. Set up directories and permissions

```bash
# Create directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Copy config and binaries
sudo cp /opt/prometheus/prometheus.yml /etc/prometheus/
sudo cp /opt/prometheus/{prometheus,promtool} /usr/local/bin/

# Set ownership
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
```

---

### 5️. Create a Prometheus systemd service

```bash
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file=/etc/prometheus/prometheus.yml \\
    --storage.tsdb.path=/var/lib/prometheus/ \\
    --web.console.templates=/opt/prometheus/consoles \\
    --web.console.libraries=/opt/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF
```

---

### 6️. Enable and start Prometheus

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
```

---

### 7️. Verify Prometheus is running

```bash
systemctl status prometheus
```

You should see `active (running)` if it's successful.

---

### 8️. Allow Prometheus port (9090) in the firewall

```bash
sudo firewall-cmd --add-port=9090/tcp --permanent
sudo firewall-cmd --reload
```

---

### 9️. Access Prometheus Web UI

Open your browser and go to:

```
http://<your-server-ip>:9090
```

---
