# 📊 SonarQube (Code Quality Server) Configuration

## ✅ Step 1: Run SonarQube Container

You should run the container once to create it before setting up `systemd`:

```bash
docker run -d \
  --name sonar \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:lts-community
```

> ✅ The volumes help persist data/config across restarts.

---

## ✅ Step 2: Create systemd Unit File

Create the service file:

```bash
sudo tee /etc/systemd/system/docker.sonar.service > /dev/null <<EOF
[Unit]
Description=SonarQube server (Docker Container)
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a sonar
ExecStop=/usr/bin/docker stop sonar
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
```

---

## ✅ Step 3: Enable and Start the Service

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable docker.sonar.service
sudo systemctl start docker.sonar.service
```

---

## ✅ Open Required Ports in `firewalld`
To allow access to  SonarQube (port `9000`) through the **firewalld** firewall, run the following commands:

```bash
# Open SonarQube port
sudo firewall-cmd --permanent --add-port=9000/tcp

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

## ✅ Step 4: Access SonarQube

Visit in your browser:

```
http://<your-server-ip>:9000
```

---

## ✅ Default Credentials

```
Username: admin
Password: admin
```

---

## ✅ Check Service Status

```bash
systemctl status docker.sonar.service
```

---
