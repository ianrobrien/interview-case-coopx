#
# Build stage
#
FROM maven:3.9.0-amazoncorretto-19@sha256:155d3ed0facaa17b3fca6aa9328cd7aa0efad7e988f69f5b2c83c8caac0b105c AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM amazoncorretto:20-alpine3.16-jdk@sha256:191ffe9cd2b97bd4849085b6cb81624336fff1ae6d3e367c3d9b501f8d26f553
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
