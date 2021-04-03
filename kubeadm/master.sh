#! /bin/bash -ex

source ./node-prepation.sh

echo "Configurong the master node."
kubeadm config images pull
kubeadm init \
--apiserver-advertise-address=192.168.64.2 \    # master node ip address
--pod-network-cidr=10.244.0.0/16 \
--ignore-preflight-errors=NumCPU

echo "Deploying the flannel pod CNI."
kubectl --kubeconfig /etc/kubernetes/admin.conf apply \
-f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "Outputing kubeconfig file."
echo "====================================================="
cat /etc/kubernetes/admin.conf
echo "====================================================="
