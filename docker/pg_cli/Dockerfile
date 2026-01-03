FROM debian:13 AS build-stage
COPY requirements.txt .
RUN apt-get update \
    && apt-get install -y virtualenv python3 \
    && virtualenv /venv \
    && /venv/bin/pip install -r requirements.txt

FROM debian:13-slim

RUN apt-get update \
  && apt-get install -y \
    postgresql-common \
    adduser \
    python3 \
    curl \
    ca-certificates \
    vim-tiny \
  && rm -rf /var/lib/apt/lists/*

RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y && \
    apt-get install -y postgresql-client-18 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-stage /venv /venv

ENV USER=postgres
ENV HOME=/home/postgres

USER 101:103
WORKDIR /home/postgres
