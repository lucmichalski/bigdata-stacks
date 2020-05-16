FROM couchdb:2.3.1

COPY cookie /opt/couchdb/.erlang.cookie

RUN chown couchdb /opt/couchdb/.erlang.cookie && \
    chmod 600 /opt/couchdb/.erlang.cookie
