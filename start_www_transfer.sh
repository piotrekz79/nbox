#!/bin/bash

NNS1=ns${ethC}
#-sS 
#sudo ip netns exec ${NNS1} curl http://${SERVER_IP}:${WWW_PORT}/char1G > /dev/null &

#sudo ip netns exec ${NNS1} wget http://10.0.3.1:8000/char10G -O /dev/null &
#sudo ip netns exec ${NNS1} wget http://10.0.3.1:8000/char10G -O /storage/garbage/delme.txt &
#--limit-rate 50000000
#sudo ip netns exec ${NNS1} wget http://${SERVER_IP}:${WWW_PORT}/${WWW_FILE} -O /storage/garbage/delme.txt --delete-after &
#sudo ip netns exec ${NNS1} curl http://${SERVER_IP}:${WWW_PORT}/${WWW_FILE} -o /storage/garbage/delme.txt  &

#for whatever reason aria does not save to other dir than current
cd /storage/garbage/
sudo ip netns exec ${NNS1} aria2c -o delme.txt http://${SERVER_IP}:${WWW_PORT}/${WWW_FILE}  &
cd /home/nbox/nbox_scripts

sudo ip netns exec ${NNS1} echo $! > /tmp/currwww
wait
echo Download done$'\n'
rm /tmp/currwww 
rm -f /storage/garbage/delme.txt
