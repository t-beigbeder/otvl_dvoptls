FROM debian:12

RUN apt-get update \
  && apt-get install -y \
    curl \
    openssh-client \
    rsync \
    procps \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/local/bin \
  && curl -fL https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini

COPY cs_ops.sh /usr/local/bin/

USER 2001
