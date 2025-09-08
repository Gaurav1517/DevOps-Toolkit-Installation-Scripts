##  Blackbox Exporter v0.27.0 Installation (RHEL/CentOS/Fedora)

###  **Step 1: Download and Extract Blackbox Exporter**

```bash
cd /opt
sudo wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.27.0/blackbox_exporter-0.27.0.linux-amd64.tar.gz
sudo tar -xzf blackbox_exporter-0.27.0.linux-amd64.tar.gz
sudo mv blackbox_exporter-0.27.0.linux-amd64 blackbox_exporter
```

---

###  **Step 2: Create a Dedicated System User (Optional but Recommended)**

```bash
sudo useradd --no-create-home --shell /sbin/nologin blackbox_exporter
sudo chown -R blackbox_exporter:blackbox_exporter /opt/blackbox_exporter
```

---

###  **Step 3: Set CAP\_NET\_RAW (Optional - for ICMP support)**

```bash
sudo setcap cap_net_raw+ep /opt/blackbox_exporter/blackbox_exporter
```

This gives permission to run ICMP (ping-like) probes without root.

---

###  **Step 4: Create Configuration File**

```bash
# Create config directory
sudo mkdir /etc/blackbox_exporter
sudo chown blackbox_exporter:blackbox_exporter /etc/blackbox_exporter
```

# Create minimal configuration

```bash
sudo tee /etc/blackbox_exporter/blackbox.yml > /dev/null <<EOF
modules:
  http_2xx:
    prober: http
    timeout: 5s
EOF
```

Then set ownership:

```bash
sudo chown blackbox_exporter:blackbox_exporter /etc/blackbox_exporter/blackbox.yml
```

---

###  **Step 5: Create systemd Service File**

```bash
sudo tee /etc/systemd/system/blackbox_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Blackbox Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=blackbox_exporter
Group=blackbox_exporter
Type=simple
ExecStart=/opt/blackbox_exporter/blackbox_exporter \\
  --config.file=/etc/blackbox_exporter/blackbox.yml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

###  **Step 6: Enable and Start the Service**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now blackbox_exporter.service
sudo systemctl status blackbox_exporter.service
```

---

###  **Step 7: Allow Firewall Port (9115)**

```bash
sudo firewall-cmd --add-port=9115/tcp --permanent
sudo firewall-cmd --reload
```

---

###  **Step 8: Verify Blackbox Exporter Is Running**

```bash
curl http://localhost:9115/metrics
```

You should see Prometheus metrics. To test an actual probe:

```bash
curl "http://localhost:9115/probe?target=google.com&module=http_2xx"
```

---

###  **Step 9: Add Blackbox Exporter to Prometheus Configuration**

Open your Prometheus config file:

```bash
sudo vim /etc/prometheus/prometheus.yml
```

Add the following block **under** `scrape_configs:` (don't overwrite existing jobs):

```yaml
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Use the module defined in blackbox.yml

    static_configs:
      - targets:
        - https://example.com    # <-- Replace with your real URL(s)

    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: localhost:9115
```

Then reload Prometheus:

```bash
sudo systemctl reload prometheus.service
```

 Done!

You can now visit:

* Prometheus: [http://your-server-ip:9090](http://your-server-ip:9090)
* Blackbox Exporter: [http://your-server-ip:9115](http://your-server-ip:9115)

To test if your site is being probed, go to Prometheus **“Targets”** page and look for the job named `blackbox`.

