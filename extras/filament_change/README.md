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

# Smart Filament Changes

These macros allow you to have automated filament changes that simplify the process of loading and unloading filament.

This is achieved via a set of configuration variables which define everything from the machine specs and behavior to feedback and notifications.

The filament will be automatically loaded up to and out of the hotend from the extruder and automatically retracted back to the extruder during unloads.

The extruder temperature is also managed to automatically set it during/after a filament change, and to allow it to cool if you can't get to the printer immediately to assist with the filament change.

Post-runout the temperature is returned to the original printing temp so you don't have to manually set it before resuming.

During manual filament changes this behavior is modified slightly to account for the fact that we aren't printing immediately before/after the filament change.

# Contents

- [Smart Filament Changes](#smart-filament-changes)
- [Contents](#contents)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Filament Runouts](#filament-runouts)
  - [Slicer Material/Color Change](#slicer-materialcolor-change)
  - [Manual Filament Change](#manual-filament-change)
  - [Manual Purging](#manual-purging)
  - [Nozzle Change](#nozzle-change)
  - [Maintenance Parking](#maintenance-parking)
  - [Toggling Filament Sensing](#toggling-filament-sensing)
    - [Automating Filament Sensor Toggling](#automating-filament-sensor-toggling)
- [Additional Notes](#additional-notes)
  - [Parameters](#parameters)
  - [Additional Steps](#additional-steps)
- [Changelog](#changelog)
  - [v2.5.2 2023-5-6](#v252-2023-5-6)
  - [v2.4.0 2023-04-02](#v240-2023-04-02)
  - [v2.3.0 2023-02-17](#v230-2023-02-17)
  - [v2.2.5 2023-1-27](#v225-2023-1-27)
  - [v2.2.0 2023-1-27](#v220-2023-1-27)
  - [v2.5.0 2023-4-16](#v250-2023-4-16)
  - [v2.0.1 2023-1-3](#v201-2023-1-3)
  - [v2.0 2023-1-1](#v20-2023-1-1)
  - [v1.9 2022-12-30](#v19-2022-12-30)
- [Final Notes](#final-notes)

# Installation

Simply download the following file:

[smart-m600.cfg](smart-m600.cfg)

and place it in your `~/printer_data/config` directory alongside your `printer.cfg` file.

Then add this line to your `printer.cfg` file:

    [include smart-m600.cfg]

This will add the macros to your config.

Make sure you also follow the rest of this guide to properly configure the macros!

# Configuration

You will need to configure some variables to define the behavior of the macro.

These are found in the `smart-m600.cfg` file under the following section:

    ################################
    ###### M600 CONFIGURATION ######
    ################################
    [gcode_macro _m600cfg]

These variables will define everything the macro needs to know about how to operate on your machine.

Nothing else will need to be changed <sup>[*](#additional-steps)

The configuration variables are listed below with a description of the appropriate values:

    variable_sensor_name: 'filament_sensor' # The name of the filament sensor used

Here you will enter the name given to your filament sensor.

A common name is `filament_sensor`. You can find this name in your configuration where the filament sensor is defined. Examples can be found at the end of [the smart-m600.cfg file](smart-m600.cfg).

In the examples shown, the name used is `filament_sensor`. You can see where that is specified in the snippet below:

`[filament_switch_sensor filament_sensor]`

Simply set this to the name you use in your configuration for the filament sensor.

-----

    variable_default_temp: 220      # The default temperature used

This variable defines the temperature used when a filament change is executed from a cold start or from below the `min_extrude_temp` defined by your extruder.

    variable_x: -15                 # Filament change park coordinate for X
    variable_y: 220                 # Filament change park coordinate for Y

These variables define the X and Y coordinates to park at during a filament change.

    variable_zmin: 150              # Minimum filament change park height

This is the minimum height to park at during filament changes. If a runout occurs at a height above this, it will park higher.

    variable_z: 10                  # Filament change z-hop height

This variable defines how much higher to park for filament changes when a runout occurs at a height above the zmin defined above. This will not go above the `max_position` defined in your z_stepper config.

    variable_load_fast: 50          # Length to load the filament before reaching the hotend

This variable defines the length to extrude while loading to cover the distance between the extruder and the hotend. It should bring the filament to just before the nozzle.

    variable_load_slow: 75          # Length to extrude/purge filament out of hotend

This is the length to extrude after the filament has reached the nozzle. This is essentially your post-filament-change purge length.

    variable_unload_length: 75      # Length of filament to retract during unload

This is the length of filament to retract during the unload command. It should be enough to pull the filament all the way back from the nozzle through the extruder so it is easy to remove and change for another spool.

    variable_purge_length: 50       # Length of filament to extrude during purge

This is the length to extrude when using the PURGE command. This command is used for extra purging if the color is especially slow to change over, or for other manual purging purposes.

-----

    # NOTE: Speeds are given in mm/min 
    
NOTE: All of the speed variables used below are in mm/min.

    variable_fast_speed: 1000       # Speed for fast extruder moves (between extruder and hotend)

This is the speed used when bringing the filament up to the nozzle but not extruding it.

    variable_med_speed: 500         # Speed for medium extruder moves (extruder catching the new filament)

This speed is used for a short time (25mm) at the start of the filament load to allow the extruder to catch the end of the new filament.

    variable_slow_speed: 250        # Speed for slow extruder moves (actual extrusion out of the hotend)

This is the speed used after the filament has reached the hotend during a filament load. This is the extruding/purging speed.

    variable_park_speed: 9000       # Speed of X/Y moves during parking

This is the speed of X/Y moves during the parking actions.

-----

The following variable allows you to configure behavior of feedback:

    variable_output: 118            # Select 116, 117, or 118 to specify output method for feedback

This allows you to choose between `M117` (display status) or `M118` (console output) for feedback during filament changes. This is used to give feedback for each step of the process so you know it's working.

You can also enter `116` to use the "dummy" `M116` macro. This macro effectively silences all feedback from macros in this set.

The choices are as follows:

- `117` : Use the `M117` command to output status feedback to the display.
- `118` : Use the `M118` command to output status feedback to the console/terminal.
- `116` : Use the `M116` command to disable/silence all status feedback.

-----

The remaining three variables are used to enable optional notification macros:

    variable_led_status: False      # Use LED Status macros such as on the stealthburner

This option enables support for the following macros which are used for LED feedback:

- `STATUS_M600`     Filament change/runout
- `STATUS_M702`     Filament unload
- `STATUS_M701`     Filament load
- `STATUS_HEATING`  Nozzle heating
- `STATUS_BUSY`     Printer busy
- `STATUS_READY`    Printer ready
  
Some of the macros are found in [the stealthburner led configs](https://github.com/VoronDesign/Voron-Stealthburner/blob/main/Firmware/stealthburner_leds.cfg), but I have added a few extras specific to filament changes. These macros simply activate lighting profiles.

You will need to already have these macros or create them yourself. The stealthburner config linked above contains most of them, but you will need to create a few additional. Use the existing ones as a template.

-----

    variable_audio_status: False    # Use audio feedback macros

This option enables support for audio feedback macros.

This relies on only one macro:

- `CHANGE_TUNE` Plays a short notification tone

Here is an example:

    [gcode_macro change_tune]
    description: Change filament tune
    gcode:
        M300 S440 P200
        M300 S660 P250
        M300 S880 P300

The macro should play a tone that is short enough to be suitable for repeating approximately every 5 seconds. Feel free to experiment and come up with your own tones!

This tone is used to indicate that a load/unload has completed.

It also uses a repeating delayed_gcode macro to repeat this tone to notify the user of a filament runout.

    variable_audio_freq: 5          # The frequency to repeat the audio tone

This variable specifies how frequently to replay the indicator tone set by the previous variable.

The value is given in seconds, with a default of 5 seconds.

    variable_audio_macro: 'CHANGE_TUNE' # The frequency to repeat the audio tone

This variable specifies the macro name for the audio notification. By default it uses `CHANGE_TUNE` which is compatible with the example macro shown in the `variable_audio_status` section.

However, this option allows you to specify a different macro to customize this behavior. 

The macro specified here will be executed by the audio status notifications. It will also be repeatedly executed at a frequency specified by the previous variable.

-----

    variable_use_telegram: False    # Use Telegram feedback macros

This option enables the following macro:

- `TELEGRAM_FILAMENT_RUNOUT` Telegram runout notification

This macro is used to send a notification via the telegram extension in order to indicate a filament runout

-----

    variable_auto_sensor: False             # Automate filament sensor toggling

This variable enables the *optional* feature that disables the filament sensor outside of prints.

This feature is disabled by default.

Unlike any other function of these macros, this one requires an additional step beyond just setting the variable to `True`.

In order to use this feature, you ***must*** add the following to your `START_PRINT` macro:

`ENABLEFILAMENTSENSOR`

You also may want to add the following to your `END_PRINT` macro:

`DISABLEFILAMENTSENSOR`

The result of making those changes and setting this variable to `True` is that the filament sensor will not trigger outside of prints.

This is a convenient way to prevent accidental triggering when performing maintenance and other pre/post-print tasks.

The sensor will also be enabled briefly after filament unloading to facilitate automated loading when the sensor detects the new filament.

    variable_auto_load: True                # Set this to False if you do not want the filament to load auomatically

This option governs whether the filament sensor detecting the filament being inserted will trigger a `LOAD_FILAMENT` automatically. It is enabled (`True`) by default.

    variable_load_delay: 0                  # Delay before loading on filament insert

This variable defines the delay before loading when a filament insertion is detected. The value is given in seconds. This will only apply when `variable_auto_load: True`

    variable_auto_unload: False             # Set this to True to have runouts and color-changes unload right away

This option governs whether the filament will be unloaded immediately after a runout is triggered (`FILAMENT_RUNOUT`) or a slicer-initiated filament/color-change occurs (`M600`) It is disabled (`False`) by default.

    variable_clean_nozzle: False            # Set this to True to perform a nozzle cleaning after loading

This option will cause the printer to perform a nozzle cleaning procedure after loading the filament.

    variable_clean_macro: 'CLEAN_NOZZLE'    # Set this to the name of your nozzle cleaning macro

This variable is the name of the nozzle cleaning macro used by the option above. You will need to provide your own nozzle-cleaning macro to use this feature.
# Usage

This macro can be used in a few ways as described below:

There are three main types of filament change triggers:

1. **Runouts:** These will use the `FILAMENT_RUNOUT` command.
2. **Slicer:** These will use the `M600` command.
3. **Manual:** These will use the `CHANGE_FILAMENT` command.

## Filament Runouts

Configure your `filament_switch_sensor` as follows:

    [filament_switch_sensor filament_sensor]
    switch_pin: ^PB6
    pause_on_runout: False #pause handled by macro
    runout_gcode:
      FILAMENT_RUNOUT
    insert_gcode:
      _INSERT_FILAMENT

Configure your `filament_motion_sensor` as follows:

    [filament_motion_sensor smart_filament_sensor]
    switch_pin: ^PB6
    detection_length: 7.0
    extruder: extruder
    pause_on_runout: False #pause handled by macro
    runout_gcode:
      FILAMENT_RUNOUT
    insert_gcode:
      _INSERT_FILAMENT

If your filament sensor is not nearby to your extruder, you should set `variable_auto_load: False`

If your filament sensor *is* just before the extruder, then this feature will allow it to start the loading macro immediately as soon as the sensor detects filament again.

You can also configure a delay (`variable_load_delay`) if you need a few seconds to push the filament past the sensor and into the extruder.

This will allow filament runouts to automatically begin the filament change procedure.

The steps to use this are as follows:

- The printer will pause and move the toolhead to the parking position
- A notification will occur
- The extruder will cool and the bed will remain heated
- The idle_timeout will be increased
- It will wait for the user to either fix the issue and resume the print, or run `UNLOAD_FILAMENT`
- Assuming unloading is chosen, the extruder will re-heat to the original printing temp
- the filament will unload once heated
- **The user may now change the filament**
- The printer will wait for `LOAD_FILAMENT` to run, either run manually or triggered by the insert_gcode
- The filament will load and purge
- The extruder will remain heated and ready to resume printing
- The user may now `RESUME` the print

This process is meant to not only automate the filament change steps, but also to better manage steps like heating and cooling the extruder. In the case of a runout, the current extruder target is stored and then used for heating during and after the filament change.

## Slicer Material/Color Change

Filament changes can be initiated by the slicer. This is typically used for color/filament changes at specific points in the print.

In your slicer, use the `COLOR_CHANGE` command for filament changes/color changes.

In Cura that will require a post-processing plugin.

In PrusaSlicer/SuperSlicer simply add it in the custom gcode for Filament Changes.

In both cases just add `COLOR_CHANGE` to the gcode for that task.

This functions similarly to the `FILAMENT_RUNOUT` command except it unloads automatically without waiting for user confirmation.

## Manual Filament Change

This process is very similar to the runout process above but it behaves slightly differently:

- To begin, run `CHANGE_FILAMENT`
- The printer will heat the extruder to the default_temp defined
- Once heated, `UNLOAD_FILAMENT` will be run immediately, without any user intervention required
- **The user may now change the filament**
- The printer will wait for `LOAD_FILAMENT` to run, either run manually or triggered by the insert_gcode
- The filament will load and purge
- The extruder will immediately begin cooling once complete

The slight differences in behavior just addresses the minor inconvenience of heating/cooling the extruder when changing filament manually vs during a print.

## Manual Purging

There is also a `PURGE` command included. This command will allow you to extrude an additional length of filament when you need a little extra purging.

To use this, simply run `PURGE`

## Nozzle Change

You can use the `NOZZLE_CHANGE` command to perform nozzle changes. 

It will park the toolhead in a convenient location (by default the center of the XYZ axes) and then unload the filament.

Once you have completed the nozzle change you can run `NOZZLE_CHANGE_DONE` to load the filament and cool down the hotend.

To change the parking coordinates, see [the MAINTENANCE macro](#maintenance-parking)
## Maintenance Parking

This macro parks the toolhead in a convenient position for performing maintenance.

To change the maintenance parking position, change all three variable values **on the `MAINTENANCE` macro:

    variable_maint_x: -1
    variable_maint_y: -1
    variable_maint_z: -1

When any of these values are set to `-1` the default (centered) parking coordinates will be used.

Changing them all to your preferred coordinates will change the parking location used by `MAINTENANCE` (and others that use it like `NOZZLE_CHANGE`)

## Toggling Filament Sensing

You can use the following commands to toggle the filament sensor on and off:

`ENABLEFILAMENTSENSOR` : This command will enable the filament sensor, allowing it to respond to triggers.

`DISABLEFILAMENTSENSOR` : This command will disable the filament sensor, preventing it from responding to triggers.

> NOTE: This requires that you properly define the `sensor_name` variable so the macros know what sensor to control.

These commands also accept a `SENSOR` parameter that allows you to override the name of the sensor being controlled. If the parameter is not specified then the configured `sensor_name` will be used.

### Automating Filament Sensor Toggling

To automate this sensor-toggling process, set the `auto_sensor` variable to `True` and add the companion commands to your `START_PRINT` and `END_PRINT` macros:

Anywhere in `START_PRINT`:

    ENABLEFILAMENTSENSOR

Anywhere in `END_PRINT`:

    DISABLEFILAMENTSENSOR

The `auto_sensor` cannot accept a parameter, so only the configured `sensor_type` will be automatically controlled by this feature.

# Additional Notes

## Parameters

All of these macros also support several parameters that allow you to set specific behavior outside of the defaults you configure in the variables.

- `TARGET` Allows you to override the target temperature used by the macro
- `LENGTH` Allows you to override the length used in the `PURGE` and `UNLOAD_FILAMENT` macros.
- `FAST` Allows you to override the "fast" length for the `LOAD_FILAMENT` macro
- `SLOW` Allows you to override the "slow" length for the `LOAD_FILAMENT` macro
-  `SENSOR` Allows you to override the sensor being controlled by the `ENABLEFILAMENTSENSOR` and `DISABLEFILAMENTSENSOR` macros

## Additional Steps

Virtually all of this macro package can be used without making any modifications to your existing configuration. Instead, they rely on the variables to configure their behavior.

There is one exception to this however:

When using the automated sensor toggling via the `auto_sensor`, you must add a command to your `START_PRINT` and `END_PRINT` macros.

This change is described above in the documentation for that `auto_sensor` variable, but the necessary changes will also be listed below:

Near/at the end of your `START_PRINT` macro, just before the print begins, add the following:

    ENABLEFILAMENTSENSOR

Near/at the end of your `END_PRINT` macro add the following:

    DISABLEFILAMENTSENSOR

This will ensure the sensor is enabled at the start of prints and then disabled again after the print completes. This works in concert with a delayed_gcode macro that disables the sensor at startup.

This helps to prevent accidental triggering outside of prints when performing maintenance and other tasks.

# Changelog

## v2.5.2 2023-5-6

- Some fixes for `auto_unload` and homing checks in non-standard use-cases. Thanks for pointing these out Eliminateur#2987!

## v2.4.0 2023-04-02

- Added `COLOR_CHANGE` macro which can be used for slicer-triggered filament/color changes. Thank you [Peviox](https://github.com/Peviox) for assisting with porting this over from my other project.
## v2.3.0 2023-02-17

- Check for missing `min_extrude_temp` setting in config and use `170` as a fallback if it is not defined. (170 is the default value that Klipper uses when none is defined)

## v2.2.5 2023-1-27

- Add `clean_nozzle` option. Set to `True` to execute a nozzle-cleaning macro after ffilament loading is complete.
- Add `clean_macro` variable. Use this to specify the name of your nozzle-cleaning macro. You must provide your own nozzle-cleaning macro. This macro is not provided (yet)


## v2.2.0 2023-1-27

- __IMPORTANT: Changes to the way filament insertions work__
    
    Regardless of your build, please set the `insert_gcode` for your filament_sensor as follows:

        insert_gcode:
            _INSERT_FILAMENT

    The `auto_load` variable will determine whether insertions automatically trigger a `LOAD_FILAMENT` so you no longer need to adjust your `insert_gcode`. All builds will use the same configuration.

- An `auto_unload` option has also been added. This is not enabled by default. Setting `auto_unload: True` will cause the macro to unload the filament immediately after any runout/filament change commands, without any user input.

- Added `use_fluidd` option: This will output the next macro commands to the console to more easily proceed with the steps.
- Set `auto_sensor` to `False` by default. Change this to `True` to have the sensor disable automatically. ([See above section for config](#automating-filament-sensor-toggling))
- Track mode of operation to differentiate between `FILAMENT_RUNOUT` and `M600`
- Handle configs that lack a `extruder.min_extrude_temp`
- Misc Bugfixes
- The following variables were added in this update:
    
        variable_use_fluidd: True
        variable_auto_load: True
        variable_auto_unload: False
        variable_runout: False

## v2.5.0 2023-4-16

- Added `NOZZLE_CHANGE` and `MAINTENANCE` macros.
- Fixed a typo in the `COLOR_CHANGE` macro.

## v2.0.1 2023-1-3

- Minor bug fix to repair `coldstart` feature. This should hopefully prevent runouts from ever being triggered during manual filament changes.
## v2.0 2023-1-1

- Added automated filament sensor toggling. This keeps the sensor disabled outside of prints.
- Added macros for toggling filament sensing on/off. This is a companion to the automated sensing.
- This also addresses a bug in the previous version where the `ENABLEFILAMENTSENSOR` command was used without being defined. Thanks [Peviox](https://github.com/Peviox)
- Added `[display_status]` in case the user is missing that section.
- Fixed `HOME_IF_NEEDED` to use the `output` variable.
- Various organization and documentation improvements
## v1.9 2022-12-30

- Added configuration variables for `audio_macro` and `audio_freq`.
- `audio_freq` allows the user to configure the frequency at which the audio notifications are repeated to notify a runout has occurred.
- `audio_macro` allows the user to specify a custom macro to be executed for audio notifications.
- Added a `116` option for status notifications via the `output` variable. This allows the user to silence/disable those status updates. An empty `M116` macro has been included to facilitate this.
- An example audio tone macro has been added to the README.
- Additional details and a link have been added to the README section for `led_status`
- Other minor corrections and formatting adjustments made to the documentation.
# Final Notes

This may seem a bit overwhelming or complicated at first, but if you've ever wanted something more than what the common `M600` macros provide, this is for you!

Just follow the directions carefully, and I think you'll find this is actually much easier to use once you have it configured.

Feel free to contact me on Discord at `rootiest#5668` if you have any questions or issues!