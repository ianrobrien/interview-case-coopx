#
# Build stage
#
FROM maven:3.9.4-eclipse-temurin-21-alpine@sha256:9c1d052ede2fa708a5a304269a1de8d3e441225f2f3112e14466ae9fe4eb9224 AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:001dfe1c179b3f315bd6549ad1fe94fd7204984319bd3c0f3b385b5188cb18b8
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
