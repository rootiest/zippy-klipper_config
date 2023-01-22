<!--
 Copyright (C) 2023 Chris Laprade
 
 This file is part of zippy_config.
 
 zippy_config is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 zippy_config is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with zippy_config.  If not, see <http://www.gnu.org/licenses/>.
-->

# Restart KlipperScreen Script

- [Restart KlipperScreen Script](#restart-klipperscreen-script)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Macros and Scripts](#macros-and-scripts)
  - [Configuration](#configuration)
  - [Using The Macro](#using-the-macro)

This macro will trigger a restart of the KlipperScreen service.

This can be used to correct an issue where KlipperScreen seems to lose contact with the moonraker host and stops responding to things like temperature changes or prints starting.

It works by using the `gcode_shell_command` extension to run a shell command that restarts the KlipperScreen service.

## Installation

### Prerequisites

First, install the [gcode_shell_command extension](https://github.com/th33xitus/kiauh/blob/master/docs/gcode_shell_command.md). 

The easiest way to do so is using [KIAUH](https://github.com/th33xitus/kiauh).

### Macros and Scripts

To install, simply download the two files into your `~/printer_data/config` directory:

- [RESTART_KLIPPERSCREEN.cfg](RESTART_KLIPPERSCREEN.cfg)
- [restart_ks.sh](restart_ks.sh)

Then just add the following line to your `printer.cfg` file:

    [include RESTART_KLIPPERSCREEN.cfg]

## Configuration

This macro runs a simple script to restart the KlipperScreen service using the same method employed by the moonraker through the power menu in Mainsail/Fluidd.

You will however need to give the script permission to run as root.

To do this, run the following from ssh:

    sudo chmod u+s ~/printer_data/config/restart_ks.sh

You will need to enter your password to give the OS permission to give the script root privileges.

## Using The Macro

Using it is easy.

Simply run `RESTART_KLIPPERSCREEN` from the console, another macro, the slicer, etc.

For example, if you want KlipperScreen to restart 5 seconds after Klipper starts, you could use the following code in your config:

    [delayed_gcode klipperscreen_restart]
    initial_duration: 5
    gcode:
        RESTART_KLIPPERSCREEN