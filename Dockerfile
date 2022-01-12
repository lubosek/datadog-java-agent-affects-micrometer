FROM gradle:7.3.2-jdk11-alpine AS build-tests
COPY --chown=gradle:gradle . /home/gradle
WORKDIR /home/gradle
RUN gradle build --no-daemon
RUN ls /home/gradle/build/libs

FROM eclipse-temurin:11-jdk-alpine

LABEL maintainer="cognitive-delivery@cisco.com"
LABEL description="Test image for DD integration in base-java11"

RUN apk add --no-cache bash jq
RUN adduser -D job

RUN mkdir -p /data

COPY --from=build-tests /home/gradle/build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar /data/tests.jar
COPY runner.sh /data/runner.sh

RUN chmod +x /data/runner.sh
RUN chown --recursive job /data

RUN mkdir -p /opt/datadog
ADD https://engci-maven.cisco.com/artifactory/central/com/datadoghq/dd-java-agent/0.55.1/dd-java-agent-0.55.1.jar /opt/datadog/
ADD https://engci-maven.cisco.com/artifactory/central/com/datadoghq/dd-java-agent/0.90.0/dd-java-agent-0.90.0.jar /opt/datadog/
ADD https://engci-maven.cisco.com/artifactory/central/com/datadoghq/dd-java-agent/0.91.0/dd-java-agent-0.91.0.jar /opt/datadog/
RUN set -ex && \
    chmod 644 /opt/datadog/dd-java-agent-0.55.1.jar && \
    chmod 644 /opt/datadog/dd-java-agent-0.90.0.jar && \
    chmod 644 /opt/datadog/dd-java-agent-0.91.0.jar


USER job
ENTRYPOINT ["/bin/bash", "-c", "exec /data/runner.sh"]