FROM openjdk:8-jre-alpine
MAINTAINER sundyli <543950155@qq.com>

ARG VERSION=3.4.10
WORKDIR /opt/zookeeper

EXPOSE 2181 2888 3888

##download install
RUN apt-get install -y wget tar \
	&& wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-${version}/zookeeper-${version}.tar.gz \
	&& tar  -C /opt/zookeeper --strip-components=1 -xzvf zookeeper-${version}.tar.gz \
	&& rm zookeeper-${version}.tar.gz \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


##default config
ENV tickTime=2000
ENV dataDir=/data/zookeeper/
ENV dataLogDir=/var/log/zookeeper/
ENV clientPort=2181
ENV initLimit=5
ENV syncLimit=2

# add startup script
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/usr/share/zookeeper/entrypoint.sh"]