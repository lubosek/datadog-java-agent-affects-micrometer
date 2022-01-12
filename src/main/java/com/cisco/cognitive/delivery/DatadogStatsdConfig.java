package com.cisco.cognitive.delivery;

import io.micrometer.statsd.StatsdConfig;
import io.micrometer.statsd.StatsdFlavor;

import java.time.Duration;

public class DatadogStatsdConfig implements StatsdConfig {
    public static final Duration POLLING_INTERVAL = Duration.ofSeconds(60);

    private final String host;

    public DatadogStatsdConfig(String host) {
        this.host = host;
    }

    @Override
    public String get( String k) {
        return null;
    }

    @Override
    public StatsdFlavor flavor() {
        return StatsdFlavor.DATADOG;
    }

    @Override
    public  String host() {
        return host;
    }

    @Override
    public Duration pollingFrequency() {
        return POLLING_INTERVAL;
    }
}

