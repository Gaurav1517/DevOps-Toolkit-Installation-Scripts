# Jenkins HTTPS Setup with Route53, Nginx & Certbot

## Architecture Overview

```
User Browser
   |
   | HTTPS (443)
   v
Nginx (Reverse Proxy + SSL)
   |
   | HTTP (8080)
   v
Jenkins
```

---

## Prerequisites

Before you start, ensure the following:

1. **Domain registered** (example.com)
2. **Domain managed in AWS Route53**
3. **EC2 / VM** with:

   * Ubuntu 20.04 / 22.04
   * Public IP address
4. **Jenkins installed and running**

   * Default port: `8080`
5. **Security Group / Firewall**

   * Allow inbound:

     * TCP 80 (HTTP)
     * TCP 443 (HTTPS)
     * TCP 22 (SSH)

---

## Step 1: Create DNS Record in Route53

### 1.1 Open Route53

* Go to **AWS Console → Route53**
* Open **Hosted Zones**
* Select your domain (example.com)

### 1.2 Create A Record for Jenkins

Click **Create record**:

| Field          | Value                     |
| -------------- | ------------------------- |
| Record name    | `jenkins`                 |
| Record type    | `A`                       |
| Value          | `<YOUR_SERVER_PUBLIC_IP>` |
| TTL            | 300                       |
| Routing policy | Simple                    |

**Resulting domain:**

```
jenkins.example.com → <server-public-ip>
```

### 1.3 Verify DNS

From your local machine:

```bash
ping jenkins.example.com
```

Or:

```bash
nslookup jenkins.example.com
```

It should resolve to your server’s public IP.

---

## Step 2: Install Jenkins (If Not Installed)

Skip this step if Jenkins is already running.

```bash
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre 
java -version
```

Add Jenkins repo:

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

Install Jenkins:

```bash
sudo apt update
sudo apt install vim jenkins -y
```

Start Jenkins:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Verify:

```bash
curl http://localhost:8080
```

---

## Step 3: Install and Configure Nginx

### 3.1 Install Nginx

```bash
sudo apt update
sudo apt install nginx -y
```

Enable and start:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```

Verify:

```bash
curl http://localhost
```

---

## Step 4: Configure Nginx as Reverse Proxy for Jenkins

### 4.1 Create Jenkins Nginx Config

```bash
sudo vim /etc/nginx/sites-available/jenkins
```

Paste the following:

```nginx
server {
    listen 80;
    server_name jenkins.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

Save and exit.

---

### 4.2 Enable Jenkins Site

```bash
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
```

(Optional) Remove default site:

```bash
sudo rm /etc/nginx/sites-enabled/default
```

Test configuration:

```bash
sudo nginx -t
```

Restart Nginx:

```bash
sudo systemctl restart nginx
```

### 4.3 Test HTTP Access

Open in browser:

```
http://jenkins.example.com
```

You should see the Jenkins UI (still HTTP).

---

## Step 5: Install Certbot (Let’s Encrypt)

### 5.1 Install Certbot and Nginx Plugin

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

Verify:

```bash
certbot --version
```

---

## Step 6: Obtain SSL Certificate for Jenkins

Run Certbot:

```bash
sudo certbot --nginx -d jenkins.example.com
```

### 6.1 Certbot Prompts

* Enter email → **Yes**
* Agree to terms → **Yes**
* Redirect HTTP to HTTPS → **Choose Redirect (Recommended)**

Certbot will:

* Obtain SSL certificate
* Modify Nginx config automatically
* Enable HTTPS redirection

---

## Step 7: Verify HTTPS Configuration

Open in browser:

```
https://jenkins.example.com
```

You should see:

* 🔒 Secure lock icon
* Jenkins UI over HTTPS

---

## Step 8: Review Updated Nginx Configuration

Certbot automatically updates your config to something like:

```nginx
server {
    listen 443 ssl;
    server_name jenkins.example.com;

    ssl_certificate /etc/letsencrypt/live/jenkins.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/jenkins.example.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {
    listen 80;
    server_name jenkins.example.com;
    return 301 https://$host$request_uri;
}
```

---

## Step 9: Configure Jenkins Base URL (Important)

### 9.1 Open Jenkins Dashboard

```
https://jenkins.example.com
```

### 9.2 Go to:

```
Manage Jenkins → System → Jenkins Location
```

Set:

```
Jenkins URL: https://jenkins.example.com/
```

Save.

This ensures:

* Correct webhook URLs
* Proper redirects
* Plugin compatibility

---

## Step 10: Enable Auto-Renewal for SSL Certificates

Certbot installs a systemd timer automatically.

### 10.1 Test Renewal

```bash
sudo certbot renew --dry-run
```

Expected output:

```
Congratulations, all simulated renewals succeeded
```

### 10.2 Check Timer

```bash
systemctl list-timers | grep certbot
```

---

## Step 11: Common Troubleshooting

### DNS Not Resolving

* Wait 1–5 minutes (TTL)
* Verify Route53 record IP

### Certbot Fails

* Ensure port 80 is open
* Ensure domain resolves to server IP
* Ensure Nginx is running

### Jenkins Shows Wrong URL

* Update Jenkins Location URL
* Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

---

## Final Result

✅ Jenkins accessible securely at:

```
https://jenkins.example.com
```

✅ SSL auto-renewal enabled
✅ Nginx reverse proxy configured
✅ Route53 DNS properly mapped

---


