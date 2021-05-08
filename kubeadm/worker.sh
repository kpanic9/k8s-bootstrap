#! /bin/bash -ex

source ./node-preparation.sh

# IP here is the master node's IP
# token and checksum can be found in the master node's kubeadm init command
kubeadm join $1:$2 \
--token $3 \
--discovery-token-ca-cert-hash sha256:$4
