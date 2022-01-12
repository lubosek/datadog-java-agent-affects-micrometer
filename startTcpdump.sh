#!/bin/sh
sudo tcpdump -i lo0 udp port 8125 -vv -X -w logs/tcpdump.log
