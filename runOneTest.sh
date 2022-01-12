#!/bin/sh

rm logs/dd*log

for i in {1..5}; do
  echo "======================================="
  echo Iteration $i
  echo "======================================="
APP_VERSION=551 STATSD_CLIENT=micrometer java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.55.1.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-551-micrometer.log  &
#APP_VERSION=90 STATSD_CLIENT=micrometer java \
#  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
#  -javaagent:/opt/datadog/dd-java-agent-0.90.0.jar \
#  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-90-micrometer.log  &
#APP_VERSION=82 STATSD_CLIENT=micrometer java \
#  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
#  -javaagent:/opt/datadog/dd-java-agent-0.82.0.jar \
#  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-82-micrometer.log  &
#APP_VERSION=none STATSD_CLIENT=micrometer java \
#  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
#  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-none-micrometer.log  &
#APP_VERSION=90ddclient STATSD_CLIENT=datadog java \
#  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
#  -javaagent:/opt/datadog/dd-java-agent-0.90.0.jar \
#  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-90-dadatog.log  &
#APP_VERSION=ddclient STATSD_CLIENT=datadog java \
#  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
#  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-none-dadatog.log
  wait
done
