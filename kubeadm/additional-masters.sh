#!/bin/bash

source ./node-prepation.sh

echo "Configuring additional master nodes."
kubeadm config images pull

kubeadm join $1:$2 --token $3 \
--discovery-token-ca-cert-hash sha256:$4 \
--control-plane --certificate-key $5
