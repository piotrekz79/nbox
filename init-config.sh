#!/bin/bash

#configuration after restart

#mount z-drive
/home/nbox/nbox_scripts/mount-z.sh

#we saw Could not open /proc/net/vlan/config
sudo modprobe 8021q

#Set up environmental variables and 
#Set up network namespaces for interfaces indicated in vars.sh (typically eth1 and eth3)

sudo /home/nbox/nbox_scripts/ns-vlan-CS-config.sh

