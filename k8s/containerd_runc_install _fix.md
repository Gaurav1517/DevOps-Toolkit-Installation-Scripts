# ✅ OFFICIAL CONTAINERD + RUNC INSTALL (RHEL 10 SAFE METHOD)

---

# 🔹 STEP 0 — Prerequisites

```bash id="s0"
sudo dnf install -y curl tar gzip
```

---

# 🔹 STEP 1 — Download containerd (official binary)

```bash id="s1"
export VER=1.7.24

curl -LO https://github.com/containerd/containerd/releases/download/v$VER/containerd-$VER-linux-amd64.tar.gz
```

---

# 🔹 STEP 2 — Install binaries

```bash id="s2"
sudo tar -C /usr/local -xzf containerd-$VER-linux-amd64.tar.gz
```

Verify:

```bash id="s2b"
containerd --version
ctr version
```

---

# 🔹 STEP 3 — Install systemd service (official)

```bash id="s3"
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /etc/systemd/system/
```

---

# 🔹 STEP 4 — SYSTEMD VALIDATION (IMPORTANT)

### 👉 STEP 4.1 — Verify systemd sees file

```bash id="s4a"
systemctl cat containerd
```

If it says “not found”, continue.

---

### 👉 STEP 4.2 — Force systemd refresh

```bash id="s4b"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

Check again:

```bash id="s4c"
systemctl list-unit-files | grep containerd
```

---

### 👉 STEP 4.3 — Validate file integrity

```bash id="s4d"
file /etc/systemd/system/containerd.service
```

✔ MUST be:

```text
ASCII text
```

❌ If you see UTF-16 / HTML / data → redo Step 3.

---

# 🔹 STEP 5 — FIX CORRUPTED SERVICE (SAFE RECREATE METHOD)

If ANY issue occurs, rebuild cleanly:

```bash id="s5a"
sudo rm -f /etc/systemd/system/containerd.service
```

Recreate:

```bash id="s5b"
sudo tee /etc/systemd/system/containerd.service > /dev/null <<'EOF'
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStart=/usr/local/bin/containerd
Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF
```

---

# 🔹 STEP 6 — Reload systemd properly

```bash id="s6"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
```

Verify:

```bash id="s6b"
systemctl list-unit-files | grep containerd
```

---

# 🔹 STEP 7 — ENABLE + START containerd

```bash id="s7"
sudo systemctl enable --now containerd
```

Check:

```bash id="s7b"
systemctl status containerd
```

---

# 🔹 STEP 8 — INSTALL runc (OCI runtime)

```bash id="s8"
export RUNC_VER=1.3.1

curl -LO https://github.com/opencontainers/runc/releases/download/v$RUNC_VER/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
```

Verify:

```bash id="s8b"
runc --version
```

---

# 🔹 STEP 9 — Install CNI plugins (Kubernetes requirement)

```bash id="s9"
export CNI_VER=1.7.1

curl -LO https://github.com/containernetworking/plugins/releases/download/v$CNI_VER/cni-plugins-linux-amd64-v$CNI_VER.tgz

sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v$CNI_VER.tgz
```

---

# 🔹 STEP 10 — Generate config

```bash id="s10"
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```

Enable systemd cgroups:

```bash id="s10b"
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
```

---

# 🔹 STEP 11 — Restart containerd

```bash id="s11"
sudo systemctl restart containerd
```

---

# 🔹 STEP 12 — FINAL VERIFICATION

```bash id="s12"
containerd --version
ctr version
runc --version
systemctl status containerd
```

---

# 🚀 DONE — Production Ready

You now have:

✔ containerd (CRI runtime)
✔ systemd integration
✔ runc (OCI runtime)
✔ CNI networking plugins
✔ Kubernetes-ready foundation

---

If you want next step, I can guide you:

👉 kubeadm cluster setup
👉 Calico networking
👉 joining worker nodes
👉 fixing Kubernetes CRI errors

Just say: **“k8s setup next”**
