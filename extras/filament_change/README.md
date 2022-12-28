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

# Smart Filament Changes

These macros allow you to have automated filament changes that simplify the process of loading and unloading filament.

This is achieved via a set of configuration variables which define everything from the machine specs and behavior to feedback and notifications.

The filament will be automatically loaded up to and out of the hotend from the extruder and automatically retracted back to the extruder during unloads.

The extruder temperature is also managed to automatically set it during/after a filament change, and to allow it to cool if you can't get to the printer immediately to assist with the filament change.

Post-runout the temperature is returned to the original printing temp so you don't have to manually set it before resuming.

During manual filament changes this behavior is modified slightly to account for the fact that we aren't printing immediately before/after the filament change.

# Configuration

You will need to configure the following variables:

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


The following variables allow you to configure behavior of notifications and feedback:

    variable_output: 118            # Select 117 or 118 to specify output method for feedback

This allows you to choose between `M117` (display status) or `M118` (console output) for feedback during filament changes. This is used to give feedback for each step of the process so you know it's working.

    variable_led_status: False      # Use LED Status macros such as on the stealthburner

This option enables support for the following macros which are used for LED feedback:

- `STATUS_M600`     Filament change/runout
- `STATUS_M702`     Filament unload
- `STATUS_M701`     Filament load
- `STATUS_HEATING`  Nozzle heating
- `STATUS_BUSY`     Printer busy
- `STATUS_READY`    Printer ready
  
Some of the macros are found in the stealthburner led configs, but I have added a few extras specific to filament changes. These macros simply activate lighting profiles.

    variable_audio_status: False    # Use audio feedback macros

This option enables support for audio feedback macros.

This relies on only one macro:

- `CHANGE_TUNE` Plays a short notification tone

This tone is used to indicate that a load/unload has completed.

It also uses a repeating delayed_gcode macro to repeat this tone every 5 seconds to notify the user of a filament runout.

    variable_use_telegram: False    # Use Telegram feedback macros

This option enables the following macro:

- `TELEGRAM_FILAMENT_RUNOUT` Telegram runout notification

This macro is used to send a notification via the telegram extension in order to indicate a filament runout

# Usage

This macro can be used in a few ways as described below:

## Filament Runouts

Configure your `filament_switch_sensor` as follows:

    [filament_switch_sensor filament_sensor]
    switch_pin: ^PB6
    pause_on_runout: False #pause handled by macro
    runout_gcode:
      FILAMENT_RUNOUT
    insert_gcode:
      LOAD_FILAMENT

Configure your `filament_motion_sensor` as follows:

    [filament_motion_sensor smart_filament_sensor]
    switch_pin: ^PB6
    detection_length: 7.0
    extruder: extruder
    pause_on_runout: False #pause handled by macro
    runout_gcode:
      FILAMENT_RUNOUT
    insert_gcode:
      LOAD_FILAMENT

If your filament sensor is not nearby to your extruder, you may want to leave out the `insert_gcode` part of this configuration.

If your filament sensor *is* just before the extruder, then this feature will allow it to start the loading macro immediately as soon as the sensor detects filament again.

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

# Additional Notes

All of these macros also support several parameters that allow you to set specific behavior outside of the defaults you configure in the variables.

- `TARGET` Allows you to override the target temperature used by the macro
- `LENGTH` Allows you to override the length used in the `PURGE` and `UNLOAD_FILAMENT` macros.
- `FAST` Allows you to override the "fast" length for the `LOAD_FILAMENT` macro
- `SLOW` Allows you to override the "slow" length for the `LOAD_FILAMENT` macro

# Final Notes

This may seem a bit overwhelming or complicated at first, but if you've ever wanted something more than what the common `M600` macros provide, this is for you!

Just follow the directions carefully, and I think you'll find this is actually much easier to use once you have it configured.

Feel free to contact me on Discord at `rootiest#5668` if you have any questions or issues!