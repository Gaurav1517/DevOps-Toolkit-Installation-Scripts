# 🔹 STEP 9 — Install CNI Plugins (Kubernetes Networking Requirement)

CNI plugins are required for pod networking in Kubernetes when using containerd.

---

## 👉 STEP 9.1 — Detect architecture

```bash id="c9a1"
uname -m
```

* `x86_64` → use `amd64`
* `aarch64` → use `arm64`

---

## 👉 STEP 9.2 — Download CNI plugins

(Example for amd64)

```bash id="c9a2"
export CNI_VER=1.6.2

curl -LO https://github.com/containernetworking/plugins/releases/download/v$CNI_VER/cni-plugins-linux-amd64-v$CNI_VER.tgz
```

---

## 👉 STEP 9.3 — Create required directory

```bash id="c9a3"
sudo mkdir -p /opt/cni/bin
```

---

## 👉 STEP 9.4 — Extract CNI plugins (CORRECT METHOD)

```bash id="c9a4"
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v$CNI_VER.tgz
```

---

## 👉 STEP 9.5 — Verify installation

```bash id="c9a5"
ls -l /opt/cni/bin
```

You should see binaries like:

* bridge
* host-local
* portmap
* loopback
* firewall

---

## 👉 STEP 9.6 — Create CNI config directory

```bash id="c9a6"
sudo mkdir -p /etc/cni/net.d
```

---

## 👉 STEP 9.7 — Verify CNI readiness

```bash id="c9a7"
ls /opt/cni/bin
ls /etc/cni/net.d
```

---

# 🚀 Result

After this step:

✔ containerd can create pod networks
✔ Kubernetes kubeadm will NOT fail on CNI
✔ bridge networking support is ready

---

If you want, I can now combine everything into a **full “RHEL 10 Kubernetes containerd + kubeadm install guide”** (production-ready, no errors).
