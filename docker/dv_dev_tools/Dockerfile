FROM debian:13

ARG GOU=https://go.dev/dl/go1.25.5.linux-amd64.tar.gz

USER root
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
    file \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN mkdir -p /usr/local/bin && \
  curl -fL $GOU -o go.linux-amd64.tar.gz && \
  rm -rf /usr/local/go && tar -C /usr/local -xzf go.linux-amd64.tar.gz
  
# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen

RUN mkdir -p /usr/local/lib /usr/local/bin /home/dv-user \
  && curl -fL https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash dv-user
COPY entrypoint.sh push_htd.sh init_dev_env.sh /usr/local/bin/

USER 2001
ENV LANG=en_US.UTF-8
ENV USER=dv-user
ENV HOME=/home/dv-user
ENV SHELL=/bin/bash
ENV THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins
ENV USE_LOCAL_GIT=true
ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
