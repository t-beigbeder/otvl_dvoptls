FROM t-ctr.otvl.org/code-server-base:4.104.1-p1

USER root
RUN apt-get update \
  && apt-get install -y \
    python3 \
    python3-pip \
    virtualenv \
    make \
    dnsutils \
  && rm -rf /var/lib/apt/lists/*
USER 2001
