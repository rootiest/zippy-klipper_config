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

This works by changing a line of your `printer.cfg` file using a shell script.

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
- [tool2.cfg](tool2.cfg)
- [tool_swap.sh](tool_swap.sh)

## Configuration

### Prerequisites

Move the config sections that you wish to be associated with "tool1" into the `tool1.cfg` file.

Place the config sections that you wish to be associated with "tool2" into the `tool2.cfg` file.

### Include Config

Add the following two lines to the your `printer.cfg` file:

    [include tool1.cfg]
    [include swap_tools.cfg]

## Usage

To swap to the second tool simply run:

    CHANGE_TOOL TOOL=2

To swap to the first tool simply run:

    CHANGE_TOOL TOOL=1

> NOTE: Remember that doing this requires a `FIRMWARE_RESTART`. Do not try to change tools during a print!

## Updates

As of `2022-12-28` this macro now uses a smarter shell script that no longer requires you to place the `[include]` line at the start of the file.

It also no longer requires separate shell scripts for each tool, opting instead to use a regex pattern to detect any variation of tool1, tool2, tool3, tool5, tool420, etc in an `[include tool#.cfg]` line.

This makes it easier to use the include line anywhere in the printer.cfg file you'd like as well as making it easy to support as many "tool" configs as you need.

You can also simply edit the shell script to change the filename used if you'd like the `[include]` to be used in a different file than the base printer.cfg file.

I was too lazy/inexperienced to write out the regex and scripting required to make these improvements when I wrote the original, so we can thank ChatGPT for doing the grunt-work required to introduce these QoL improvements!