#!/bin/sh
#source this file using on the prompt
#source ./vars.sh

#set these varaibles to configure client and server side
#TODO: multiple clients/servers?

export ethC=eth1
export ethS=eth3

export CLIENT_IP=10.0.1.1
export CLIENT_SNM=24 #subnet mask length

export SERVER_IP=10.0.3.1
export SERVER_SNM=24 #subnet mask length+

export WWW_PORT=8000

export VLANID=4001

#for tcp throughput calculation
export TIMEBIN=0.001

export WWW_FILE=char1G
#can also use a big one
#export WWW_FILE=char10G



