#
# Pushpin Dockerfile
#
# https://github.com/sacheendra/docker-pushpin
#

# Pull the base image
FROM dockerfile/ubuntu
MAINTAINER Sacheendra Talluri <sacheendra.t@gmail.com>

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y pkg-config libqt4-dev libqca2-dev \
  libqca2-plugin-ossl libqjson-dev libzmq3-dev python-zmq \
  python-setproctitle python-jinja2 python-tnetstring \
  zurl libzmq3-dev libsqlite3-dev sqlite3

# Install Mongrel2
RUN \
  git clone git://github.com/zedshaw/mongrel2.git /tmp/mongrel2 && \
  cd /tmp/mongrel2 && \
  git submodule init && git submodule update && \
  rm -f tests/cert_tests.c && \
  make clean all && make install

RUN \
  DOCKER_HOST_IP=`ip route|awk '/default/ { print  $3}'`

# Install Pushpin
RUN git clone git://github.com/fanout/pushpin.git /pushpin
 
RUN \ 
  cd /pushpin && \
  git submodule init && git submodule update

RUN \
  cd /pushpin && \
  make
  
RUN \
  cd /pushpin && \
  cp examples/config/pushpin.conf examples/config/internal.conf examples/config/routes .

RUN\
  cd /pushpin && \
  echo '*' `ip route|awk '/default/ { print  $3}'`':8080' > routes && \
  sed -i 's/push_in_http_addr=127.0.0.1/push_in_http_addr=0.0.0.0/' pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* && \
  rm -fr /tmp/*

# Define working directory
WORKDIR /pushpin

# Define default command
CMD ["/pushpin/pushpin"]

# Expose ports.
# - 7999: HTTP port to forward on to the app
# - 5561: HTTP port to receive real-time messages to update in the app
EXPOSE 7999
EXPOSE 5561
