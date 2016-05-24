#!/bin/bash
#usage: ./get-S-ackrtt.sh <server-side.pcap> <output.csv> 
#example
#./get-S-ackrtt.sh /storage/n2disk/eth3/tmp/1.pcap /storage/analysis/eth3/1pcap_ackrtt_Sonly.txt
#<server-side.pcap> record on the server side, otherwise analysis may not make much sense
#pick only tcp ack segments targeting server (hence ip.dst)
#ip.dst==10.0.3.1/24
tshark -r ${1} -2 -R "tcp.analysis.ack_rtt and ip.dst==${SERVER_IP}" -e frame.number -e frame.time_epoch -e frame.time_relative -e tcp.analysis.ack_rtt -T fields -E separator=, -E header=y > ${2}


