# zk-cluster
zk-cluster for docker

## docker-hub
	https://hub.docker.com/r/sundyli/zk-cluster/

## usage
	- dataDir: /data/db/
	- logDri: /data/log/

## example
```
docker run --net host --name zk \
	-p 2181:2181 \
	-p 2888:2888 \
	-p 3888:3888 \
	-v /data/db/zk:/data/db/ \
	-v /data/logs/zk:/var/log/ \
	-d sundyli/zk-cluster  ${id} lp2,lp3,lp4 
```