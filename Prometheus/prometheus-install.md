##  Step-by-Step: Install Prometheus on RHEL 

###  1. **Download the Correct Prometheus Binary**

```bash
cd /opt
sudo wget https://github.com/prometheus/prometheus/releases/download/v3.6.0-rc.0/prometheus-3.6.0-rc.0.linux-amd64.tar.gz
sudo tar -xvzf prometheus-3.6.0-rc.0.linux-amd64.tar.gz
sudo mv prometheus-3.6.0-rc.0.linux-amd64 prometheus
```

---

###  2. **Create Prometheus User**

```bash
sudo useradd --no-create-home --shell /bin/false prometheus
```

---

###  3. **Set Up Directories and Permissions**

```bash
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

sudo cp /opt/prometheus/prometheus.yml /etc/prometheus/
sudo cp /opt/prometheus/{prometheus,promtool} /usr/local/bin/

sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
```

---

###  4. **Create systemd Service File**

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

###  5. **Start and Enable Prometheus**

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
```

Check status:

```bash
systemctl status prometheus
```

---

###  6. **Access Prometheus UI**

Open a browser and go to:

```
http://<your-server-ip>:9090
```

If needed, open the firewall:

```bash
sudo firewall-cmd --add-port=9090/tcp --permanent
sudo firewall-cmd --reload
```

---

###  Prometheus is Now Running as a System Service!
