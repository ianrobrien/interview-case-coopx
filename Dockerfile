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
FROM eclipse-temurin:20-alpine@sha256:38e00a5fcb2a337897387f40f2b6603522d1917bae565be565909ffd6b7f48c1
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
