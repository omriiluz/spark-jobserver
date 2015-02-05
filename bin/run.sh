#!/bin/bash

source /root/spark_files/configure_spark.sh

IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
echo "WORKER_IP=$IP"

echo "preparing Spark"
prepare_spark $1

source $SPARK_HOME/conf/spark-env.sh

echo "preparing Job Server"
touch $INSTALL_DIR/settings.sh
sed -ri "s#local\[4\]#$MASTER#g" $INSTALL_DIR/server.conf

echo "Run jobserver"
cd $INSTALL_DIR
./server_start.sh
while [ 1 ];
do
    tail -f $LOG_DIR/spark-job-server.log
    sleep 3
done
