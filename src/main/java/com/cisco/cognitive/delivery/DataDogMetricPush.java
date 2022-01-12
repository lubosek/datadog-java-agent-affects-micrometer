package com.cisco.cognitive.delivery;

import com.timgroup.statsd.NonBlockingStatsDClientBuilder;
import com.timgroup.statsd.StatsDClient;
import io.micrometer.core.instrument.*;
import io.micrometer.core.instrument.logging.LoggingMeterRegistry;
import io.micrometer.statsd.StatsdMeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.micrometer.core.instrument.Clock.SYSTEM;

public class DataDogMetricPush {

    public static void main(String[] args) throws Exception {
        Logger log = LoggerFactory.getLogger(DataDogMetricPush.class);
        log.info("Start test app");
        log.info("Micrometer Version is {}", MicrometerVersion.getVersion());

        final String COUNTER_METRIC_NAME = "delivery.base_image_datadog_test_micrometer.cnt3";
        final String APP_NAME = "base-image-datadog-test";
        final String STATSD_CLIENT = (System.getenv("STATSD_CLIENT") == null) ?
                "micrometer" : System.getenv("STATSD_CLIENT");
        final String APP_VERSION = System.getenv("APP_VERSION");
        final String STATSD_HOST = (System.getenv("DD_AGENT_HOST") == null) ?
                "localhost" : System.getenv("DD_AGENT_HOST");
        log.info("Statsd Host is {}", STATSD_HOST);
        log.info("App version (appversion DataDog tag) is {}", APP_VERSION);
        log.info("Using {} as StatsD client", STATSD_CLIENT);

        Tags listOfTags = Tags.of(
                "application", APP_NAME,
                "app", APP_NAME,
                "appversion", APP_VERSION);

        switch (STATSD_CLIENT) {
            case "micrometer":
                MicrometerMonitoringRegistry.registerToStatsd(STATSD_HOST);
                try (MicrometerMonitoringRegistry monitoringRegistry = new MicrometerMonitoringRegistry(
                        Metrics.globalRegistry, listOfTags
                )) {
//                  registering additional registry to see if it brings some additional insight
                    LoggingMeterRegistry loggingRegistry = new LoggingMeterRegistry();
                    Metrics.addRegistry(loggingRegistry);

//                  actual increment
                    monitoringRegistry.getCounter(COUNTER_METRIC_NAME).increment();
                    log.info("Counter inncremented using {} StatsD client", STATSD_CLIENT);
                }
                break;
            case "micrometer-no-wrapper":
                MicrometerMonitoringRegistry.registerToStatsd(STATSD_HOST);
                MeterRegistry registry = new StatsdMeterRegistry(new DatadogStatsdConfig(STATSD_HOST), SYSTEM);
                Metrics.addRegistry(registry);
                LoggingMeterRegistry loggingRegistry = new LoggingMeterRegistry();
                Metrics.addRegistry(loggingRegistry);
                Counter cnt3 = Counter.builder(COUNTER_METRIC_NAME).tags("application", APP_NAME,
                        "app", APP_NAME,
                        "appversion", APP_VERSION).register(Metrics.globalRegistry);
                cnt3.increment();
                log.info("Counter inncremented using {} StatsD client", STATSD_CLIENT);
                Thread.sleep(60000);
                break;
            case "datadog":
                try (StatsDClient statsd = new NonBlockingStatsDClientBuilder()
                        .hostname(STATSD_HOST)
                        .port(8125)
                        .build()) {
                    statsd.incrementCounter(COUNTER_METRIC_NAME, "application:" + APP_NAME,
                            "app:" + APP_NAME,
                            "appversion:" + APP_VERSION);
                    Thread.sleep(60000);
                    log.info("Counter inncremented using {} StatsD client", STATSD_CLIENT);
                }
                break;
            case "default":
                log.error("Uknown statsDClient. Exiting.");
                System.exit(1);
        }

        System.out.println("Publishing completed. Still waiting a bit more for final flush");
        Thread.sleep(12000);
        System.out.println("Exiting");

    }

}
