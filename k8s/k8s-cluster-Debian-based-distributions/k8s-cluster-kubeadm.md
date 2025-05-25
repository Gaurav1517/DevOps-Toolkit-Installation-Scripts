# Kubernetes HA Cluster Setup with HAProxy, Master, and Worker Nodes

This guide helps you set up a high availability Kubernetes cluster using HAProxy as the load balancer, along with multiple master and worker nodes.

---

## 🔐 SSH into All Nodes

```bash
ssh -i private-key.pem ubuntu@<IP_ADDRESS>
sudo su
```

---

## 🖥️ Hostname Setup (Run on Respective Nodes)

```bash
hostnamectl set-hostname haproxy && bash
hostnamectl set-hostname master-01 && bash
hostnamectl set-hostname master-02 && bash
hostnamectl set-hostname worker-01 && bash
hostnamectl set-hostname worker-02 && bash
```

---

## 📦 System Update and Dependency Installation (All Nodes)

```bash
apt-get update -y
apt-get install net-tools -y  # for ping, ifconfig
ifconfig
```

---

## 🧭 Add Host Entries (All Nodes)

```bash
sudo bash -c 'cat >> /etc/hosts <<EOF
172.31.86.30 haproxy
172.31.83.94 master-01
172.31.85.77 master-02
172.31.90.11 worker-01
172.31.89.182 worker-02
EOF'
```

Verify with:

```bash
ping -c 4 haproxy
ping -c 4 master-01
ping -c 4 master-02
ping -c 4 worker-01
ping -c 4 worker-02
```

---

## 🔒 SELinux & Swap (All Nodes)

```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

---

## 🌐 HAProxy Configuration (Only on haproxy Node)

```bash
apt install haproxy -y

sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null <<EOF
frontend Kubernetes
  bind *:6443
  option tcp-check
  mode tcp 
  default_backend kube-masters

backend kube-masters
  mode tcp
  option tcp-check
  balance roundrobin
  server master01 172.31.83.94:6443 check
  server master02 172.31.85.77:6443 check 
EOF
```

Test and start HAProxy:

```bash
sudo haproxy -c -f /etc/haproxy/haproxy.cfg
sudo systemctl start haproxy
sudo systemctl enable haproxy
sudo systemctl status haproxy
```

---

## ⚙️ Kernel Modules & Sysctl (All Nodes)

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
```

Verify:

```bash
lsmod | grep br_netfilter
lsmod | grep overlay
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```

---

## 📦 Install containerd (All Nodes)

```bash
curl -LO https://github.com/containerd/containerd/releases/download/v1.7.24/containerd-1.7.24-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local/ containerd-1.7.24-linux-amd64.tar.gz

curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo sed -n '/SystemdCgroup /p' /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable containerd.service
sudo systemctl start containerd.service
sudo systemctl status containerd.service
```

---

## 🔧 Install Kubernetes Components (All Nodes)

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet
```

---

## 🚀 Initialize Kubernetes Control Plane (On Master-01 Only)

```bash
sudo kubeadm init --control-plane-endpoint "172.31.86.30:6443" --upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## 📡 Install Calico Network Plugin

```bash
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.5/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml
kubectl -n kube-system get pods
```

---

## 🧩 Join Other Nodes

### Join Master-02

```bash
kubeadm join <haproxy-IP>:6443 --token <token> \
--discovery-token-ca-cert-hash sha256:<hash> \
--control-plane --certificate-key <cert-key>
```

### Join Worker Nodes

```bash
kubeadm join <haproxy-IP>:6443 --token <token> \
--discovery-token-ca-cert-hash sha256:<hash>
```

---

## 🛠️ Troubleshooting

```bash
kubeadm reset -y
rm -rf /etc/cni/
rm -rf .kube/
rm -rf /etc/kubernetes
rm -rf /var/lib/etcd
rm -rf /var/lib/kubelet/

systemctl restart kubelet.service containerd.service
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --service-cidr=10.127.44.0/24 \
--kubernetes-version=1.30.0 --control-plane-endpoint "172.31.86.30:6443" --upload-certs
```

---

## 🔍 Verifications and Test Pods

```bash
kubectl get nodes
kubectl get nodes -o wide

kubectl run test --image=nginx
kubectl run dev --image=nginx

kubectl get pod -o wide
kubectl exec -it test -- /bin/bash
curl <dev-pod-IP>
exit

kubectl exec -it dev -- /bin/bash
curl <test-pod-IP>
exit

kubectl delete pod test dev
```

> ℹ️ Ensure all commands go through the HAProxy endpoint.

```bash
cat ~/.kube/config | grep -i server:
```

---

## 📚 Reference

* [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
* [Calico Networking](https://docs.tigera.io/calico/3.27/getting-started/kubernetes/self-managed-onprem/onpremises)
* [Containerd Setup](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)

---

✅ You now have a basic High Availability Kubernetes Cluster with two control planes
and two workers running behind an HAProxy load balancer!
