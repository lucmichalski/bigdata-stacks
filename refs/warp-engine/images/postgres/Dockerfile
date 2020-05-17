FROM postgres:9.6.15

LABEL maintainer="Matias Anoniz <matiasanoniz@gmail.com>"

RUN apt-get update && apt-get install -y postgresql-contrib

RUN mkdir -p /docker-entrypoint-initdb.d

COPY ./uuid-ossp.sh /docker-entrypoint-initdb.d

RUN chmod 755 /docker-entrypoint-initdb.d/uuid-ossp.sh