#
# Build stage
#
FROM maven:3.8.6-openjdk-18-slim@sha256:1651ffc25c1d9fd703b3af3b3a5b5e76726e1bd5a98ad6d8c2b51c2861c213cd AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM amazoncorretto:19-alpine3.16-jdk@sha256:b56e93c64f61233c016f1a94ae67ef37761adba65b2ecbd74c4579cbae2b44ed
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
