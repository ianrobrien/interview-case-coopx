#
# Build stage
#
FROM maven:3.9.3-eclipse-temurin-20-alpine@sha256:0a3b5e83c310523dd554e63f5079da5acaf169256556e87276fed6d148d90eb9 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:0590276e28eadad32040b43c6564a991a3860049155be0c69e7d3632ead05f66
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
