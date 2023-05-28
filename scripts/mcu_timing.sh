#!/bin/bash
# Copyright (C) 2023 Chris Laprade (chris@rootiest.com)
# 
# This file is part of zippy_config.
# 
# zippy_config is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# zippy_config is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with zippy_config.  If not, see <http://www.gnu.org/licenses/>.

#################################################################################
#                                                                               #
# This script is used to install, update, remove, or patch the mcu.py file.     #
#                                                                               #
#      The patch will change the 'TRSYNC_TIMEOUT = 0.025' line to               #
#           'TRSYNC_TIMEOUT = 0.05' in the mcu.py file.                         #
#   This change helps address the 'Timeout while homing probe' error.           #
#                                                                               #
#   However, modifying the mcu.py file will cause the klipper repo to fail      #
#   verification.  That will prevent the automatic updating from working.       #
#                                                                               #
#   To address this, the script has an 'update' option that will update the     #
#           klipper repo and restore the custom mcu.py file.                    #
#################################################################################


## Help
# display help if no parameter is provided or 'help' is provided
if [ -z "$1" ] || [ "$1" == "help" ]; then
    echo "This script is used to install, update, remove, or patch the mcu.py file."
    echo ""
    echo "The patch will change the 'TRSYNC_TIMEOUT = 0.025' line to"
    echo "        'TRSYNC_TIMEOUT = 0.05' in the mcu.py file."
    echo "This change helps address the 'Timeout while homing probe' error."
    echo ""
    echo "However, modifying the mcu.py file will cause the klipper repo to fail"
    echo "verification.  That will prevent the automatic updating from working."
    echo ""
    echo "To address this, the script has an 'update' option that will update the"
    echo "        klipper repo and restore the custom mcu.py file."
    echo ""
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
    echo -e "\e[31mWARNING: This will modify the mcu.py file and cause the klipper repo to fail verification.\e[0m"
    echo "Press any key to continue or CTRL+C to cancel."
    read -n 1 -s
    echo "Installing custom mcu.py file..."
    # change the 'TRSYNC_TIMEOUT = 0.025' line to 'TRSYNC_TIMEOUT = 0.05'
    sed -i 's/TRSYNC_TIMEOUT = 0.025/TRSYNC_TIMEOUT = 0.05/g' ~/klipper/klippy/mcu.py
    if grep -q "TRSYNC_TIMEOUT = 0.05" ~/klipper/klippy/mcu.py; then
        echo -e "\e[32mPatch installed successfully\e[0m"
    else
        echo -e "\e[31mPatch install failed!\e[0m"
    fi
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
    # Report success or failure
    if grep -q "TRSYNC_TIMEOUT = 0.05" ~/klipper/klippy/mcu.py; then
        echo -e "\e[32mUpdated successfully\e[0m"
    else
        echo -e "\e[31mUpdate failed\e[0m"
    fi
fi

## Remove
# remove the custom mcu.py file
if [ "$1" == "remove" ]; then
    echo -e "\e[31mWARNING: This will remove the modification from the mcu.py file.\e[0m"
    echo "Press any key to continue or CTRL+C to cancel."
    read -n 1 -s
    echo "Removing custom mcu.py file..."
    # remove the custom mcu.py file
    rm ~/klipper/klippy/mcu.py
    # collect the latest mcu.py file from the klipper repo
    curl -o ~/klipper/klippy/mcu.py https://raw.githubusercontent.com/Klipper3d/klipper/master/klippy/mcu.py
    # update the klipper repo
    cd ~/klipper
    git pull
    # Report success or failure
    if grep -q "TRSYNC_TIMEOUT = 0.025" ~/klipper/klippy/mcu.py; then
        echo -e "\e[32mRemoved patch successfully\e[0m"
    else
        echo -e "\e[31mRemoving patch failed!\e[0m"
    fi
fi

## Patch
# remove the custom mcu.py file, update the klipper repo, collect the latest mcu.py file from the klipper repo, and modify the new file
if [ "$1" == "patch" ]; then
    echo -e "\e[31mWARNING: This will modify the mcu.py file and cause the klipper repo to fail verification.\e[0m"
    echo "Press any key to continue or CTRL+C to cancel."
    read -n 1 -s
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
    if grep -q "TRSYNC_TIMEOUT = 0.05" ~/klipper/klippy/mcu.py; then
        echo -e "\e[32mUpdated and patched successfully\e[0m"
    else
        echo -e "\e[31mFile patching failed!\e[0m"
    fi
fi

## Check if mcu.py file has been patched
if [ "$1" == "check" ]; then
    echo "Checking mcu.py file..."
    # check if the 'TRSYNC_TIMEOUT = 0.05' line exists
    if grep -q "TRSYNC_TIMEOUT = 0.05" ~/klipper/klippy/mcu.py; then
        echo -e "\e[32mmcu.py file has been patched\e[0m"
    else
        echo -e "\e[31mmcu.py file has not been patched\e[0m"
    fi
fi