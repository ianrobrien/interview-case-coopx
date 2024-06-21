#
# Build stage
#
FROM maven:3.9.6-eclipse-temurin-22-alpine@sha256:d7fb9d2e3fa41bb7a679e41f20cf04fd122aeb8ba3093ec720443be31d4eafae AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:cd77ea279fa771540f5ddac4fba3787cfdfd527adeb80b6b8a3aadbf78cfa4ea
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
