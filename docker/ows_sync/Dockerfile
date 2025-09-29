FROM debian:13 AS build-stage
COPY . /ows/
WORKDIR /ows
RUN apt-get update \
    && apt-get install -y virtualenv python3 \
    && virtualenv /venv \
    && /venv/bin/pip install pip-tools \
    && /venv/bin/pip-compile requirements.in \
    && /venv/bin/pip install -r requirements.txt

FROM debian:13
RUN apt-get update \
  && apt-get install -y \
    python3 \
    openssh-client \
    rsync \
    git \
    vim-tiny \
  && rm -rf /var/lib/apt/lists/* \
  && adduser --gecos '' --disabled-password --uid 2001 --shell /bin/bash ows-user

COPY --from=build-stage /venv /venv
COPY shell /shell
COPY ssh /home/ows-user/.ssh
RUN mkdir -p /export/current/5a7 \
  && chown -R 2001:2001 /home/ows-user/.ssh /export

ENV USER=ows-user
ENV HOME=/home/ows-user
ENV OWS_SYNC_GREPO=https://github.com/t-beigbeder/otvl_blog
ENV OWS_SYNC_BRANCH=deploy1
ENV OWS_SYNC_KEY=/home/ows-user/.ssh/id_ows_sync
ENV OWS_SYNC_SREPO=ows-user@t-sk3s-sv:/data/backups/apps/otvl_sites/assets/blog
ENV OWS_INGRESS_HOST=ows.example.com
ENV OWS_EXPORT_SITE=/export
ENV OWS_CUSTO_SITE=/shell/nop.sh
ENV OWS_PERIOD_SECONDS=600

USER 2001
WORKDIR /home/ows-user
CMD /shell/launcher.sh
