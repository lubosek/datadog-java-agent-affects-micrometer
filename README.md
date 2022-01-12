# Loading of DataDog java agent affects reliability of metric publishing

## Summary
This is a self-containing reproduction scenario for a problem that we are experiencing with various versions of dd-java-agent.jar library. We are using micrometer.io for publishing metrics to DataDog. We observed that once you load basically any version of dd-java-agent.jar to JVM via -javaagent directive, the reliability of publishing of metrics to Data Dog agent is affected.

## Steps to Reproduce
Tests were done on MacOS BigSur 11.6.1 with openjdk version "11.0.11.

### Prerequisites
* DataDog agent running on localhost
* DataDog agent libraries in /opt/datadog/
  * tested versions: 0.90.0, 0.88.0, 0.86.0, 0.82.0, 0.74.0, 0.55.1

### Steps
* run `./gradlew clean build`
  * now there's a test application built 
  * it can be parametrized with APP_VERSION which is also used as a DataDog metric tag used to distinguish configs - following tags are used
    * 55, 90, 82, none - micrometer library with respective version of dd-java-client loaded
    * ddclient, 90ddclient - for comparison alse DataDog's own StatsD client is used without and with dd-java-agent
* run `startTcpdump.sh` to capture UDP traffic to port 8125
* run `runTestsInParallel.sh`
** this will launch the same jar with different versions of dd-java-agent
* in DataDog create a dashboard with metric `delivery.base_image_datadog_test_micrometer.cnt3` and slice it by `appversion`
* alternatively use `tcpdump -qns 0 -A -r tcpdump.log | grep cnt3 -B1 | less` to explore UDP packets with metric updates



