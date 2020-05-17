FROM elasticsearch:2.4.6

RUN bin/plugin install analysis-phonetic
RUN bin/plugin install analysis-icu
RUN bin/plugin install delete-by-query

RUN echo "script.inline: on" >> config/elasticsearch.yml
RUN echo "script.indexed: on" >> config/elasticsearch.yml

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]