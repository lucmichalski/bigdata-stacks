FROM elasticsearch:6.4.2

RUN bin/elasticsearch-plugin install analysis-phonetic
RUN bin/elasticsearch-plugin install analysis-icu

EXPOSE 9200 9300
#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]

# Issue
#ERROR: [1] bootstrap checks failed
#[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
# https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

# Fix: sysctl -w vm.max_map_count=262144
# If you want to set this permanently, you need to edit /etc/sysctl.conf and set vm.max_map_count to 262144.
# When the host reboots, you can verify that the setting is still correct by running sysctl vm.max_map_count
#

# Issue 2
# max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
# https://discuss.elastic.co/t/cannot-solve-problem-max-file-descriptors-4096-for-elasticsearch/82459/4
#
# Add into docker-compose this values for elastic search service:
#    ulimits:
#      memlock:
#        soft: -1
#        hard: -1
#      nofile:
#        soft: 65536
#        hard: 65536
#

