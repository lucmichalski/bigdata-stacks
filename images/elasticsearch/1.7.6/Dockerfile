FROM elasticsearch:1.7.6

RUN bin/plugin install elasticsearch/elasticsearch-analysis-icu/2.7.0
RUN bin/plugin install elasticsearch/elasticsearch-analysis-phonetic/2.7.0
RUN echo "script.inline: on" >> config/elasticsearch.yml
RUN echo "script.indexed: on" >> config/elasticsearch.yml

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
