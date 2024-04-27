#!/bin/sh
# Install cpupower and uxn11.
sudo apt install linux-tools-generic gcc git libx11-dev
git clone https://git.sr.ht/~rabbits/uxn11
cd uxn11
gcc -Os -DNDEBUG -g0 -s src/uxn.c src/devices/system.c src/devices/console.c src/devices/screen.c src/devices/controller.c src/devices/mouse.c src/devices/file.c src/devices/datetime.c src/uxn11.c -o uxn11 -lX11
sudo cp uxn11 /usr/local/bin/
# Stop every system service we can.
for service in $(systemctl | grep \\.service | grep running |grep -v bluetooth|grep -v dbus|grep -v gdm|grep -v irqbalance | grep -v kerneloops | grep -v power-profiles-daemon | grep -v rsyslog | grep -v rtkit-daemon | grep -v polkit | grep -v systemd- | grep -v upower | grep -v thermald | grep -v user@1000| tr -s ' '| cut -d' ' -f2); do sudo systemctl stop "$service"; done
# Lock CPU clock speed.
sudo cpupower frequency-set -d 2GHz -u 2GHz
# Block wifi (if any)
rfkill block wlan || true

