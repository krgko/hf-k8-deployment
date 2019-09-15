#!/bin/bash

echo "Clear container and image inside dind ..."

set -v
PEERPOD=$(kubectl get pods | grep peer | awk '{print $1}')

DOCKERPS=$(kubectl exec -it $PEERPOD -c dind -- docker ps -aq)
kubectl exec -it $PEERPOD -c dind -- sh -c "docker rm -f ${DOCKERPS}"

DOKERIMGS=$(kubectl exec -it $PEERPOD -c dind -- docker images | grep dev-peer | awk '{print $3}') 
kubectl exec -it $PEERPOD -c dind -- docker rmi -f $DOKERIMGS 
