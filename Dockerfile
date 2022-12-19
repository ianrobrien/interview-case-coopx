#
# Build stage
#
FROM maven:3.8.6-amazoncorretto-19@sha256:23f52a3cfee7cf5bf8373029c439b480a49810e9ee73ec341c95f0b1d263b810 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM amazoncorretto:19-alpine3.16-jdk@sha256:46be4d85ae0f45ee7144fcb0d785907b960ee273f6e3d759b6e0c39bf03e5387
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
