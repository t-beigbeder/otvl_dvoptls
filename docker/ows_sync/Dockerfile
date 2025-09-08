FROM python:3.13 AS build-stage
COPY . /ows/
WORKDIR /ows
RUN apt-get update \
    && apt-get install -y virtualenv \
    && virtualenv /venv \
    && /venv/bin/pip install pip-tools \
    && /venv/bin/pip-compile requirements.in \
    && /venv/bin/pip install -r requirements.txt

FROM debian:13
RUN apt-get update \
  && apt-get install -y \
    openssh-client \
    rsync \
    git \
  && rm -rf /var/lib/apt/lists/*
COPY --from=build-stage /venv /venv
COPY shell /shell
CMD /shell/launcher.sh
