ARG THEIA_IMAGE=theia-build:1.66.2-tbd
ARG K8S_CLIENTS_IMAGE=k8s-clients:1.0.1-tbd
ARG DV_DEV_TOOLS_IMAGE=dv-dev-tools:1.0.0-tbd
FROM $THEIA_IMAGE as thb
FROM $K8S_CLIENTS_IMAGE as kcb

FROM $DV_DEV_TOOLS_IMAGE
USER root

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get update \
  && apt-get install -y nsolid \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y ca-certificates \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/download_docker_com_linux_debian.list \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  && rm -rf /var/lib/apt/lists/*

COPY --from=kcb /usr/local/bin /usr/local/bin
COPY --from=thb /home/theia/plugins /home/theia/plugins
COPY --from=thb /home/theia/applications/browser /home/theia/applications/browser

USER 2001
