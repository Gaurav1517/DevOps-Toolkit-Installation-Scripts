# Install & Set Up Kind Cluster on Windows


##  Kubernetes Kind Cluster Setup on Windows (4 Nodes)

This guide walks you through installing **Kind (Kubernetes IN Docker)** and creating a
**4-node Kubernetes cluster** on Windows.

---

##  Prerequisites

- ✅ Windows 10/11 with **PowerShell**
- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- ✅ Internet connection
- ✅ Admin access to PowerShell

---

##  Step 1: Install `kubectl`

Install using `winget` (recommended for Windows 10+):

```powershell
winget install -e --id Kubernetes.kubectl
````

Verify:

```powershell
kubectl version --client
```

---

##  Step 2: Install Kind

1. **Download Kind binary**:

```powershell
curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.30.0/kind-windows-amd64
```

2. **Move to a folder in your system `PATH`** (example: `C:\Program Files\kind`):

```powershell
New-Item -ItemType Directory -Path "C:\Program Files\kind" -Force
Move-Item .\kind-windows-amd64.exe "C:\Program Files\kind\kind.exe"
```

3. **Add to PATH**:

   * Open: `SystemPropertiesAdvanced` → Environment Variables → System `Path`
   * Add: `C:\Program Files\kind`
   * Click OK

4. **Restart PowerShell** and test:

```powershell
kind version
```

---

##  Step 3: Create a 4-Node Kind Cluster

Create a config file named `multi-level-cluster.yaml`:

```yaml
# multi-level-cluster.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    image: kindest/node:v1.31.2

  - role: worker
    image: kindest/node:v1.31.2

  - role: worker
    image: kindest/node:v1.31.2

  - role: worker
    image: kindest/node:v1.31.2
    extraPortMappings:
      - containerPort: 80   # HTTP
        hostPort: 80
        protocol: TCP
      - containerPort: 443  # HTTPS
        hostPort: 443
        protocol: TCP
```

>  Make sure port 80/443 aren't already used on your system (e.g., by IIS or WSL).

Create the cluster:

```powershell
kind create cluster --name multi-level-cluster --config multi-level-cluster.yaml
```

---

##  Step 4: Verify the Cluster

```powershell
kubectl get nodes
```

You should see something like:

```
NAME                                STATUS   ROLES           AGE     VERSION
multi-level-cluster-control-plane   Ready    control-plane   1m      v1.31.2
multi-level-cluster-worker          Ready    <none>          1m      v1.31.2
multi-level-cluster-worker2         Ready    <none>          1m      v1.31.2
multi-level-cluster-worker3         Ready    <none>          1m      v1.31.2
```

---

##  Optional: Install NGINX Ingress Controller

```powershell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/kind/deploy.yaml
```

Wait for it to be ready:

```powershell
kubectl wait --namespace ingress-nginx `
  --for=condition=Ready pod `
  --selector=app.kubernetes.io/component=controller `
  --timeout=120s
```

---

##  Switch Between Kind and Minikube (if installed)

```powershell
kubectl config get-contexts
kubectl config use-context kind-multi-level-cluster
kubectl config use-context minikube
```

---

##  Clean Up (Delete Kind Cluster)

```powershell
kind delete cluster --name multi-level-cluster
```

---

##  Summary

| Tool    | Version Command            | Installed? |
| ------- | -------------------------- | ---------- |
| kubectl | `kubectl version --client` | ✅          |
| kind    | `kind version`             | ✅          |
| Docker  | Docker Desktop UI          | ✅          |

> Now you have a fully working multi-node Kubernetes cluster using Kind on Windows! 🎉

---
##  References

- [Install kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#install-nonstandard-package-tools)
- [Kind Official Quick Start Guide](https://kind.sigs.k8s.io/docs/user/quick-start/#creating-a-cluster)
