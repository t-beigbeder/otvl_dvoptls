FROM debian:12

RUN apt-get update \
  && apt-get install -y \
    curl \
    openssh-client \
    rsync \
    procps \
  && rm -rf /var/lib/apt/lists/*

COPY cs_ops.sh /usr/local/bin/

USER 2001
