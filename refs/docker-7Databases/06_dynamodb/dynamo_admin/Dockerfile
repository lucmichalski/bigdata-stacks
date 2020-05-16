FROM node:12.3.1-stretch

RUN npm config set loglevel warn && \
   npm -g install dynamodb-admin

ENV DYNAMO_ENDPOINT=

ENTRYPOINT dynamodb-admin