#!/bin/bash
#starts recording on the interface defined as 'server' interface
#see ./vars.sh
#usage
#./start_rec_server.sh  <dumpsubdir>
#example 
#./start_rec_server.sh test1

if [ ! -v ethS ] 
then
  echo "Variable ethS not set. Sourcing vars.sh may help"
  exit
fi

DUMPDIR=/storage/n2disk/${ethS}/${1}

#without --pid non-existig directory would be created but we get error
#so we have to handle it manually
if [ ! -d "${DUMPDIR}" ] ; then
  sudo mkdir -p "${DUMPDIR}"
  sudo chmod 777 "${DUMPDIR}"
  sudo chown n2disk:n2disk "${DUMPDIR}"
fi

#TODO --hugepages
sudo n2disk10gzc --reader-cpu-affinity 0 --writer-cpu-affinity 1 -g \
--max-file-len 2000 --snaplen 100 \
--capture-direction 0 -i ${ethS} --chunk-len 1024  \
--dump-directory "${DUMPDIR}" --pid "${DUMPDIR}"/currpid 

