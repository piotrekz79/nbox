#!/bin/bash
#screen wrapper which starts recording 
#on the interface defined as 'client' interface
#see ./vars.sh
#usage
#./start_rec_client.sh  <dumpsubdir>
#example 
#./start_rec_client.sh test1

screen -d -m -S screen_client /home/nbox/nbox_scripts/start_rec_client_cmd.sh ${1}

