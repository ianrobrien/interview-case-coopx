#
# Build stage
#
FROM maven:3.9-eclipse-temurin-8-alpine@sha256:57cd19ae3e1b63e403dcb6811fa4f92f9c4d6b802e03a35c59a26dd0fedc6a1b AS build
COPY . /home/app/
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#
# Package stage
#
FROM eclipse-temurin:21-alpine@sha256:511d5a9217ed753d9c099d3d753111d7f9e0e40550b860bceac042f4e55f715c
COPY --from=build /home/app/target/twitflow-0.0.1-SNAPSHOT.jar /usr/local/lib/twitflow.jar
ARG TWITTER_API_BEARER_TOKEN=$TWITTER_API_BEARER_TOKEN
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/twitflow.jar", "\"--twitter.api.bearer-token=$TWITTER_API_BEARER_TOKEN\""]
