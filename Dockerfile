#
# Build stage
#
FROM maven:3.9.3-eclipse-temurin-20-alpine@sha256:28e7f7fe853810733f958bb3f7adc792dbb1b1b1f5ccc6aa60410a2745b7b53a AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:20-alpine@sha256:cbff54f61c4f4c7761038b4c108458d812a61899f5014d88ce1b93465caff2a9
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
