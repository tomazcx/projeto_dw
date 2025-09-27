FROM postgres:17-bookworm

USER root
RUN set -eux \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-17-tds-fdw \
      freetds-dev \
      freetds-bin \
 && rm -rf /var/lib/apt/lists/*
USER postgres
