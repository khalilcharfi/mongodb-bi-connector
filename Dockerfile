# Start from fresh debian stretch & add some tools
# note: rsyslog & curl (openssl,etc) needed as dependencies too
FROM debian:stretch
RUN apt update
RUN apt install -y rsyslog nano curl

# Download BI Connector to /mongosqld
WORKDIR /tmp
RUN mkdir /mongosqld
RUN curl https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-debian92-v2.14.3.tgz.tgz -o bi-connector.tgz
RUN tar -xvzf bi-connector.tgz
#RUN rm bi-connector.tgz
#RUN mv /tmp/mongodb-bi-linux-x86_64-debian92-v2.14.0 /mongosqld
RUN install -m755 mongodb-bi-linux-x86_64-debian92-v2.14.3.tgz/bin/mongo* /usr/local/bin/
# Setup default environment variables
ENV CONFIG_FILE "conf/mongo.conf"

# Start Everything
# note: we need to use sh -c "command" to make rsyslog running as deamon too
RUN service rsyslog start
CMD sh -c "/usr/local/bin/mongosqld --config=$CONFIG_FILE"
