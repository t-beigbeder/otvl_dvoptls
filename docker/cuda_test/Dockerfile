FROM docker.io/nvidia/cuda:13.0.1-base-ubuntu24.04

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

RUN mkdir -p /usr/local/lib /usr/local/bin /home/cs-user \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash cs-user \
  && mkdir /tools && chown 2001:2001 /tools

USER 2001
ENV LANG=en_US.UTF-8
ENV USER=cs-user
ENV HOME=/home/cs-user
RUN virtualenv /tools/venvs/pytorch && \
/tools/venvs/pytorch/bin/pip install -U pip && \
/tools/venvs/pytorch/bin/pip install --index-url https://download.pytorch.org/whl/cu130 torch numpy
