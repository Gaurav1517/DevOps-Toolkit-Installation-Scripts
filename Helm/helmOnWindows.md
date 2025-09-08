To install **Helm on Windows** for use with a **Minikube cluster**, the script you're referencing (`get_helm.sh`) is for **Linux/macOS**, not Windows. 
It won't work natively in PowerShell or CMD unless you're using **WSL (Windows Subsystem for Linux)** or **Git Bash**.

---

###  Here's how to properly install Helm on Windows (for Minikube):

##  **Option 1: Install Helm via Chocolatey (Recommended for PowerShell)**

If you use PowerShell and have [Chocolatey](https://chocolatey.org/install) installed:

```powershell
choco install kubernetes-helm -y
```

Then verify the install:

```powershell
helm version
```

---

##  **Option 2: Manual Installation from Helm Releases**

1. Go to: [https://github.com/helm/helm/releases](https://github.com/helm/helm/releases)
2. Download the latest Windows `.zip` archive (e.g., `helm-v3.14.4-windows-amd64.zip`)
3. Extract it.
4. Add the extracted folder (containing `helm.exe`) to your system `PATH`:

   * Open **System Properties → Environment Variables**
   * Edit the `PATH` variable under *User variables*
   * Add the folder where `helm.exe` is located

Verify:

```powershell
helm version
```

---

##  **Option 3: Use `get_helm.sh` via WSL (if installed)**

If you're running **WSL** (e.g., Ubuntu):

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Then run:

```bash
helm version
```

> This is the exact script you referenced. But again — it **only works on Linux/WSL/macOS**.

---

##  Next Step: Connect Helm to Minikube

Once Helm is installed:

1. Ensure `kubectl` is configured for Minikube:

```powershell
kubectl config use-context minikube
```

2. Test Helm with a chart:

```powershell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-nginx bitnami/nginx
```

3. Confirm deployment:

```powershell
kubectl get pods
```

---
