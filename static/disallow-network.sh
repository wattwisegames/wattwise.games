#!/bin/sh
# Block wifi (if any)
rfkill block wlan || true
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant

