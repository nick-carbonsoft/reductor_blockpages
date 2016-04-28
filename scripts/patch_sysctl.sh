#!/bin/bash

grep -q gc_timeout /etc/sysctl.conf && exit 0

cat >> /etc/sysctl.conf << EOF
net.ipv4.route.gc_timeout = 30
net.ipv4.route.gc_min_interval = 1
net.ipv4.neigh.default.gc_thresh1 = 10000
net.ipv4.neigh.default.gc_thresh2 = 11000
net.ipv4.neigh.default.gc_thresh3 = 12000
EOF
