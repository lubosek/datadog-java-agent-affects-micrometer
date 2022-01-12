package com.cisco.cognitive.delivery;

import io.micrometer.statsd.StatsdConfig;

public class MicrometerVersion {
    public static String getVersion() {
        Package p = StatsdConfig.class.getPackage();
        return p.getImplementationVersion();
    }
}
