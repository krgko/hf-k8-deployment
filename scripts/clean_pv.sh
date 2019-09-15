#!/bin/bash

echo "Removing files ..."
cd ../hyperledger-prerequisite/artifact
find . ! -name '*.block' ! -name '*.tx' -type f -exec rm -f {} +
cd ../../scripts
rm -rfv ../hyperledger-prerequisite/ca-server/*
rm -rfv ../hyperledger-prerequisite/ledgers/orderer/*
rm -rfv ../hyperledger-prerequisite/ledgers/peer0-org1/*