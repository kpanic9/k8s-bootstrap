# kubeadm

kubeadm is a tool used for bootstraping Kubernetes clusters. 
Scripts included here can be used for creating single master 
multi worker cluster using Ubuntu servers.

## Steps

1. Get the scripts on master node 
2. Update the master-ip in master.sh
3. Run below command
```bash
./master.sh <master-node-ip> 
```
4. Get scripts on worker node
5. Update the master ip, token and checksum
6. Run below command
```bash
./worker.sh <master-node-ip> <api-server-port> <token> <certificate-hash>
```


## TODO

1. Scirpts are currently building the Kubernetes cluster with version
1.19, needs to parameterize the Kubernetes version.
