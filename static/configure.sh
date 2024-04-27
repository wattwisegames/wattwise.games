#!/bin/sh
# Install cpupower.
sudo apt install linux-tools-generic
# Stop every system service we can.
for service in $(systemctl | grep \\.service | grep running |grep -v bluetooth|grep -v dbus|grep -v gdm|grep -v irqbalance | grep -v kerneloops | grep -v power-profiles-daemon | grep -v rsyslog | grep -v rtkit-daemon | grep -v polkit | grep -v systemd- | grep -v upower | grep -v thermald | grep -v user@1000| tr -s ' '| cut -d' ' -f2); do sudo systemctl stop "$service"; done
# Lock CPU clock speed.
sudo cpupower frequency-set -d 2GHz -u 2GHz
# Block wifi (if any)
rfkill block wlan || true

