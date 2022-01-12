#!/bin/bash

if [[ ! -z "${JAVAAGENT_VERSION}" ]]; then
  JAVAAGENT="-javaagent:/opt/datadog/dd-java-agent-$JAVAAGENT_VERSION.jar"
fi

SHUTDOWN_CONSOLE_FILE="/tmp/shutdown.pipe"

finish() {
    echo "shutdown" > "${SHUTDOWN_CONSOLE_FILE}"
    wait &>/dev/null
    rm -f "${SHUTDOWN_CONSOLE_FILE}"
    if [[ -n "${ISTIO_MESH_ENABLED}" ]]; then
        curl --max-time 2 -s -f -XPOST http://127.0.0.1:15020/quitquitquit
    fi
}

trap finish EXIT

if [[ -n "${ISTIO_MESH_ENABLED}" ]]; then
    while ! curl -s -f http://127.0.0.1:15020/healthz/ready; do sleep 1; done
fi

java -cp '/data/tests.jar' -Dreactor.netty.native=false -Dio.micrometer.shaded.io.netty.transport.noNative=true \
 -DstatsDClient=${STATSDCLIENT} ${JAVAAGENT} com.cisco.cognitive.delivery.DataDogMetricPush &
PID=$!
wait $PID &>/dev/null
