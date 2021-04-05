#! /bin/bash -ex

source ./node-prepation.sh

echo "Configuring the master node."
kubeadm config images pull
kubeadm init \
--apiserver-advertise-address=$1 \
--pod-network-cidr=10.244.0.0/16

echo "Deploying the flannel pod CNI."
kubectl --kubeconfig /etc/kubernetes/admin.conf apply \
-f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "Outputing kubeconfig file."
echo "====================================================="
cat /etc/kubernetes/admin.conf
echo "====================================================="
