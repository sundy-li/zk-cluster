#!/bin/bash

## ZK_ID is the id in myid file, ZK_SERVERS is the the zk cluster servers in zoo.cfg
export ZK_ID=$1
export ZK_SERVERS=$2

mkdir -p $dataDir
mkdir -p $dataLogDir

echo "${ZK_ID}" > $dataDir/myid

#build zookeeper config file
ZOOKEEPER_CONFIG=
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"tickTime=$tickTime"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataDir=$dataDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataLogDir=$dataLogDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"clientPort=$clientPort"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"initLimit=$initLimit"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"syncLimit=$syncLimit"

# Put all ZooKeeper server IPs into an array:
IFS=', ' read -r -a ZOOKEEPER_SERVERS_ARRAY <<< "$ZK_SERVERS"
export ZOOKEEPER_SERVERS_ARRAY=$ZOOKEEPER_SERVERS_ARRAY
# now append information on every ZooKeeper node in the ensemble to the ZooKeeper config:
for index in "${!ZOOKEEPER_SERVERS_ARRAY[@]}"
do
    ZKID=$(($index+1))
    ZKIP=${ZOOKEEPER_SERVERS_ARRAY[index]}
    ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"server.$ZKID=$ZKIP:2888:3888"
done
# Finally, write config file:
echo "$ZOOKEEPER_CONFIG" | tee conf/zoo.cfg

# start the server:
/bin/bash bin/zkServer.sh start-foreground
