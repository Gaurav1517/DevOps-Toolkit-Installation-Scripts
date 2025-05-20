# 🖥️ Installing Minikube on Windows

Follow these steps to install and set up Minikube on a Windows machine using PowerShell with Administrator privileges.

---

## ✅ Step 1: Download Minikube

Open **PowerShell as Administrator** and run the following commands:

```powershell
New-Item -Path 'C:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'C:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
````

---

## ✅ Step 2: Add Minikube to System PATH

Still in **Administrator PowerShell**, run:

```powershell
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube') {
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
}
```

---

## 🚀 Step 3: Start Your Cluster

In a new terminal **with Administrator access**, run:

```powershell
minikube start
```

> ⚠️ If `minikube` fails to start, check the [Minikube drivers documentation](https://minikube.sigs.k8s.io/docs/drivers/) for compatible virtualization or container runtimes.

---

## 📦 Step 4: Interact with Your Cluster

If you have `kubectl` installed:

```bash
kubectl get po -A
```

Or use the bundled version from Minikube:

```bash
minikube kubectl -- get po -A
```

To make `kubectl` always use Minikube's version, add this alias to your shell config:

```bash
alias kubectl="minikube kubectl --"
```

> Note: It’s normal for some services (like `storage-provisioner`) to take time before reaching a `Running` state.

### 🧭 Launch Kubernetes Dashboard

```bash
minikube dashboard
```

---

## 🚢 Step 5: Deploy a Sample Application

### Create and expose a deployment:

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

### Check the service:

```bash
kubectl get services hello-minikube
```

### Access via browser:

```bash
minikube service hello-minikube
```

Or forward the port manually:

```bash
kubectl port-forward service/hello-minikube 7080:8080
```

Open your browser at [http://localhost:7080](http://localhost:7080)

---

## ⚙️ Step 6: Manage Your Cluster

* **Pause Kubernetes (without stopping deployments):**

  ```bash
  minikube pause
  ```

* **Resume a paused cluster:**

  ```bash
  minikube unpause
  ```

* **Stop the cluster:**

  ```bash
  minikube stop
  ```

* **Change default memory allocation:**

  ```bash
  minikube config set memory 9001
  ```

* **View available add-ons:**

  ```bash
  minikube addons list
  ```

* **Create a second cluster (e.g., with an older Kubernetes version):**

  ```bash
  minikube start -p aged --kubernetes-version=v1.16.1
  ```

* **Delete all Minikube clusters:**

  ```bash
  minikube delete --all
  ```

---

## 🎉 Done!

You're now ready to explore Kubernetes on your local Windows machine with Minikube!
