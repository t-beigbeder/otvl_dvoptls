FROM debian:12

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    openssh-client \
    rsync \
    procps \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/local/bin \
  && curl -fL https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash cs-user

COPY cs_ops.sh /usr/local/bin/
ENV USER=cs-user
USER 2001
