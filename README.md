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

# Rootiest Zippy Klipper

![header](guides/resources/pretty_header.png)

This is my klipper_config that uses custom gcode macros extensively to enhance the 3d printing experience.

It was originally envisioned to allow data to be communicated from the Slicer to Klipper and then stored in variables for use by other macros during/before/after the print but I would like eventually for it to be a much more extensive project that truly takes advantage of what gcode macros can do!

There is now quite a large selection of macros!

From filament changes to maintenance positioning to heat soaks and print-area-meshing. There's something for everyone! And I've done my best to make the user experience as clean as possible.

Additionally, this config now utilizes:

- Multiple temperature/humidity/environment sensors
- Monitors chamber, ambient, and spool temp/humidity and VOC levels
- WLED-controlled addressable LED strips
- Directly-controlled addressable LEDs
- KlipperScreen on a 7-inch HDMI touchscreen
- Two SSH1306 OLED displays with custom display data
- A BTT Mini12864 display hosted by a custom STM32 controller board for easy usb connectivity
- Rotary encoder and several physical buttons
- Multi-pitch beeper
- Smart plug for printer power
- Smart plug for Filter power
- Nevermore Carbon Filter
- A controllable fan-enhanced desiccant box
- MAX31865/PT-1000 extruder thermistor
- Several controller boards: SKR-Pico, Pi Host, EBB42 CANbus Toolhead, Pico, and two QTPY-rp2040
- All of the toolhead components have been moved to the CANbus board
- Speed-controlled cooling fans for Nevermore, bed fans, and part-cooling
- Temperature-controlled fans for hotend, exhaust, SKR-Pico, and Pi host.
- Smart filament sensor with automated filament change procedure
- Two ADXL accelerometers for resonance tuning and input shaping
- An extensive collection of custom macros

## Guides

If you are looking for guides on calibrating or setting up a new Klipper printer, those are found here:

### [Zippy Guides](https://github.com/rootiest/zippy_guides)

## Warnings

### This is still (and likely always will be) very, very much a work in progress

I'm working on, breaking, changing, and using this daily! I strongly suggest nobody use this full config for anything more than reference/inspiration at this time.

It is likely to fail/crash on your system in its current state!

Many of these macros work as great examples of using scripting and other Klipper features to perform different tasks.

Many may even work on your printer as-is.

But a lot of them won't.

So consider this more of a selection of examples that will likely need to be tailored to fit your unique system. Use it as a resource to see how you _could_ do something, not necessarily how you **should**. Feel free to message me with questions if you have them.

## Notes

### The files in the `extras` folder are **not used**

This may be just because they conflict with other existing macros I already use, or they are there as samples/examples. But they aren't included on my personal system.

### The files in the `machine` and `macros` folders are included in the config

The `machine` folder is included by the [printer.cfg](extras/samples/printer.cfg) file and the rest are included through [zippy.cfg](machine/zippy.cfg)

### The `printer.cfg` file is not synced in order to preserve automatic config overrides

Its only contents (aside from automated overrides) are:

    # Rootiest Zippy Klipper config

    # Machine  directory
    [include machine/*.cfg]

This way we can have full access to modify any parts of the config without risking overwriting the automated overrides.

The [zippy.cfg file](machine/zippy.cfg) contains the includes for the macros directory as well as some other files used by extensions. This allows the paths of those files to be preserved to maintain compatibility with extension updates.

A snapshot of the printer.cfg file is available to see here:

[printer.cfg](extras/samples/printer.cfg)

### The following files are not synced for privacy and security purposes

- mooncord.json
- telegram.conf
- telegram_conf.conf
- moonraker_secrets.ini

Sanitized examples can be seen here:

[Sanitized Samples](extras/samples/README)

### Automated backups are also ignored

This helps to prevent accidental syncing of your private passwords or tokens as well as reducing clutter from backup files.

## Acknowledgments

Many parts of this project were borrowed quite heavily from other people's work.

I am compiling a list of acknowledgements to include in this README before posting publicly.

---

[Klipper](https://www.klipper3d.org/)

<https://www.klipper3d.org/>

Klipper is a 3d-Printer firmware. It combines the power of a general
purpose computer with one or more micro-controllers. See the
[features document](https://www.klipper3d.org/Features.html) for more
information on why you should use Klipper.

To begin using Klipper start by
[installing](https://www.klipper3d.org/Installation.html) it.

Klipper is Free Software. See the [license](LICENSE) or read the
[documentation](https://www.klipper3d.org/Overview.html).

## Contact

Rootiest#5668 on Discord (Voron and Klipper servers)

Donate to support my work:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/rootiest)

Join the [Rootiest Discord server](https://discord.gg/AYjVSvrVF2) for information and support for my projects.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/rootiest/zippy_guides/main/resources/github-snake-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/rootiest/zippy_guides/main/resources/github-snake.svg">
  <img alt="Shows a snake consuming the squares from the rootiest contributions graph." src="https://raw.githubusercontent.com/rootiest/zippy_guides/main/resources/github-snake.svg">
</picture>
