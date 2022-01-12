package com.cisco.cognitive.delivery;

public interface MonitoringCounter {
    long getCount();

    void increment();

    void incrementBy(long amount);
}
