#
# Build stage
#
FROM maven:3.9.3-eclipse-temurin-20-alpine@sha256:8e56fee5c481cd60b59ffbd54637f4f046d6acece56bb6e8679c8c713e86415a AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:20-alpine@sha256:18c5ff04ffbe0012ebcaf66c478204c52ac1cbb3dc8249a8659406ba9979acee
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
