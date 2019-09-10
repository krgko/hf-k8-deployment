# Script usage

1. start.py - `python start.sh -t {hyperledger_component}` to start create pods
2. stop.py - Opposite of start.py
3. setup-hyperledger.sh - Execute this after all of component running without failure

## When minikube broken

Remove current minikube from virtualbox and `minikube delete` then try to `minikube start`

## Before start minikube

- Mount resources to master node `minikube mount ../hyperledger-prerequisite:/mnt/sda1/mounted`

## When chaincode container cannot start

Try to remove chaincode docker images inside minikube cluster access by `minikube ssh`
