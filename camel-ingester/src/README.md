# Camel Ingester

Read json bulk files (Elasticsearch format) and try to ingest those documents Elasticsearch or Solr (depends on the profile) using Apache Camel and Spring Boot.

## Run the application

java -jar camel-ingester.jar --spring.profiles.active=PROFILE --data.input.directory=PATH_OF_YOUR_DATA
