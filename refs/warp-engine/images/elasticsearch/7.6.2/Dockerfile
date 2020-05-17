FROM elasticsearch:7.6.2

RUN bin/elasticsearch-plugin install analysis-phonetic
RUN bin/elasticsearch-plugin install analysis-icu

EXPOSE 9200 9300
CMD ["elasticsearch"]