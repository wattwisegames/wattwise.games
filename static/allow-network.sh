#!/bin/sh
# Unblock wifi (if any)
rfkill unblock wlan || true
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant

