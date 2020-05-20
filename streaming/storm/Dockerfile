FROM lucmichalski/alpine-maven:latest AS builder

WORKDIR /app
COPY . .

RUN mvn clean package

FROM openjdk:8-jre
VOLUME /tmp

ENV STORM_HOME /usr/local/storm

COPY --from=builder /app/target/search-flight-storm-streaming-0.1.0-jar-with-dependencies.jar $STORM_HOME/libs/search-flight-streaming.jar
# ADD target/search-flight-storm-streaming-0.1.0-jar-with-dependencies.jar $STORM_HOME/libs/search-flight-streaming.jar

WORKDIR $STORM_HOME
CMD ["java", "-jar", "./libs/search-flight-streaming.jar" ]
