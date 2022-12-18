<!--
 Copyright (C) 2022 Chris Laprade
 
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

# TOOL SWAP

These macros allow you to swap configs with a single command.

This works by changing the first line of your `printer.cfg` file.

On that line, you would place an `[include]` that will tell Klipper which config to load.

This does require a `FIRMWARE_RESTART` to activate. Do not run these commands during a print!

## Installation

### Prerequisites

First, install the [gcode_shell_command extension](https://github.com/th33xitus/kiauh/blob/master/docs/gcode_shell_command.md). 

The easiest way to do so is using [KIAUH](https://github.com/th33xitus/kiauh).

### Macros and Scripts

Download the following to your `~printer_data/config/` directory:

- [swap_tools.cfg](swap_tools.cfg)
- [tool1.cfg](tool1.cfg)
- [tool1.sh](tool1.sh)
- [tool2.cfg](tool1.cfg)
- [tool2.sh](tool2.sh)

## Configuration

### Prerequisites

Move the config sections that you wish to be swapped out into the `tool1.cfg` file.

Place the configs that will be swapped in into the `tool2.cfg` file

### Include Config

Add the following two lines to the your `printer.cfg` file as ***the first two lines***:

    [include tool1.cfg]
    [include swap_tools.cfg]

> Note: It's very important that the ***first*** lines of your printer.cfg file are as shown above.

## Usage

To swap to the second tool simply run:

    CHANGE_TOOL TOOL=2

To swap to the first tool simply run:

    CHANGE_TOOL TOOL=1

> NOTE: Remember that doing this requires a `FIRMWARE_RESTART`. Do not try to change tools during a print!