FROM frolvlad/alpine-java:jdk8-slim

LABEL maintainer "Luc Michalski <michalski.luc@gmail.com>"

ENV SBT_VERSION 1.3.10
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh docker curl tar gzip

# Install sbt
RUN curl -sL "https://piccolo.link/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

RUN ln -s /usr/local/sbt-launcher-packaging-$SBT_VERSION/bin/sbt /usr/local/bin/sbt
RUN sbt sbtVersion
