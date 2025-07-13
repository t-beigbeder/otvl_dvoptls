FROM debian:12

ARG CSV=4.101.2

RUN apt-get update \
  && apt-get install -y \
    curl \
    locales \
    openssh-client \
    procps \
    vim-tiny \
    bash-completion \
    git \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8
ENV USER=cs-user
ENV HOME=/home/cs-user

RUN mkdir -p /usr/local/lib /usr/local/bin /home/cs-user \
  && curl https://github.com/krallin/tini/releases/download/0.19.0/tini -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash cs-user \
  && curl -fL https://github.com/coder/code-server/releases/download/v$CSV/code-server-$CSV-linux-amd64.tar.gz \
  | tar -C /usr/local/lib -xz \
  && mv /usr/local/lib/code-server-$CSV-linux-amd64 /usr/local/lib/code-server-$CSV \
  && ln -s /usr/local/lib/code-server-$CSV/bin/code-server /usr/local/bin/code-server
COPY entrypoint.sh /usr/local/bin/

EXPOSE 8443

USER 3002
ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
