package com.cisco.cognitive.delivery;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tags;

import java.util.concurrent.atomic.AtomicLong;

public class MicrometerMonitoringCounter implements MonitoringCounter {
    private final AtomicLong count;

    public MicrometerMonitoringCounter(MeterRegistry meterRegistry, String name, Tags tags, long init) {
        count = new AtomicLong(init);
        meterRegistry.more().counter(name, tags, count);
    }

    @Override
    public void increment() {
        count.incrementAndGet();
    }

    @Override
    public void incrementBy(long amount) {
        count.addAndGet(amount);
    }

    @Override
    public long getCount() {
        return count.get();
    }
}
