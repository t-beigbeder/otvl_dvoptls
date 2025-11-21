ARG K8S_CLIENTS_IMAGE=k8s-clients:1.0.1-tbd
ARG DV_DEV_TOOLS_IMAGE=dv-dev-tools:1.0.0-tbd

FROM $K8S_CLIENTS_IMAGE AS kcb

FROM $DV_DEV_TOOLS_IMAGE
ARG CSV=4.101.2-sample

USER root

RUN curl -fL https://github.com/coder/code-server/releases/download/v$CSV/code-server-$CSV-linux-amd64.tar.gz \
  | tar -C /usr/local/lib -xz \
  && mv /usr/local/lib/code-server-$CSV-linux-amd64 /usr/local/lib/code-server-$CSV \
  && ln -s /usr/local/lib/code-server-$CSV/bin/code-server /usr/local/bin/code-server

RUN apt-get update \
  && apt-get install -y ca-certificates \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/download_docker_com_linux_debian.list \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  && rm -rf /var/lib/apt/lists/*

COPY --from=kcb /usr/local/bin /usr/local/bin

USER 2001
