#! /bin/bash -ex

# update and install required tools
apt update
apt upgrade -y
apt install -y apt-transport-https curl

# make sure MAC address and product_uuid is unique for each node
ip link
cat /sys/class/dmi/id/product_uuid

# allow iptables to see bridged traffic
cat > /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
EOF

modprobe br_netfilter

cat > /etc/sysctl.d/k8s.conf <<EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

# install container runtime
apt install containerd -y
systemctl start containerd
systemctl enable containerd

# install kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg -o k8s.gpg
mv k8s.gpg /etc/apt/trusted.gpg.d/
cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
apt install -y kubelet=1.19.9-00 kubeadm=1.19.9-00 kubectl=1.19.9-00
apt-mark hold kubelet kubeadm kubectl		# disable auto updating kubeadm, kubelet and kubectl

systemctl enable kubelet
systemctl start kubelet

