#!/bin/bash
#bytes and frames transferred from WWW server to a given client
#traffic from client to server (mostly ACKs) is ignored
#data.pcap can be recorded both at client or server side, although
#client side probably is more useful

#usage: ./get-www-throughput.sh <data.pcap> <result.csv> <timebin[s]>
#example
#./get-www-throughput.sh /storage/n2disk/eth1/13.pcap /storage/analysis/eth1/13cap_1.csv 0.1
#TODO: only one client assumed client/server parameters as env. variables can be passed as args
tshark -q -r ${1} -z "io,stat,${3},ip.dst==${CLIENT_IP}&&tcp.srcport==${WWW_PORT}" > ${2}.tmp

#find duration value in the header
#sometimes last bin has string "Dur" and we want to replace it with the value
#from file preamble
#find line with "Duration" and then get a number
DUR=`egrep Duration ${2}.tmp | egrep -o "[0-9]*\.?[0-9]+"`

#find preamble length by looking for line number (-n) of
#occurence of '|-' pattern. stop after finding second one
#(-m 2), use only last line and get the number only by splittig after ":"
HDR=`grep -n -m 2  '|-' ${2}.tmp | tail -1 | cut -d: -f1`

#remove first HDR (most probably 12) and last line
#replace <> with comma
#remove first and then last char 
#replace remaining '|' with commas
#remove all the spaces
#double quotes around $DUR commands seem to be needed to expand DUR correctly

echo "bin_start,bin_end,frames,bytes" > ${2}
sed '1,'"$HDR"'d;$d;s/<>/,/;s/^.//;s/.$//;s/|/,/g;s/ //g;s/Dur/'"$DUR"'/' ${2}.tmp >> ${2}
#rm ${2}.tmp

