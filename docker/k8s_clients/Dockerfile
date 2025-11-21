FROM debian:12 AS builder

# https://cdn.dl.k8s.io/release/stable.txt
ARG KCU=https://dl.k8s.io/release/v1.34.2/bin/linux/amd64/kubectl
ARG HLU=https://get.helm.sh/helm-v3.19.2-linux-amd64.tar.gz
ARG K9U=https://github.com/derailed/k9s/releases/download/v0.50.16/k9s_Linux_amd64.tar.gz

RUN apt-get update \
  && apt-get install -y \
    curl \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
RUN mkdir -p /usr/local/bin && \
    curl -fL $KCU -o /usr/local/bin/kubectl && \
    chmod 755 /usr/local/bin/kubectl && \
    curl -fL $HLU -o hl.tgz && \
    tar xf hl.tgz && \
    cp linux-amd64/helm /usr/local/bin && \
    curl -fL $K9U -o k9.tgz && \
    tar xf k9.tgz && \
    cp k9s /usr/local/bin && \
    true

FROM scratch
COPY --from=builder /usr/local/bin /usr/local/bin
