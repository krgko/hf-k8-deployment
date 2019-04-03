## Command for kubectl

1. `kubectl create -f {config_file}`
2. `kubectl delete -f {config_file}`
3. `kubectl cluster-info` - to show cluster info
4. `kubectl get {pod,pv,pvc,rc,svc}`
5. `kubectl describe {pod,pv,pvc,rc,svc}`

## How to add file to kubernetes network on mikikube

1. `minikube mount {current}:{destination}` - to move file to master node
2. Access minikube command line
3. Check file existance
4. Copy folder to master node (because if unmount the folder will lost)

**Note**: To check kubernetes master node file existance `minikube ssh`

## How to set pv and pvc

1. define config persistentVolume
2. define config persistentVolumeClaim
3. add volumes field to container which need to mount volume