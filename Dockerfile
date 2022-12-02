#
# Build stage
#
FROM maven:3.8.6-amazoncorretto-19@sha256:ee367118a3cd9423b556b36065958dd25a02bfc93b39083863cae6ee4e0b24d6 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM amazoncorretto:19-alpine3.16-jdk@sha256:46be4d85ae0f45ee7144fcb0d785907b960ee273f6e3d759b6e0c39bf03e5387
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
