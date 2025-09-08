To install **Node Exporter v1.9.1** on a **Linux server (e.g., RHEL, CentOS, Ubuntu, Amazon Linux, EC2, etc.)**, using the release you mentioned:

##  1. Download Node Exporter

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
```

---

##  2. Extract the archive

```bash
tar -xvzf node_exporter-1.9.1.linux-amd64.tar.gz
```

---

##  3. Move the binary to a system-wide location

```bash
sudo cp node_exporter-1.9.1.linux-amd64/node_exporter /usr/local/bin/
```

---

##  4. Create a system user (optional but recommended)

```bash
sudo useradd --no-create-home --shell /bin/false node_exporter
```

---

##  5. Create a systemd service file

```bash
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF
```

---

##  6. Reload systemd, enable and start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

---

##  7. Verify it's running

```bash
sudo systemctl status node_exporter
```

## 8. Allow Port 9100 in Firewall (if using firewalld)

```bash
sudo firewall-cmd --add-port=9100/tcp --permanent
sudo firewall-cmd --reload
```

Or check the endpoint in your browser or curl:

```bash
curl http://localhost:9100/metrics
```

---

##  9. Add to `prometheus.yml` (optional)

To scrape Node Exporter metrics from Prometheus, add this to your `prometheus.yml`:
```bash
vim /etc/prometheus/prometheus.yml
```
```yaml
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['<node_ip>:9100']
```

Replace `<node_ip>` with your actual instance IP or hostname.

#### Restart promethus service

```bash
sudo systemctl restart prometheus.service
```

---


