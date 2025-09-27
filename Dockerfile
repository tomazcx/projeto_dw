FROM postgres:17-bookworm

USER root
RUN set -eux \
 && apt-get update \
 && apt-get install -y --no-install-recommends wget gnupg ca-certificates lsb-release \
 && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(. /etc/os-release && echo $VERSION_CODENAME)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list \
 && wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-$PG_MAJOR-tds-fdw freetds-dev freetds-bin \
 && apt-get purge -y --auto-remove wget gnupg \
 && rm -rf /var/lib/apt/lists/*
USER postgres
