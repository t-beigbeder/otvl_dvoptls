FROM t-ctr.otvl.org/code-server-base:4.102.1-p1

USER root
RUN apt-get update \
  && apt-get install -y \
    python3 \
    virtualenv \
    make \
    dnsutils \
  && rm -rf /var/lib/apt/lists/*
USER 2001
