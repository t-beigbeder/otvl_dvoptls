FROM debian:13 AS builder

# https://cdn.dl.k8s.io/release/stable.txt
ARG KCU=https://dl.k8s.io/v1.35.1/bin/linux/amd64/kubectl
ARG HLU=https://get.helm.sh/helm-v3.20.1-linux-amd64.tar.gz
ARG K9U=https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Linux_amd64.tar.gz
ARG AWU=https://github.com/argoproj/argo-workflows/releases/download/v3.7.7/argo-linux-amd64.gz

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
    curl -fL $AWU -o argo.gz && \
    gzip -d argo.gz && \
    cp argo /usr/local/bin/argo && \
    chmod 755 /usr/local/bin/argo && \
    true

FROM scratch
COPY --from=builder /usr/local/bin /usr/local/bin
