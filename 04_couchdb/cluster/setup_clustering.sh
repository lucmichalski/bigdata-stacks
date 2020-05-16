#!/bin/sh

# Local Setup
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"bouchdc", "node_count":"3"}'

# Couch2
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"bouchdc", "port": 15984, "node_count": "3", "remote_node": "couchdb.two", "remote_current_user": "couchdb", "remote_current_password": "bouchdc" }'
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "add_node", "host":"couchdb.two", "port": "5984", "username": "couchdb", "password":"bouchdc"}'

# Couch3
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "couchdb", "password":"bouchdc", "port": 15984, "node_count": "3", "remote_node": "couchdb.three", "remote_current_user": "couchdb", "remote_current_password": "bouchdc" }'
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "add_node", "host":"couchdb.three", "port": "5984", "username": "couchdb", "password":"bouchdc"}'

#Finish
curl -X POST -H "Content-Type: application/json" http://couchdb:bouchdc@127.0.0.1:15984/_cluster_setup -d '{"action": "finish_cluster"}'
