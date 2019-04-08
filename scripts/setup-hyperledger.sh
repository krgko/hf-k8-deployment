#!/bin/bash

# All of these will assign to function later
# Currently need to copy this when exec into cli

CHAINCODE_ID=couch # for this case only
CHANNEL_NAME=testchannel # for this case only
ORDERER_POD=$(kubectl get pods -o wide | grep orderer0 | awk '{print $1}') # for current fabric network only
ORDERER_URL=$(kubectl get pods -o wide | grep orderer0 | awk '{print $6}') # for current fabric network only
ORDERER_NAME=orderer.example.com
PEER_URL=$(kubectl get pods -o wide | grep peer | awk '{print $6}') # for current fabric network only
PEER_NAME=peer0.org1.example # for current fabric network only
PEER_POD=$(kubectl get pods -o wide | grep peer | awk '{print $1}') # for current fabric network only
TARGET_PEER=org1-peer0 # for current fabric network only
CLI_POD=$(kubectl get pods -o wide | grep cli | awk '{print $1}') # for current fabric network only
PATH_TO_CC=github.com/chaincode/couch/go # for this case only

isRoot() {
    if [ "$(whoami)" != root ]
    then
        echo "Need to run this script as root"
        exit 1
    fi
}

createChannel() {
    # create channel
    kubectl exec $CLI_POD -- peer channel create -c $CHANNEL_NAME -o $ORDERER_URL:7050 -f "./channel-artifacts/channel.tx"
    exit 0
}


joinChannel() {
    # join channel - channelName.block will assing later
    kubectl exec $CLI_POD -- peer channel join -b $CHANNEL_NAME.block -o $ORDERER_URL:7050
    exit 0
}

installChaincode() {
    # install chaincode
    kubectl exec $CLI_POD -- peer chaincode install -o $ORDERER_URL:7050 -n $CHAINCODE_ID -p $PATH_TO_CC -v "$1"
    exit 0
}

instantiateChaincode() {
    # instantiate chaincode
    # Need to set /etc/hosts first to make peer can connect to orderer
    # Create chaincode container before instantiate
    kubectl exec $CLI_POD -- peer chaincode instantiate -o $ORDERER_URL:7050 -C $CHANNEL_NAME -n $CHAINCODE_ID -v "$1" -c '{"Args":["Init", "a", "100", "b", "0"]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
    exit 0
}

setHosts() {
    echo "start set host for $1."
    # To setting hosts - append mode
    echo "kubectl exec $1 -c $TARGET_PEER echo \"$ORDERER_URL       $ORDERER_NAME\" >> /etc/hosts"
    kubectl exec $1 -c $TARGET_PEER -- bash -c "echo '$ORDERER_URL       $ORDERER_NAME' >> /etc/hosts" # it will not impact file system

    echo "set host for $1 completed."
    echo "start set host for $2"
    # To setting hosts - append mode
    echo "kubectl exec $2 echo \"$PEER_URL       $PEER_NAME\" >> /etc/hosts"
    kubectl exec $1 -- bash -c "echo '$PEER_URL       $PEER_NAME' >> /etc/hosts" # it will not impact file system

    echo "set host for $1 completed."
}

checkHosts() {
    peer_pod=$1
    orderer_pod=$2
    host=$(kubectl exec $peer_pod -c org1-peer0 cat /etc/hosts | grep $ORDERER_NAME) # hardcode for test
    if [ -z "$host" ]
    then
        setHosts $peer_pod $orderer_pod
    fi
    echo "required host existed"
}

main() {
    method=$1

    # Do stuff
    isRoot
    if [ "$method" == "create_channel" ]
    then
        createChannel
    elif [ "$method" == "join_channel" ]
    then
        joinChannel 
    elif [ "$method" == "install_chaincode" ]
    then
        installChaincode $2
    elif [ "$method" == "instantiate_chaincode" ]
    then
        checkHosts $PEER_POD $ORDERER_POD # hardcode for dev
        instantiateChaincode $2
    else
        echo "Usage:"
        echo "  ./setup-hyperledger.sh [Method] [Args]"
        echo
        echo "Methods:"
        echo "  create_channel                     Create hyperledger fabric channel"
        echo "  join_channel                       Join channel to peer"
        echo "  install_chaincode [version]        Install chaincode (no_args for now)"
        echo "  instantiate_chaincode [version]    Instantiate chaincode (no_args for now)"
        exit 1
    fi
}

main $1 $2