#  Install Metrics Server on Kubernetes (Full Guide)

> This guide ensures that the Metrics Server works **even on clusters with self-signed certificates**,
> which is why we include the `--kubelet-insecure-tls` fix.

---

##  Step 1: Install Metrics Server

Apply the official deployment manifest:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

This deploys:

* The Metrics Server deployment
* Required RBAC (ServiceAccount, ClusterRole, etc.)
* A Service to expose it internally

---

##  Step 2: Patch the Deployment (for insecure TLS clusters)

> **Why?** Most local clusters (like kubeadm, minikube, kind) use **self-signed TLS certificates** on the kubelets, which the Metrics Server can’t validate by default.

###  Fix this by editing the deployment:

```bash
kubectl edit deployment metrics-server -n kube-system
```

### 🔧 Add or update the `args` section to include:

```yaml
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
```

> You can leave other args like `--metric-resolution=15s` or `--kubelet-use-node-status-port` if already present.

###  Example Final `args` Section:

```yaml
args:
  - --cert-dir=/tmp
  - --secure-port=10250
  - --kubelet-insecure-tls
  - --kubelet-preferred-address-types=InternalIP
  - --metric-resolution=15s
```

Save and exit the editor.

---

##  Step 3: Allow scheduling on control-plane node (if required)

If you're running a **single-node control-plane** and Metrics Server is stuck in `Pending`:

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-
```

This removes the `NoSchedule` taint and allows pods to run on the control-plane node (OK for dev/test).

---

##  Step 4: Restart Metrics Server Pods

Force a restart so changes take effect:

```bash
kubectl delete pod -n kube-system -l k8s-app=metrics-server
```

Wait 10–20 seconds and check:

```bash
kubectl get pods -n kube-system | grep metrics-server
```

You want to see:

```
metrics-server-xxxxx   1/1   Running
```

---

##  Step 5: Test Metrics Server

Run:

```bash
kubectl top nodes
kubectl top pods
```

 If working, you'll see live CPU and memory stats.

Example:

```bash
NAME            CPU(cores)   MEMORY(bytes)
control-plane   102m         250Mi

NAME             CPU(cores)   MEMORY(bytes)
nginx-pod        2m           15Mi
```

---

##  Optional Cleanup

### Reduce replicas (for dev/test):

```bash
kubectl scale deployment metrics-server -n kube-system --replicas=1
```
### Check logs if issues:

```bash
kubectl logs -n kube-system -l k8s-app=metrics-server
```
---
##  References

- [Official Metrics Server Installation Guide](https://github.com/kubernetes-sigs/metrics-server)
- [Direct Installation Manifest](https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml)
