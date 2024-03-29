#
# Build stage
#
FROM maven:3.9.5-eclipse-temurin-21-alpine@sha256:273bf0466fbed6f8abf3a22592b7144ec5388d3eb0b354552e2529482982b848 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:b5d37df8ee5bb964bb340acca83957f9a09291d07768fba1881f6bfc8048e4f5
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
