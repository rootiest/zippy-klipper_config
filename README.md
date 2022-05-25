# Rootiest Zippy Klipper

This is my klipper_config that uses custom gcode macros extensively to enhance the 3d printing experience.

It was originally envisioned to allow data to be communicated from the Slicer to Klipper and then stored in variables for use by other macros during/before/after the print but I would like eventually for it to be a much more extensive project that truly takes advantage of what gcode macros can do!

There is now quite a large selection of macros!

From filament changes to maintenance positioning to heat soaks and print-area-meshing. There's something for everyone! And I've done my best to make the user experience as clean as possible.

Additionally, this config now utilizes:
  - Multiple temperature/humidity/environment sensors
  - Monitors chamber, ambient, and spool temp/humidity and VOC levels
  - WLED-controlled addressable LED strips
  - Directly-controlled addressable LEDs
  - KlipperScreen and an OLED panel
  - Rotary encoder and several physical buttons
  - Multi-pitch beeper
  - Smart plug for printer power
  - Smart plug for Filter power
  - Several controller boards: Printer, Pi Host, Pico, and a QTPY-rp2040
  - Speed-controlled and RPM-monitored mcu cooling fan
  - Smart filament sensor with automated filament change procedure
  - ADXL accelerometer for resonance tuning and input shaping

## Warnings

#### This is still very, very much a work in progress! 

I'm working on, breaking, changing, and using this daily! I strongly suggest nobody use this for anything more than reference/inspiration at this time.

It is likely to fail/crash on your system in its current state!

## Notes

#### The files in the `extras` folder are **not used**.

#### The files in the `machine` and `macros` folders are included in the config.

#### The `printer.cfg` file is not synced in order to preserve automatic config overrides.

Its only contents (aside from automated overrides) are:

    # Rootiest Zippy Klipper config
    
    # Machine  directory
    [include machine/*.cfg]
    
    # Macros directory
    [include macros/*.cfg]

This way we can have full access to modify any parts of the config without risking overwriting the automated overrides.


#### The following files are not synced for privacy and security purposes:
  - mooncord.json
  - telegram.conf
  - telegram_conf.conf
  - moonraker_secrets.ini

#### Automated backups are also ignored.

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

Klipper is Free Software. See the [license](COPYING) or read the
[documentation](https://www.klipper3d.org/Overview.html).
