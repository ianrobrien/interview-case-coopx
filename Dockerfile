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
FROM eclipse-temurin:20-alpine@sha256:45617c77c7828c6ddf406e0ba7bbac3d1ba0b552f5750ae1e10a476dd32b00fa
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
