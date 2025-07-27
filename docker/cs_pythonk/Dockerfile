FROM t-ctr.otvl.org/k8s-clients:1.0 as KC
FROM t-ctr.otvl.org/cs-python:4.102.1-p2
USER root
COPY --from=KC /usr/local/bin /usr/local/bin
USER 2001
