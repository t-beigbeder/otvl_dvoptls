FROM debian:13-slim
RUN apt-get update \
  && apt-get install -y \
    curl \
    locales \
    openssh-client \
    rsync \
    procps \
    vim-tiny \
    bash-completion \
    git \
    python3 \
    python3-pip \
    virtualenv \
    make \
    dnsutils \
  && rm -rf /var/lib/apt/lists/*
RUN virtualenv /venv && \
    /venv/bin/pip install label-studio
RUN mkdir -p /lbs && \
  chown 2001:2001 /lbs

  USER 2001
ENV HOME /lbs
WORKDIR /lbs
