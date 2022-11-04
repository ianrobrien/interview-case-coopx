#
# Build stage
#
FROM maven:3.8.6-openjdk-18-slim@sha256:f60603d2c21ddb72a40773df8cd7155fd57156f665420f7144d3f7d7c1ea18db AS build
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
