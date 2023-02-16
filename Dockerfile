#
# Build stage
#
FROM maven:3.9.0-amazoncorretto-19@sha256:88ef10673d5fc9071a0b4dad528766e1eeac0fe7756b51ed8dffb4daa8486904 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM amazoncorretto:19-alpine3.16-jdk@sha256:3420f2939e52769b1b9996be2930b7bca1463c50d262987b1e4b65f4de12352f
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT java -jar /usr/local/lib/twitflow.jar "--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN"
