#!/bin/bash
#screen wrapper which starts recording 
#on the interface defined as 'server' interface
#see ./vars.sh
#usage
#./start_rec_server.sh  <dumpsubdir>
#example 
#./start_rec_server.sh test1

screen -d -m -S screen_server /home/nbox/nbox_scripts/start_rec_server_cmd.sh ${1}

