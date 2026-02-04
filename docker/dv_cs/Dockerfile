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

COPY --from=kcb /usr/local/bin /usr/local/bin

USER 2001
