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

# ADXL_SHAPER

These macros are meant to simplify and automate the shaper calibration process.

They performs the following steps:

- Home the printer (if needed)
- Calibrate the shapers
- Generate the graph images
- Save the recommended shaper settings to your config

## WARNING

### __Please use the [public ADXL_SHAPER version](../extras/shaper/README.md) instead.__

This is my personal configuration of these macros.

My configuration depends upon several macros that exist elsewhere in my config and will throw errors on other printers.

## Installation

### Prerequisites

First, install the [gcode_shell_command extension](https://github.com/th33xitus/kiauh/blob/master/docs/gcode_shell_command.md). 

The easiest way to do so is using [KIAUH](https://github.com/th33xitus/kiauh).

### Macros and Scripts

Next create a `shaper` folder in your `~printer_data/config` directory.

Download the following to that `~printer_data/config/shaper/` directory:

- [ADXL_SHAPER.cfg](ADXL_SHAPER.cfg)
- [adxl_shape_x.sh](adxl_shape_x.sh)
- [adxl_shape_y.sh](adxl_shape_y.sh)

## Configuration

### Prerequisites

You need to have you ADXL or MPU accelerometers for both axis and a `test_resonances` section configured for this to work.

> If you are able to measure both axis from a single accelerometer then you only need the one.

The [ADXL_SHAPER.cfg](ADXL_SHAPER.cfg) file contains a `[respond]` line. This is necessary for sending feedback in the console.

However, if you already have that section elsewhere in your config then you can safely comment out or delete it here.

### Include Config

Add the following line to your `printer.cfg` file near the top:

    [include ./shaper/ADXL_SHAPER.cfg]

## Usage

Simply run one of the following:

- `ADXL_SHAPE_ALL` to calibrate both axis
- `ADXL_SHAPE_X` to calibrate only the X axis
- `ADXL_SHAPE_Y` to calibrate only the Y axis

No parameters are needed.

# Credits

This project was designed by [Peviox](https://github.com/Peviox) and shared here with his permission.