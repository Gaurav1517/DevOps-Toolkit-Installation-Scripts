To install **Grafana** on a **RHEL-based system (RHEL, CentOS, Amazon Linux 2, etc.)**.

##  Grafana Installation on RHEL 

###  1. Download the GPG Key

```bash
wget -q -O gpg.key https://rpm.grafana.com/gpg.key
```

###  2. Import the GPG Key

```bash
sudo rpm --import gpg.key
```

###  3. Create the Grafana YUM Repo

Creating Grafana repo file...

```bash
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
```
---

###  4. Install Grafana

```bash
sudo dnf install -y grafana
```

---

###  5. Enable and Start Grafana Server

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server.service
```

---

###  6. Allow Port 3000 in Firewall (if using `firewalld`)

```bash
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
```

---

###  7. Access Grafana in Browser

Open this URL in your browser:

```
http://<your-server-ip>:3000
```

Replace `<your-server-ip>` with your actual public IP or hostname.

---

###  Default Login

| Username | Password |
| -------- | -------- |
| `admin`  | `admin`  |

You’ll be prompted to change the password after first login.

---
