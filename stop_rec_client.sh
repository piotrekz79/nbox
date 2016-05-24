#!/bin/bash
#stops recording on the interface defined as 'client' interface
#dumping to <dumpsubdir> and started by start_rec_client.sh (uses #screen)
#see vars.sh for 'client' configuration
#usage
#./stop_rec_client.sh  <dumpsubdir>
#example 
#./stop_rec_client.sh test1

#send SIGTERM to n2disk (=ctrl-c on open screen)
#open in client_screen - screen will also terminate then
screen -S screen_client -X stuff $'\003'

