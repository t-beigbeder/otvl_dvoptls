FROM node:22-bullseye as thb

ARG THV=1.66.2-sample

RUN apt-get update \
  && apt-get install -y libxkbfile-dev libsecret-1-dev git

WORKDIR /home
RUN git clone --single-branch --depth 1 https://github.com/eclipse-theia/theia
COPY theia theia
WORKDIR theia
RUN npm install \
  && npm run build:browser \
  && npm run download:plugins

FROM debian:12

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
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen

RUN mkdir -p /usr/local/lib /usr/local/bin /home/th-user \
  && curl -fL https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash th-user

COPY --from=thb /home/theia/plugins /home/theia/plugins
COPY --from=thb /home/theia/example/browser /home/theia/example/browser
COPY entrypoint.sh push_htd.sh init_dev_env.sh /usr/local/bin/

EXPOSE 3000

USER 2001
ENV LANG=en_US.UTF-8
ENV USER=th-user
ENV HOME=/home/th-user
ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
