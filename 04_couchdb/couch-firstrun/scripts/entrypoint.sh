#!/bin/sh

/root/wait-for.sh "7dbs_couch_db:5984" -t 60 -- echo "CouchDB ready"

curl -X PUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@7dbs_couch_db:5984/_users 
curl -X PUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@7dbs_couch_db:5984/_replicator 
curl -X PUT http://$COUCHDB_USER:$COUCHDB_PASSWORD@7dbs_couch_db:5984/_global_changes
