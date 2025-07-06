FROM debian:12

ARG CSV=4.101.2

RUN apt-get update \
  && apt-get install -y \
    curl \
    git \
    locales \
    lsb-release \
    man-db \
    nano \
    openssh-client \
    procps \
    vim-tiny \
    wget \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

RUN mkdir -p /usr/local/lib /usr/local/bin \
  && curl -fL https://github.com/coder/code-server/releases/download/v$CSV/code-server-$CSV-linux-amd64.tar.gz \
  | tar -C /usr/local/lib -xz \
  && mv /usr/local/lib/code-server-$CSV-linux-amd64 /usr/local/lib/code-server-$CSV \
  && ln -s /usr/local/lib/code-server-$CSV/bin/code-server /usr/local/bin/code-server
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# FIXME
RUN adduser --gecos '' --disabled-password --uid 2001 oe \
  && addgroup --gid 3000 fsg \
  && adduser oe fsg

EXPOSE 8443

USER 2001
ENV USER=oe
WORKDIR /home/oe
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
