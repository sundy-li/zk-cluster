FROM java:openjdk-8-jre
MAINTAINER sundyli <543950155@qq.com>

ARG version=3.4.10
WORKDIR /opt/zookeeper

EXPOSE 2181 2888 3888


##download install
RUN set -x \
    && apt-get install -y wget tar \
	&& wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-${version}/zookeeper-${version}.tar.gz \
	&& tar  -C /opt/zookeeper --strip-components=1 -xzvf zookeeper-${version}.tar.gz \
	&& rm zookeeper-${version}.tar.gz \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


##default config
ENV tickTime=2000
ENV dataDir=/data/db/
ENV dataLogDir=/data/log/
ENV clientPort=2181
ENV initLimit=5
ENV syncLimit=2

# add startup script
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/opt/zookeeper/entrypoint.sh"]