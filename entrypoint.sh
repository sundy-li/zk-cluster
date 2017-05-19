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

zkHosts=(`echo $ZK_SERVERS  | awk -F, 'OFS=" "{$1=$1;print $0}'`)
for index in ${!zkHosts[@]}
do
    ZKID=$(($index+1))
    ZKIP=${zkHosts[index]}
    ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"server.$ZKID=$ZKIP:2888:3888"
done
echo "$ZOOKEEPER_CONFIG" > conf/zoo.cfg
/bin/bash bin/zkServer.sh start-foreground