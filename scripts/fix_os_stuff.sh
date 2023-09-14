#!/bin/bash

# This script is just a couple of lines to fix common OS issues that can cause problems with Klipper.

curl -sSL https://raw.githubusercontent.com/mainsail-crew/MainsailOS/develop/patches/udev-fix.sh | bash
sudo apt remove brltty
sudo systemctl disable ModemManager
sudo reboot