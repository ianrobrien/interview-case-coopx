#
# Build stage
#
FROM maven:3.9.8-eclipse-temurin-22-alpine@sha256:63dc926762f2cf571b11d421e3c9281b8e8ae81e4ffd32cb48eb9ca8068e39a9 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:5b836a84d8287dcba9c89beb5a449871430206b8ff758a7732f2e43313c0fbd4
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
