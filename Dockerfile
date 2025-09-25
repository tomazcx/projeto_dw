FROM postgres:17

USER root

RUN set -eux \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-$PG_MAJOR-tds-fdw \
      freetds-dev \
      freetds-bin \
 && rm -rf /var/lib/apt/lists/*

USER postgres