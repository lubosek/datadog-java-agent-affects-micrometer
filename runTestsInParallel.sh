#!/bin/sh
# you may need to adjust your JAVA_HOMEs
JAVA_HOME_11=$(/usr/libexec/java_home -v 11)
JAVA_HOME_17=$(/usr/libexec/java_home -v 17)
JAVA_HOME_11_0_11="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"

rm logs/dd*log

for i in {1..160}; do
  echo "======================================="
  echo Iteration $i
  echo "======================================="
APP_VERSION=none STATSD_CLIENT=micrometer $JAVA_HOME_11/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-none-micrometer.log  &
APP_VERSION=551 STATSD_CLIENT=micrometer $JAVA_HOME_11/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.55.1.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-551-micrometer.log  &
APP_VERSION=90 STATSD_CLIENT=micrometer $JAVA_HOME_11/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.90.0.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-90-micrometer.log  &
APP_VERSION=91 STATSD_CLIENT=micrometer $JAVA_HOME_11/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.91.0.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-91-micrometer.log  &
APP_VERSION=92 STATSD_CLIENT=micrometer $JAVA_HOME_11/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.92.0.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-92-micrometer.log  &
APP_VERSION=92jdk17 STATSD_CLIENT=micrometer $JAVA_HOME_17/bin/java \
  -cp 'build/libs/base-image-datadog-integration-test-1.0-SNAPSHOT.jar' \
  -javaagent:/opt/datadog/dd-java-agent-0.92.0.jar \
  com.cisco.cognitive.delivery.DataDogMetricPush >>logs/dd-java-agent-92jdk17-micrometer.log  &
  wait
done
