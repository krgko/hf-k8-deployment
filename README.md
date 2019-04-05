# Deploy Hyperledger Fabric on Kubernetes

## Requirement

1. Minikube or kubeadm
2. Helm - application manager on k8s
3. Fabric-samples repository

### From scratch solution

1. Download configtxgen and cryptogen
2. Create channel artifact and genesis block
```
./configtxgen -profile {profile-name} -outputblock ./channel-artifact/genesis.block
```
3. Create certificates
```
./cryptogen generate --config={path-to-cluster-config.tx}
```

## How to install helm

Linux
```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

Then initialize
```
helm init
```