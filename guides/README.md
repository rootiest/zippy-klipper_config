<!--
 Copyright (C) 2022 Chris Laprade (chris@rootiest.com)

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

![header](resources/pretty_header.png)

# Guides For Klipper Things and Stuff

## [Axis Limits](GUIDE-axis_limits.md)

Calibrate the physical travel and bed size/print boundaries for _your_ machine.

## [Probe Offsets](GUIDE-probe.md)

Calibrate your probe offsets for X,Y,and Z axis.

## [Bed Mesh Boundaries](GUIDE-mesh.md)

Calibrate the boundaries for bed meshing.

## [Macros](GUIDE-macros.md)

Create and use macros for your `START_PRINT` and `END_PRINT` gcode commands.

## [Advanced Macro Techniques](GUIDE-variables.md) (WIP)

Learn more advanced techniques you can use in your macros.

Covers parameters, variables and types, gcode_variables, persistant_variables, the printer object, delayed_gcode, and more.

## [USB Pico Setup](GUIDE-usb-pico.md)

Set up a USB-connected Pico (or any RP2040 board) as a secondary mcu.

Covers compiling, flashing, configuring in Klipper, and some extras!

## [CANbus your Pico](Guide-pico_can.md)

Use an SKR-Pico (or any Pico/RP2040 board) as both a CANbus bridge _and_ a Klipper mcu.

## External Guides

The following are links to external guides that I have found useful. These are not my guides, but I have found them useful enough to include here. If you have a guide you would like to see included here, please open an issue or submit a pull request.

### [Klipper Documentation](https://www.klipper3d.org/)

The official Klipper documentation. Everything you need to know about Klipper is here. Sometimes it can be a bit hard to find what you are looking for, but it is all here. See the [Other Useful Links](GUIDE-links.md) section for some links to specific pages.

### [Klipper Discord](https://discord.klipper3d.org/)

The official Klipper Discord server. The best place to get one-on-one help with Klipper.

### [Voron Discord](https://discord.com/invite/voron)

The official Voron Discord server. Not just for Voron users!

### [Ellis's Print Tuning Guide](https://ellis3dp.com/Print-Tuning-Guide/)

One of the best guides for tuning your printer. Unlike most guides, this one specifically focuses on Klipper printers. Should be one of your first steps after getting Klipper up and running.

### [Esoterical's CANbus Guide](https://github.com/Esoterical/voron_canbus)

Pretty much the best CANbus installation resource out there. If you are looking to install a CANbus toolboard, this is the guide you want to follow.

### [Other Useful Links](GUIDE-links.md)

A collection of helpful links for Klipper users.
