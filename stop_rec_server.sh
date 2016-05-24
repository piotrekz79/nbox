#!/bin/bash
#stops recording on the interface defined as 'server' interface
#dumping to <dumpsubdir> and started by start_rec_server.sh (uses #screen)
#see vars.sh for 'server' configuration
#usage
#./stop_rec_server.sh  <dumpsubdir>
#example 
#./stop_rec_server.sh test1

#send SIGTERM to n2disk (=ctrl-c on open screen)
#open in server_screen - screen will also terminate then
screen -S screen_server -X stuff $'\003'

