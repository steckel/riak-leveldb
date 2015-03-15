# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.

FROM phusion/baseimage:0.9.15

MAINTAINER Curtis Steckel <curtis.steckel@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN \
    apt-get update; apt-get upgrade -y -qq; \
    apt-get install -y -qq wget; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    cd /tmp; \
    wget https://packagecloud.io/install/repositories/basho/riak/script.deb; \
    bash script.deb; \
    rm script.deb; \
    apt-get install -y -qq riak=2.0.0-1; \
    mkdir -p /etc/service/riak

# Copy local riak.conf file
COPY riak.conf /etc/riak/

# Copy executable file responsible for launching riak
COPY run /etc/service/riak/

# Expose the protocol buffer and http ports
EXPOSE 8098 8087

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
