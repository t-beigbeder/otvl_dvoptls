FROM debian:13-slim
ARG VDASURL=https://github.com/t-beigbeder/vdasync/releases/download/v0.12.2-tbd/vdasync-linux-amd64-v0.12.2-tbd.tgz

RUN apt-get update \
  && apt-get install -y \
    curl \
    openssh-client \
    rsync \
    procps \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/local/bin \
  && curl -fL https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && curl -fL $VDASURL -o /tmp/vdasync.tgz \
  && tar xf /tmp/vdasync.tgz -C /usr/local/bin \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash dv-user

COPY dv_ops.sh /usr/local/bin/
ENV USER=dv-user
USER 2001
