# https://github.com/aws/aws-cli/issues/3291
FROM python:alpine

ARG CLI_VERSION=1.16.173

RUN apk -uv add --no-cache groff jq less && \
    pip install --no-cache-dir awscli==$CLI_VERSION

WORKDIR /aws

CMD sh