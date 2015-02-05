FROM omriiluz/spark-base:1.2
MAINTAINER omri@iluz.net

# install SBT
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list  && \
  apt-get update && \
  apt-get install -y --no-install-recommends --force-yes apt-utils git sbt

# make jobserver
ENV INSTALL_DIR $SPARK_HOME/job-server
ENV LOG_DIR /var/log/job-server
ENV PIDFILE spark-jobserver.pid

ADD . /tmp/spark-jobserver
WORKDIR /tmp/spark-jobserver
RUN sbt job-server/assembly && \
  mkdir -p $INSTALL_DIR && \
  cp /tmp/spark-jobserver/bin/server_start.sh $INSTALL_DIR && \
  cp /tmp/spark-jobserver/bin/server_stop.sh $INSTALL_DIR && \
  cp /tmp/spark-jobserver/bin/run.sh $INSTALL_DIR && \
  cp /tmp/spark-jobserver/config/log4j-server.properties $INSTALL_DIR && \
  cp /tmp/spark-jobserver/config/local.conf.template $INSTALL_DIR/server.conf && \
  cp /tmp/spark-jobserver/job-server/target/spark-job-server.jar $INSTALL_DIR && \
  rm -rf /tmp/spark-jobserver

EXPOSE 8090

ENV PATH $INSTALL_DIR:$PATH

ENTRYPOINT ["run.sh"]
