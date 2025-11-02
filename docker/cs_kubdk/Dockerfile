FROM t-ctr.otvl.org/k8s-clients:1.0 as KC
FROM t-ctr.otvl.org/code-server-base:4.105.1
USER root
COPY --from=KC /usr/local/bin /usr/local/bin
RUN apt-get update \
  && apt-get install -y ca-certificates \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/download_docker_com_linux_debian.list \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  && rm -rf /var/lib/apt/lists/*
USER 2001
