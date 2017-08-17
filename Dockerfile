FROM python:2.7-slim

ENV VERSION=1.11.114

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	&& apt-get install --reinstall groff-base \
	&& mkdir -p /aws \
    && pip install -U pip \
    && pip install awscli==${VERSION} \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /aws
ENTRYPOINT ["aws"]
