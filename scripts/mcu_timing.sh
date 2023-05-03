#!/bin/bash
# Copyright (C) 2023 Chris Laprade (chris@rootiest.com)
# 
# This file is part of Hephaestus.
# 
# Hephaestus is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Hephaestus is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Hephaestus.  If not, see <http://www.gnu.org/licenses/>.

## Help
# display help if no parameter is provided or 'help' is provided
if [ -z "$1" ] || [ "$1" == "help" ]; then
    echo "Usage: mcu_timing.sh [install|update|remove|patch|check|help]"
    echo "  install: install the custom mcu.py file"
    echo "  update: update the klipper repo and restore the custom mcu.py file"
    echo "  remove: remove the custom mcu.py file"
    echo "  patch: update the klipper repo and modify the new mcu.py file"
    echo "  check: check if the mcu.py file has been patched"
    echo "  help: display this help message"
    exit 0
fi

## Install
# find the 'TRSYNC_TIMEOUT = 0.025' line and change it to 'TRSYNC_TIMEOUT = 0.05'
if [ "$1" == "install" ]; then
    echo "Installing custom mcu.py file..."
    # change the 'TRSYNC_TIMEOUT = 0.025' line to 'TRSYNC_TIMEOUT = 0.05'
    sed -i 's/TRSYNC_TIMEOUT = 0.025/TRSYNC_TIMEOUT = 0.05/g' ~/klipper/klippy/mcu.py
fi

## Update
# update with the latest version from the klipper repo while using a custom mcu.py file
if [ "$1" == "update" ]; then
    echo "Updating klipper repo and restoring custom mcu.py file..."
    # save the custom mcu.py file
    cp ~/klipper/klippy/mcu.py /tmp/mcu.py
    # remove the custom mcu.py file
    rm ~/klipper/klippy/mcu.py
    cd ~/klipper
    # update the klipper repo
    git pull
    # restore the custom mcu.py file
    cp /tmp/mcu.py ~/klipper/klippy/mcu.py
    # remove the backed up custom mcu.py file
    rm /tmp/mcu.py
fi

## Remove
# remove the custom mcu.py file
if [ "$1" == "remove" ]; then
    echo "Removing custom mcu.py file..."
    # remove the custom mcu.py file
    rm ~/klipper/klippy/mcu.py
    # collect the latest mcu.py file from the klipper repo
    curl -o ~/klipper/klippy/mcu.py https://raw.githubusercontent.com/Klipper3d/klipper/master/klippy/mcu.py
    # update the klipper repo
    cd ~/klipper
    git pull
fi

## Patch
# remove the custom mcu.py file, update the klipper repo, collect the latest mcu.py file from the klipper repo, and modify the new file
if [ "$1" == "patch" ]; then
    echo "Patching mcu.py file..."
    # remove the custom mcu.py file
    rm ~/klipper/klippy/mcu.py
    # collect the latest mcu.py file from the klipper repo
    curl -o ~/klipper/klippy/mcu.py https://raw.githubusercontent.com/Klipper3d/klipper/master/klippy/mcu.py
    # update the klipper repo
    cd ~/klipper
    git pull
    # change the 'TRSYNC_TIMEOUT = 0.025' line to 'TRSYNC_TIMEOUT = 0.05'
    sed -i 's/TRSYNC_TIMEOUT = 0.025/TRSYNC_TIMEOUT = 0.05/g' ~/klipper/klippy/mcu.py
fi

## Check if mcu.py file has been patched
if [ "$1" == "check" ]; then
    echo "Checking mcu.py file..."
    # check if the 'TRSYNC_TIMEOUT = 0.05' line exists
    if grep -q "TRSYNC_TIMEOUT = 0.05" ~/klipper/klippy/mcu.py; then
        echo "mcu.py file has been patched"
    else
        echo "mcu.py file has not been patched"
    fi
fi

## How to do an if or statement
# if [ "$1" == "install" ] || [ "$1" == "update" ]; then

## How to have git verify the repo
# git pull