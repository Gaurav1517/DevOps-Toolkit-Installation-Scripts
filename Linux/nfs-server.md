# **NFS server configuration** on a **RHEL/CentOS/Fedora-based system** using `dnf`:

###  **1. Update and install required packages**

```bash
dnf update -y
dnf install -y nfs-utils vim
```

---

###  **2. Create the NFS export directory**

```bash
mkdir -p /nfs/share
```

> Make sure to set proper permissions depending on your use case:

```bash
chmod 777 /nfs/share  # Open access for testing
# or for specific ownership
chown nfsnobody:nfsnobody /nfs/share
```

---

###  **3. Configure NFS exports**

Edit the `/etc/exports` file:

```bash
vim /etc/exports
```

Add this line:

```
/nfs/share *(rw,no_root_squash,sync)
```

* `*`: Allow access from any host (not recommended for production)
* `rw`: Read/write access
* `no_root_squash`: Prevent root UID remapping (use with caution)
* `sync`: Ensure changes are written to disk before the command returns

>  **Security tip**: Replace `*` with a specific IP or subnet like `192.168.1.0/24` for better security.

---

###  **4. Start and enable NFS services**

```bash
systemctl start nfs-server
systemctl enable nfs-server
```

If firewalld is running, open NFS-related ports:

```bash
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
```

---

###  **5. Export the shared directories**

```bash
exportfs -rv
```

* `-r`: Re-read the `/etc/exports`
* `-v`: Verbose output

---

###  **6. Verify NFS share**

```bash
exportfs -v
```

You should see:

```
/nfs/share   <world>(rw,wdelay,no_root_squash,sync,no_subtree_check)
```

---

###  **7. (Optional) Enable services on boot**

Already covered with:

```bash
systemctl enable nfs-server
```

---

###  Full script (automated version)

If you're automating:

```bash
#!/bin/bash
dnf update -y
dnf install -y nfs-utils vim

mkdir -p /nfs/share
chmod 777 /nfs/share

echo "/nfs/share *(rw,no_root_squash,sync)" >> /etc/exports

systemctl enable --now nfs-server

firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload

exportfs -rv
```
