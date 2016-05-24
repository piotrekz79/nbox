#!/bin/bash
#usage: ./get-tcplost.sh <file.pcap> <output.csv> 
#example
#./get-S-ackrtt.sh /storage/n2disk/eth3/tmp/1.pcap /storage/analysis/eth3/1pcap_ackrtt_Sonly.txt
#probably mostly useful if <file.pcap> is on client side although lost ACKs from client may also be interesting?
#note such a lost segment is (very) likely to be followed by 'retransmission' OR 'out-of-order'
tshark -r ${1} -2 -R "tcp.analysis.lost_segment and ip.dst==${CLIENT_IP}" -e frame.number -e frame.time_epoch -e frame.time_relative -e tcp.analysis.lost_segment -T fields -E separator=, -E header=y > ${2}


