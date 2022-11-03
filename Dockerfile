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
FROM openjdk:19-slim-buster@sha256:5d9241a0947897f2be3deb641df1e04e5a2bac3e45e123a6e5d59f9c1d42d4c3
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
