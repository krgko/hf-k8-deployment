#!/bin/bash

# All of these will assign to function later
# Currently need to copy this when exec into cli

# create channel
peer channel create -C testchannel -o 172.17.0.9:7050 --outputBlock './testchannel.block'

# join channel - channelName.block will assing later
peer channel join -b testchannel.block

# install chaincode
peer chaincode install -o 172.17.0.9:7050 -n couch -p github.com/couch/go -v 0.1

# instantiate chaincode
# Need to set /etc/hosts first to make peer can connect to orderer
# Create chaincode container before instantiate
peer chaincode instantiate -o 172.17.0.9:7050 -C testchannel -n couch -v 0.1 -c '{"Args":[]}'

# To setting hosts
# echo "172.17.0.9     orderer.example.com" >> /etc/hosts