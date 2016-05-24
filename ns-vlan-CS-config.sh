#!/bin/bash

source /home/nbox/nbox_scripts/vars.sh

#TODO perhaps use is_var_defined.sh
if [ ! -v ethC ]; then echo "Variable ethC not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v ethS ]; then echo "Variable ethS not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v CLIENT_IP ]; then echo "Variable CLIENT_IP not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v CLIENT_SNM ]; then echo "Variable CLIENT_SNM not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v SERVER_IP ]; then echo "Variable SERVER_IP not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v SERVER_SNM ]; then echo "Variable SERVER_SNM not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v WWW_PORT ]; then echo "Variable WWW_PORT not set. Sourcing vars.sh may help"; exit; fi
if [ ! -v VLANID ]; then echo "Variable VLANID not set. Sourcing vars.sh may help"; exit; fi



PHY1=${ethC}
MAC1=`ifconfig ${PHY1} | egrep -o "([[:xdigit:]]{2}[:-]){5}([[:xdigit:]]{2})"`
IP1=${CLIENT_IP}
SNM1=${CLIENT_SNM}

NNS1=ns${PHY1}



PHY2=${ethS}
MAC2=`ifconfig ${PHY2} | egrep -o "([[:xdigit:]]{2}[:-]){5}([[:xdigit:]]{2})"`
IP2=${SERVER_IP}
SNM2=${SERVER_SNM}

NNS2=ns${PHY2}


ip netns add ${NNS1}
ip link set ${PHY1} netns ${NNS1}
ip netns exec ${NNS1} ifconfig ${PHY1} up
ip netns exec ${NNS1} ifconfig ${PHY1} inet 0

ip netns exec ${NNS1} vconfig add ${PHY1} ${VLANID}
ip netns exec ${NNS1} ifconfig ${PHY1}.${VLANID} up
ip netns exec ${NNS1} ifconfig ${PHY1}.${VLANID} ${IP1}/${SNM1} up

ip netns exec ${NNS1} route add -host ${IP2} ${PHY1}.${VLANID}
ip netns exec ${NNS1} arp -s ${IP2} ${MAC2}



ip netns add ${NNS2}
ip link set ${PHY2} netns ${NNS2}
ip netns exec ${NNS2} ifconfig ${PHY2} up
ip netns exec ${NNS2} ifconfig ${PHY2} inet 0

ip netns exec ${NNS2} vconfig add ${PHY2} ${VLANID}
ip netns exec ${NNS2} ifconfig ${PHY2}.${VLANID} up
ip netns exec ${NNS2} ifconfig ${PHY2}.${VLANID} ${IP2}/${SNM2} up

ip netns exec ${NNS2} route add -host ${IP1} ${PHY2}.${VLANID}
ip netns exec ${NNS2} arp -s ${IP1} ${MAC1}

#this is server network namespace - start www server
ip netns exec ${NNS2} service nginx restart
CHECK_SERVER=`ip netns exec ${NNS2} netstat -pan | grep -w "${WWW_PORT}"`
if [ ! -v CHECK_SERVER ]
then 
  echo Warning! Server did not start ?
fi


echo "to test:"
echo "ip netns exec ${NNS2} ping ${IP1}"


