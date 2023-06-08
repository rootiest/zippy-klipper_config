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

# An Incomplete Macros List

## START_PRINT and END_PRINT

Obviously `START_PRINT` and `END_PRINT` are like the core, most-used macros. Examples of those and some others can be found in the [sample-macros.cfg](https://github.com/Klipper3d/klipper/blob/master/config/sample-macros.cfg#L8-L49) in the Klipper docs. [I made a guide](../guides/GUIDE-macros.md) that works with those sample macros and shows you how to configure your slicer to use them properly. You don't want to use mine, they are pretty bloated.

## Borrowed Macros

I think `M600` for filament changes is another common one, though it's also one that's difficult to design "for everyone" A good start is the [simple_m600.cfg](../extras/simple-m600.cfg) here in my extras folder.

`LAZY_HOME` is another convenient one, mostly to use in other macros, it checks if the printer is already homed and only homes it if necessary. My [LAZY_HOME.cfg](LAZY_HOME.cfg) file also contains an alias so HOME_IF_NEEDED will do the same thing.

[TEST_SPEED.cfg](https://github.com/AndrewEllis93/Print-Tuning-Guide/blob/main/macros/TEST_SPEED.cfg) is a great tool for testing your speed/acceleration settings. See [AndrewEllis93's Print Tuning Guide](https://github.com/AndrewEllis93/Print-Tuning-Guide/blob/main/articles/determining_max_speeds_accels.md)

I use [mech_gantry_cal.cfg](https://github.com/strayr/strayr-k-macros/blob/main/mechanical_level_tmc2209.cfg) a lot, but that only applies if you use dual z steppers and dual z drivers. This macro will bump the gantry against the z_max to straighten it against the frame and eliminate any drift between the drivers.

[HEAT_SOAK.cfg](HEAT_SOAK.cfg) heats the bed up to a configurable temperature for a configurable time in order to "heat soak" the enclosure. The trick to this macro is it uses delayed_gcode on a loop so you can do other things while it's running, including canceling it at any time.

[PUBLISH_ALERT.cfg](PUBLISH_ALERT.cfg) Sends data over MQTT. Your MQTT broker must be configured in moonraker.

[GCODE_TTS.cfg](GCODE_TTS.cfg) works with the the gcode_shell_command extension to play audio files or text-to-speech over the pi's headphone/speaker jack.

[print_area_bed_mesh.cfg](https://github.com/Turge08/print_area_bed_mesh/blob/master/print_area_bed_mesh.cfg) allows you to perform a mesh before the print, but only mesh the area of the bed that is actually being used. So a smaller model will only mesh a small part of the bed. [See the Github page for that](https://github.com/Turge08/print_area_bed_mesh)

## Marlin Functions

There's a handful of macros that cover Marlin functions that either don't exist or work differently in Klipper. None of these are necessary, and they may cause problems if you don't know what you are doing.

[M420.cfg](M420.cfg) Load bed mesh

[M900.cfg](https://marlinfw.org/docs/gcode/M900.html) Marlin linear advance command (sets pressure advance)

[M17.cfg](M17.cfg) Supports disabling individual steppers

[M204.cfg](M204.cfg) Sets acceleration values

[M205.cfg](M205.cfg) Marlin "jerk" sets square_corner_velocity

## LEDs, fans, heaters, and beepers

[stealthburner_led_effects_barf.cfg](../machine/stealthburner_led_effects_barf.cfg) and [neopixel.cfg](../machine/neopixel.cfg) in the machine folder manage the LED animations (through [the led_effect extension](https://github.com/julianschill/klipper-led_effect)) and a bunch of `STATUS` macros that set the LED effects based on the printer status.

[chamber.cfg](../machine/chamber.cfg) similarly configures some display overrides as well as containing the macros necessary to support the Marlin chamber temp commands.

[fans.cfg](../machine/fans.cfg) is just a bunch of easy-to-remember macros for controlling my fans.

[WLED.cfg](WLED.cfg) similarly is a set of macros for controlling WLED strips configured in moonraker.

[heater_overrides.cfg](heater_overrides.cfg) changes the way the `M109`/`M190` commands work so there's less waiting for it to stabilize or starting a few degrees before it reaches the target.

[M300.cfg](M300.cfg) has `M300` to control the beeper, including shifting pitch for tunes.

[tunes.cfg](tunes.cfg) This is just a collection of beeper tunes that can be used with the `M300` command and a beeper configured in Klipper.

## Stuff I wrote

### SET_MATERIAL

[SET_MATERIAL.cfg](SET_MATERIAL.cfg) is a little kit that will let you set things like z_offset or pressure advance based on the filament type chosen in the slicer.

### SET_IDLER

[SET_IDLER.cfg](SET_IDLER.cfg) is a little macro I put together to let you configure the idle_timeout time and behavior. You can choose what components are turned off by the timeout, any combination of extruder, bed, chamber, steppers, or printer power.

### ZIPPY_STATS

[ZIPPY_STATS.cfg](ZIPPYSTATS.cfg) was mostly just a fun experiment, but it's kind of cool if you like data. Home the printer and then run `GET_POSITION_STATS` to have it spit out [a crazy amount of position data](https://i.imgur.com/qq7Xb61.png).

If you are into sensorless homing, I made a pretty cool set of macros that overrides the homing code to let you customize the heck out of the homing process and do things like reduce/raise the stepper current during homing and set the homing speed/acceleration/etc, set the speed/distance of the z-hop that occurs pre-homing. Basically everything you could possible want to configure about homing is configurable. Use the [sensorless_homing_override.cfg](../extras/sensorless_homing_override.cfg) file in the extras folder.

### CONFIG_SAVER

Another one that I personally use a lot (and am kinda proud of) is my [CONFIG_SAVER.cfg](CONFIG_SAVER.cfg) project. This one is still a little rough around the edges, but I am using it on my production machine as we speak. Essentially what it does is add a macro called `SAVE_AND_RESTART`. This macro will check for a pending `SAVE_CONFIG` and if there is one it will execute it. The idea is that you don't have to remember to run `SAVE_CONFIG` after a long print to save the mesh or the z_offset, etc.

I then built in some extra features like checking the z_offset in the config and not saving if the pending value is the same as the config. I also added filters so you can save `SAVE_AND_RESTART FILTER=z_offset` and it will only save if the z_offset is pending. This way you can dump meshes if you don't want to save them and only `SAVE_CONFIG` for z_offset changes. I also added a `SAVE_AND_SHUTDOWN` option that works essentially the same way, but after restarting to `SAVE_CONFIG` it will execute a `POWEROFF` command to shutdown the printer. That way you don't have to wait for the idle_timeout to shut down after restarting to `SAVE_CONFIG`.

In short, this an automated config saver.

### Misc

[filament.cfg](../machine/filament.cfg) contains some macros for working with the filament sensor. There's a `FILAMENT_RUNOUT` command which just adds some status updates to the `M600` command. And macros to enable/disable the filament sensor and a delayed_gcode to disable the filament sensor on a timer. These make it easier to programmatically disable/enable the sensor.

[PARKING.cfg](PARKING.cfg) I love this one because it's so simple but so useful. This just is a collection of small macros that park the nozzle at various positions. All the positions are calculated use position_min and/or position_max so they will work on any printer/bed-size.

[GET_PROBE_LIMITS.cfg](GET_PROBE_LIMITS.cfg) is useful when first configuring your bed mesh settings as it gives you the probe-offset values for the min/max/current nozzle positions.

[ADXL_SHAPER.cfg](ADXL_SHAPER.cfg) runs all the resonance tuning commands for you, generates the graphs and saves the recommended shaper values to the config automatically. This requires [the gcode_shell_command extension](https://github.com/th33xitus/kiauh/blob/master/docs/gcode_shell_command.md) installable through KIAUH.

[TARGET_FAN.cfg](TARGET_FAN.cfg) is a little macro to turn on bed fans if the bed's target temperature is above a certain value. Useful if you want to circulate the heat, but only if it's set above a certain level.

[TEST_RESONANCES.cfg](TEST_RESONANCES.cfg) I don't know if this one counts, but it's a useful example if you are looking to do something similar. Essentially what it does is override the TEST_RESONANCES command to set my LEDs to the "vibrating" mode, run the normal `TEST_RESONANCES` command, and then set my LEDs back to their "idle" mode. Any parameters given to the overridden `TEST_RESONANCES` command will be passed along to the original one.
