# 📦 Nexus (Artifact Repository) server configuration

## ✅ Step 1: Pull the Nexus Image

```bash
docker pull sonatype/nexus3
```

---

## ✅ Step 2: Run the Nexus Container

Run it once manually to create the container:

```bash
docker run -d \
  --name nexus \
  -p 8081:8081 \
  -v nexus-data:/nexus-data \
  sonatype/nexus3
```

> ✅ This creates a named volume `nexus-data` to persist configuration and artifacts.

---

## ✅ Step 3: Set Up systemd Service

Create a systemd unit file:

```bash
sudo tee /etc/systemd/system/docker.nexus.service > /dev/null <<EOF
[Unit]
Description=Nexus Repository Manager (Docker Container)
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a nexus
ExecStop=/usr/bin/docker stop nexus
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
```

---

## ✅ Step 4: Enable and Start the Service

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable docker.nexus.service
sudo systemctl start docker.nexus.service
```
---

## ✅ Open Required Ports in `firewalld`
To allow access to Nexus (port `8081`)  through the **firewalld** firewall, run the following commands:

```bash
# Open Nexus port
sudo firewall-cmd --permanent --add-port=8081/tcp

# Reload firewall to apply changes
sudo firewall-cmd --reload
```

---

## ✅ Verify Open Ports

You can confirm that the ports are open using:

```bash
sudo firewall-cmd --list-ports
```
---

## ✅ Step 5: Access Nexus

Visit:

```
http://<your-server-ip>:8081
```

---

## ✅ Step 6: Get the Admin Password

Run this to retrieve the initial password:

```bash
docker exec -it nexus cat /nexus-data/admin.password
```

---

## ✅ Step 7: Verify Status

```bash
systemctl status docker.nexus.service
```

---
