#
# Build stage
#
FROM maven:3.9.2-eclipse-temurin-20-alpine@sha256:27eedda17253d7286d45268a93469065241af14ab12e32f82078d253661e6e97 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:20-alpine@sha256:916949fa2a8be84b93930f3dcda5706b5f57d1f7452ef83b7653a5791f5525e5
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
