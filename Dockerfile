FROM openjdk:8u275-jre

WORKDIR /opt

ENV HADOOP_HOME=/opt/hadoop-2.10.1
ENV HIVE_HOME=/opt/apache-hive-2.3.8-bin
# Include additional jars
ENV HADOOP_CLASSPATH=/opt/hadoop-2.10.1/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.199.jar:/opt/hadoop-2.10.1/share/hadoop/tools/lib/hadoop-aws-2.10.1.jar

RUN apt-get update && \
    curl -L https://www-us.apache.org/dist/hive/hive-2.3.8/apache-hive-2.3.8-bin.tar.gz | tar zxf - && \
    curl -L https://www-us.apache.org/dist/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz | tar zxf - && \
    apt-get install -y libk5crypto3 libkrb5-3 libsqlite3-0

RUN apt-get -y install vim
RUN apt-get update && \
    apt-get -y install mariadb-server &&\
    apt-get -y install libmariadb-java &&\
    ln -s /usr/share/java/mariadb-java-client.jar ${HIVE_HOME}/lib/mariadb-java-client.jar

COPY conf ${HIVE_HOME}/conf
RUN mkdir -p /tmp
RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} /tmp

USER hive
# WORKDIR $HIVE_HOME
EXPOSE 9083

COPY setup.sh .
ENTRYPOINT ["./setup.sh"]

# ENTRYPOINT ["bin/hive"]
# CMD ["--service", "metastore"]
