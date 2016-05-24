#!/bin/bash
#starts recording on the interface defined as 'client' interface
#see vars.sh
#usage
#./start_rec_client.sh  <dumpsubdir>
#example 
#./start_rec_client.sh test1

if [ ! -v ethC ] 
then
  echo "Variable ethC not set. Sourcing vars.sh may help"
  exit
fi

DUMPDIR=/storage/n2disk/${ethC}/${1}

#without --pid non-existig directory would be created but we get error
#so we have to handle it manually
if [ ! -d "${DUMPDIR}" ] ; then
  sudo mkdir -p "${DUMPDIR}"
  sudo chmod 777 "${DUMPDIR}"
  sudo chown n2disk:n2disk "${DUMPDIR}"
fi

#TODO  --hugepages
sudo n2disk10gzc --reader-cpu-affinity 2 --writer-cpu-affinity 3 -g \
--max-file-len 2000 --snaplen 100 \
--capture-direction 0 -i ${ethC} --chunk-len 1024 \
--dump-directory "${DUMPDIR}" --pid "${DUMPDIR}"/currpid
