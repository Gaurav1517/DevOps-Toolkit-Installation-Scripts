# ArgoCD Setup and Installation Guide

This guide walks through the process of setting up and installing **ArgoCD** (both UI and CLI) with the option to access via a web browser.

## Prerequisites

Before starting, ensure you have the following tools installed on your system:

### Docker

Docker is required to run Kind as cluster nodes.

```bash
sudo apt-get update
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
docker --version
docker ps
````
[Docker-Install-Guide](https://docs.docker.com/engine/install/)

### Kind (Kubernetes in Docker)

Used to create a Kubernetes cluster.

```bash
kind version
```
[kind-Install-Guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

### Kubectl

Required to interact with the Kubernetes cluster.

```bash
kubectl version --client
```
[kubectl-Install-Guide](https://kubernetes.io/docs/tasks/tools/)

### Helm

For Helm-based installation of ArgoCD.

```bash
helm version
```
[helm-Install-Guide](https://helm.sh/docs/intro/install/)

## Important

You can either follow the below manual steps or directly run the script [setup_argocd.sh](setup_argocd.sh).

The script will create a Kind cluster and install ArgoCD (UI and CLI) using either **Helm** or **Manifests**.

**Important**: Before using the guide or script, make sure to replace the `172.31.19.178` address with your EC2 instance's private IP in the cluster config for `apiServerAddress`.

## Step 1: Create a Kind Cluster

Save your cluster config as `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "172.31.19.178"   # Change this to your EC2 private IP
  apiServerPort: 33893
nodes:
  - role: control-plane
    image: kindest/node:v1.33.1
  - role: worker
    image: kindest/node:v1.33.1
  - role: worker
    image: kindest/node:v1.33.1
```

### Why `apiServerAddress` & `apiServerPort`?

To ensure the Kind cluster's API server is reachable from the ArgoCD pods. This avoids conflicts since Kind defaults to random localhost ports.

Create the cluster:

```bash
kind create cluster --name argocd-cluster --config kind-config.yaml
```

Verify:

```bash
kubectl cluster-info
kubectl get nodes
```

## Step 2: Install ArgoCD

### Method 1: Install ArgoCD using Helm (Recommended for Customization)

1. Add the Argo Helm repository:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

2. Create the namespace for ArgoCD:

```bash
kubectl create namespace argocd
```

3. Install ArgoCD using Helm:

```bash
helm install argocd argo/argo-cd -n argocd
```

4. Verify the installation:

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
```

5. Access the ArgoCD UI:

Port-forward the service:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &
```
OR
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443 --address=0.0.0.0 > /dev/null 2>&1 &
```

Now, open the browser:

```
https://<instance_public_ip>:8080
```

6. Get the initial admin password:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Login using:

* **Username**: `admin`
* **Password**: (Output from above)

7. To Stop the Port Forward
  You can stop it using:
  ```bash
  ps aux | grep port-forward
  kill <PID>
  ```   

### Method 2: Install ArgoCD using Official Manifests (Fastest for Demos)

1. Create the namespace for ArgoCD:

```bash
kubectl create namespace argocd
```

2. Apply the ArgoCD installation manifest:

```bash
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. Verify the installation:

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
```

4. Expose the ArgoCD server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=0.0.0.0 &
```

Access via:

```
https://<instance_public_ip>:8080
```

5. Get the initial password:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Login using:

* **Username**: `admin`
* **Password**: (Output from above)

## Step 3: Install ArgoCD CLI (Ubuntu/Linux)

ArgoCD server runs inside Kubernetes, but to interact with it from the terminal, you need the **ArgoCD CLI** (`argocd`).

### 1. Install ArgoCD CLI:

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

### 2. Verify installation:

```bash
argocd version --client
```

### 3. Login to ArgoCD CLI:

```bash
argocd login <instance_public_ip>:8080 --username admin --password <initial_password> --insecure
```

**Note**: The `--insecure` flag is required when using port-forward with self-signed TLS certs. For production, configure proper TLS certificates.

### 4. Get user information:

```bash
argocd account get-user-info
```

## Helm vs Manifest Installation

| Feature     | **Helm Install (Method 1)**   | **Manifests (Method 2)**     |
| ----------- | ----------------------------- | ---------------------------- |
| Flexibility | High (override `values.yaml`) | Low (default configs only)   |
| Ease of Use | Requires Helm                 | Works with just kubectl      |
| Best for    | Production & customization    | Quick demo / lab environment |

## Professional Best Practices

* For **local demo/testing**, use **kubectl apply**.
* For **production or enterprise**, use **Helm** (better upgrades & customization).
* Always separate namespaces (don’t install into default).
* Store Application CRDs in Git repositories (GitOps best practice).
