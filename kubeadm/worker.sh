#! /bin/bash -ex

source ./node-preparation.sh

# IP here is the master node's IP
# token and checksum can be found in the master node's kubeadm init command
kubeadm join 192.168.64.2:6443 \
--token 1c4tcb.7xk3jijpbmx77kjs \
--discovery-token-ca-cert-hash sha256:720ee3a2d96bc2ef4d6d1aceca67ae41956fe5fee8ae7e62a4a53b0cb624eb47
