package com.cisco.cognitive.delivery;

import io.micrometer.core.instrument.Clock;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Tags;
import io.micrometer.statsd.StatsdMeterRegistry;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MicrometerMonitoringRegistry implements MonitoringRegistry, AutoCloseable {
    private final MeterRegistry meterRegistry;
    private final Tags tags;

    static {
        String statsdHost = System.getProperty("STATSD_HOST");
        if (statsdHost != null) {
            registerToStatsd(statsdHost);
        }
    }

    public MicrometerMonitoringRegistry(MeterRegistry meterRegistry, Tags tags) {
        this.meterRegistry = meterRegistry;
        this.tags = tags;
    }

    public static void registerToStatsd(String host) {
        Metrics.addRegistry(new StatsdMeterRegistry(new DatadogStatsdConfig(host), Clock.SYSTEM));
    }

    @Override
    public MonitoringCounter getCounter(String name) {
        return new MicrometerMonitoringCounter(meterRegistry, name, tags, 0);
    }

    @Override
    public void close() throws InterruptedException {
        log.info("Sleeping to make sure all metrics are reported");
        Thread.sleep(DatadogStatsdConfig.POLLING_INTERVAL.toMillis() * 2);
    }
}
