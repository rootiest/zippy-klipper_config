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

# My Notes (DELETE THIS)

why do you want to prevent it from running through the console?

On Mainsail and KlipperScreen (not Fluidd) you can hide macros (and other components) from showing in the interface by putting an underscore at the front of the name:
[gcode_macro _CUSTOM_LIGHT]

This also works for fans, temperature sensors, etc as well:
[temperature_sensor _host]

To my knowledge there's no way to prevent macros from running through the console though.
Depending on why you want to do this, maybe adding a required parameter or something could work?

    [gcode_macro CUSTOM_LIGHT]
    gcode:
        {% set ALLOWED = params.ALLOWED|default(0)|int %}
        {% if ALOWED == 1 %}
            SET_PIN PIN=ledblue VALUE=0.5
            SET_PIN PIN=ledgreen VALUE=0.5
            SET_PIN PIN=ledred VALUE=0.5
        {% endif %}

This will only run like this: CUSTOM_LIGHT ALLOWED=1
Use that parameter when calling it from your other macros, and then if you ever accidentally run CUSTOM_LIGHT from the console, it will do nothing. 
Recoil — Today at 1:34 AM
I am creating a custom startup macro that gets called with the slicer.  I have that code broken down into other gcode sections for clarity and easier editing.

For instance, my nozzle wipe section is broken out and called within the custom startup macro, but needs the nozzle to be heated to ensure its not wiping cold filament wearing out the brush and damaging the nozzle.  So it's called after the warmup gcode.

In order I have my full custom startup macro broken down into Warmup/Level/Cleaning/Priming.  Warmup passes through temps that have a default value of 60/180 respectively, while Cleaning passes through the first layer temps.

Hiding them in Mainsail works (for when my wife see's something and wonder's what does it do).  I did just stumble across this though (https://github.com/Klipper3d/klipper/issues/2157) for calling a variable from another macro, so essentially I could use that to ensure the first layer temps were reached before doing the Cleaning macro.
rootiest — Today at 1:41 AM
You can also use GCODE_VARIABLES or just params to pass values between macros.
https://www.klipper3d.org/Command_Templates.html#variables

As far as ensuring the nozzle is up to temp, why not just test that with an if statement?

Stick your wipe line commands inside an if statement like this:

    {% if printer.toolhead.homed_axes != "xyz" %}
        {action_respond_info("Please home XYZ first")}
    {% elif printer.extruder.can_extrude != True %}
        {action_respond_info("Extruder temperature too low")}
    {% else %}
        # Do your wipe line stuff here
    {% endif %}

printer.extruder.can_extrude is defined by the min_extrude_temp setting in your [extruder] section

If you want to pass a value to this macro, the simplest way is by using params.
Assuming you are calling this macro (let's assume it's named WIPE_LINE) from a previous macro, you can use something like this:

    {% set TARGET = params.TARGET|default(printer.extruder.min_extrude_temp) %}
    {% set TEMP = printer.extruder.temperature %}
    {% if printer.toolhead.homed_axes != "xyz" %}
        {action_respond_info("Please home XYZ first")}
    {% elif TEMP < TARGET %}
        {action_respond_info("Extruder temperature too low")}
    {% else %}
        # Do your wipe line stuff here
    {% endif %}

Then just pass the TARGET to the macro using WIPE_LINE TARGET=200 or whatever your target is.
Or if you want to pass a variable: WIPE_LINE TARGET={MY_VARIABLE} 
rootiest — Today at 1:50 AM
I could give you a quick writeup of using gcode_variables, but I would recommend using params instead unless the subsequent macro (WIPE_LINE) is not being executed directly by the previous macro (CLEANING?)
Recoil — Today at 1:57 AM
I do have it requiring params in the initial macro:

    [gcode_macro PRINT_START400]
    description: "Troodon400 Print Start Script #Use PRINT_START400 for the slicer starting script
    gcode:
        {% set bed_warmup_temp = params.BED_WARMUP_TEMP|default(60)|int %}
        {% set nozzle_warmup_temp = params.NOZZLE_WARMUP_TEMP|default(180)|int %}
        {% if not params.BED_PRINTING_TEMP %}
                {action_respond_info("Missing BED_PRINTING_TEMP parameter")}
        {% endif %}
        {% set bed_printing_temp = params.BED_PRINTING_TEMP %}
        {% if not params.NOZZLE_PRINTING_TEMP %}
                {action_respond_info("Missing NOZZLE_PRINTING_TEMP parameter")}
        {% endif %}
        {% set nozzle_printing_temp = params.NOZZLE_PRINTING_TEMP %}
        G90                                          ; set absolute positioning
        _START_WARMUP BWT={bed_warmup_temp} NWT={nozzle_warmup_temp}
        _START_LEVEL
        _START_CLEANING BPT={bed_printing_temp} NPT={nozzle_printing_temp}
        _START_PRIMING
        _LIGHTS_PRINTING

Currently that is working, along with the other macros.  Breaking it down into so many sections is probably a bit much.  I may put this in it's own config file to separate it with comments to clarify things better.
rootiest — Today at 2:02 AM
Here's an example using gcode_variables:

    [gcode_macro CLEANING]
    variable_wipe_target: 0
    gcode:
        # Cleaning stuff
        {% set WIPE_TARGET = 220 %} # just an example
        SET_GCODE_VARIABLE MACRO=CLEANING VARIABLE=wipe_target VALUE={WIPE_TARGET}
        WIPE_LINE

    [gcode_macro WIPE_LINE]
    gcode:
        {% set TARGET = printer["gcode_macro CLEANING"].wipe_target %}
        {% set TEMP = printer.extruder.temperature %}
        {% if printer.toolhead.homed_axes != "xyz" %}
            {action_respond_info("Please home XYZ first")}
        {% elif TEMP < TARGET %}
            {action_respond_info("Extruder temperature too low")}
        {% else %}
            # Do your wipe line stuff here
        {% endif %}
        
But in this example situation, it's better to just use params because we are calling WIPE_LINE right from the macro whose variable we want anyway