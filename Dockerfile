#
# Haproxy Dockerfile
#
# https://github.com/dockerfile/haproxy
#

# Pull base image.
FROM ubuntu:14.04

# Install Haproxy.
RUN \
  sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y haproxy=1.5.3-1~ubuntu14.04.1 && \
  apt-get install -y curl && \
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/consul-template https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz && \
  cd /tmp && \
  tar -xf consul-template && \
  cp consul-template_0.10.0_linux_amd64/consul-template /usr/local/bin/consul-template && \
  chmod a+x /usr/local/bin/consul-template

# Add files.
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD haproxy.ctmpl /etc/haproxy/haproxy.ctmpl
ADD start.bash /haproxy-start
ADD reload.bash /haproxy-reload

# Define mountable directories.
VOLUME ["/haproxy-override"]

# Define working directory.
WORKDIR /etc/haproxy

# Define default command.
CMD ["bash", "/haproxy-start"]

# Expose ports.
EXPOSE 5000
EXPOSE 8001
