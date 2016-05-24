#!/bin/bash
#set -x
#runs www test:
#usage ./run_www_test.sh <testname>
#testname will be used to create dump directories

if (( $# != 1 )); then
    echo "Test name needed as parameter; example:"
    echo "./run_www_test.sh my_test"
    echo "Exiting..."
    exit 1
fi

cd /home/nbox/nbox_scripts

source ./vars.sh 



DUMPDIR_C=/storage/n2disk/${ethC}/${1}
DUMPDIR_S=/storage/n2disk/${ethS}/${1}


if [ ! -d "${DUMPDIR_C}" ] ; then
  sudo mkdir -p "${DUMPDIR_C}"
  sudo chmod 777 "${DUMPDIR_C}"
  sudo chown n2disk:n2disk "${DUMPDIR_C}"
  NEXT_C_FID=1
else
  NEXT_C_FID=$((`cat ${DUMPDIR_C}/.n2disk | cut -f1`+1)) 
fi

if [ ! -d "${DUMPDIR_S}" ] ; then
  sudo mkdir -p "${DUMPDIR_S}"
  sudo chmod 777 "${DUMPDIR_S}"
  sudo chown n2disk:n2disk "${DUMPDIR_S}"

  NEXT_S_FID=1
else
  NEXT_S_FID=$((`cat ${DUMPDIR_S}/.n2disk | cut -f1`+1))
fi

NEXT_C_FNAME=${NEXT_C_FID}.pcap.tmp
NEXT_S_FNAME=${NEXT_S_FID}.pcap.tmp

RES_DUMPDIR_C=/storage/analysis/${ethC}/${1}
RES_DUMPDIR_S=/storage/analysis/${ethS}/${1}

MNT_RES_DUMPDIR_C=/mnt/z/Users/nbox/${ethC}/${1}
MNT_RES_DUMPDIR_S=/mnt/z/Users/nbox/${ethS}/${1}


if [ ! -d "${RES_DUMPDIR_C}" ] ; then
  mkdir -p "${RES_DUMPDIR_C}"
fi

if [ ! -d "${RES_DUMPDIR_S}" ] ; then
  mkdir -p "${RES_DUMPDIR_S}"
fi


./start_rec_client.sh ${1}
./start_rec_server.sh ${1}



#wait until client dump file is ready
while [ ! -f "${DUMPDIR_C}/${NEXT_C_FNAME}" ]
do
    inotifywait -qqt 2 -e create ${DUMPDIR_C}
    echo "Wait for recorder to start"
done

#wait until server dump file is ready
while [ ! -f "${DUMPDIR_C}/${NEXT_S_FNAME}" ]
do
    inotifywait -qqt 2 -e create ${DUMPDIR_S}
    echo "Wait for recorder to start"
done

./start_www_transfer.sh &

wait

./stop_rec_client.sh ${1}
./stop_rec_server.sh ${1}

NEXT_C_FNAME=${NEXT_C_FID}.pcap
NEXT_S_FNAME=${NEXT_S_FID}.pcap

#wait until client dump file is ready
while [ ! -f "${DUMPDIR_C}/${NEXT_C_FNAME}" ]
do
    inotifywait -qqt 2 -e create ${DUMPDIR_C}
    echo "Wait for recorder to stop"
done

#wait until server dump file is ready
while [ ! -f "${DUMPDIR_S}/${NEXT_S_FNAME}" ]
do
    inotifywait -qqt 2 -e create ${DUMPDIR_S}
    echo "Wait for recorder to stop"
done

#do analysis
echo "Extracting statistics, be patient..."
./get-S-ackrtt.sh ${DUMPDIR_S}/${NEXT_S_FNAME} ${RES_DUMPDIR_S}/ackrtt_${NEXT_S_FNAME}.csv &
./get-tcplost.sh ${DUMPDIR_C}/${NEXT_C_FNAME} ${RES_DUMPDIR_C}/tcplost_${NEXT_C_FNAME}.csv & 
./get-www-throughput.sh ${DUMPDIR_C}/${NEXT_C_FNAME} ${RES_DUMPDIR_C}/tcptput_${NEXT_C_FNAME}.csv ${TIMEBIN} &
wait

if [ ! -d "${MNT_RES_DUMPDIR_C}" ] ; then
  mkdir -p "${MNT_RES_DUMPDIR_C}"
fi

if [ ! -d "${MNT_RES_DUMPDIR_S}" ] ; then
  mkdir -p "${MNT_RES_DUMPDIR_S}"
fi

cp ${RES_DUMPDIR_S}/ackrtt_${NEXT_S_FNAME}.csv ${MNT_RES_DUMPDIR_S}/ackrtt_${NEXT_S_FNAME}.csv &
cp ${RES_DUMPDIR_C}/tcplost_${NEXT_C_FNAME}.csv ${MNT_RES_DUMPDIR_C}/tcplost_${NEXT_C_FNAME}.csv &
cp ${RES_DUMPDIR_C}/tcptput_${NEXT_C_FNAME}.csv ${MNT_RES_DUMPDIR_C}/tcptput_${NEXT_C_FNAME}.csv &

wait 

echo Results copied to
echo ${MNT_RES_DUMPDIR_C}
echo ${MNT_RES_DUMPDIR_S}
echo ==============
echo Test completed
echo ==============

