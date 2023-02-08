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


# The Macros

- [The Macros](#the-macros)
  - [START\_PRINT Macro](#start_print-macro)
  - [END\_PRINT Macro](#end_print-macro)
- [Slicer Settings](#slicer-settings)
  - [Cura Start G-Code](#cura-start-g-code)
  - [PrusaSlicer Start G-Code](#prusaslicer-start-g-code)
  - [SuperSlicer Start G-Code](#superslicer-start-g-code)
  - [SuperSlicer/PrusaSlicer/Cura End G-Code](#superslicerprusaslicercura-end-g-code)
    - [Update:](#update)
    - [Advanced SuperSlicer Start G-code](#advanced-superslicer-start-g-code)
  - [Why use macros?](#why-use-macros)
  - [Passing Other Parameters](#passing-other-parameters)
  - [Additional Notes](#additional-notes)


These are example macros you can use with your slicer to let Klipper manage the start and end procedures.

You can just paste these macros into your `printer.cfg` file.

## START_PRINT Macro

    [gcode_macro START_PRINT]
    gcode:
        {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
        {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(190)|float %}
        # Start bed heating (but don't wait for it)
        M140 S{BED_TEMP}
        # Use absolute coordinates
        G90
        # Reset the G-Code Z offset (adjust Z offset if needed)
        SET_GCODE_OFFSET Z=0.0
        # Home the printer
        G28
        # Move the nozzle near the bed
        G1 Z5 F3000
        # Move the nozzle very close to the bed
        G1 Z0.15 F300
        # Wait for bed to reach temperature
        M190 S{BED_TEMP}
        # Set and wait for nozzle to reach temperature
        M109 S{EXTRUDER_TEMP}

## END_PRINT Macro

    [gcode_macro END_PRINT]
    gcode:
        # Turn off bed, extruder, and fan
        M140 S0
        M104 S0
        M106 S0
        # Move nozzle away from print while retracting
        G91
        G1 X-2 Y-2 E-3 F300
        # Raise nozzle by 10mm
        G1 Z10 F3000
        G90
        # Disable steppers
        M84

These are just the sample start_print and end_print macros copied directly from [the official docs](https://github.com/Klipper3d/klipper/blob/master/config/sample-macros.cfg). I did not change anything and take no credit for these (fairly basic) macros!

# Slicer Settings

These code snippets should be entered in your slicer settings. You should *replace* any existing code in those settings fields with the following.

## Cura Start G-Code

    ; M190 S{material_bed_temperature_layer_0}
    ; M109 S{material_print_temperature_layer_0}
    start_print BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}

> Note: Cura requires the "dummy" preheat lines to prevent the slicer from adding it's own M109/M190 commands automatically. This is because Cura doesn't take macros into account and will try to add commands it deems "missing" By providing these dummy commands at the start of the gcode it effectively does absolutely nothing, except to appease Cura and allow your macro to do its job.

> Note: The start gcode for Cura has been updated to address a change in the way Cura processes it. Versions newer than 5.0 may try to insert their own M109/M190 commands without this updated format.

## PrusaSlicer Start G-Code

    M109 S0
    M190 S0
    start_print EXTRUDER_TEMP={first_layer_temperature[initial_extruder]} BED_TEMP={first_layer_bed_temperature[initial_extruder]} CHAMBER_TEMP={chamber_temperature}

> Note: PrusaSlicer recently changed their placeholder/variable formatting. The above applies to PrusaSlicer 2.5.0. For previous versions the SuperSlicer example below should be compatible.

## SuperSlicer Start G-Code

    M109 S0
    M190 S0
    start_print BED_TEMP={first_layer_bed_temperature} EXTRUDER_TEMP={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]} CHAMBER_TEMP={chamber_temperature}

> Note: In most cases you could get away with using just `{first_layer_temperature}` for the extruder temp, but the one used above is a better, more inclusive option that will account for edge cases like printers with multiple extruders while also still working perfectly for more traditional builds.

Additionally, the PrusaSlicer format shown in the above section is also compatible with SuperSlicer. Or they can be combined to cover every possible build scenario:

    M109 S0
    M190 S0
    start_print BED_TEMP={first_layer_bed_temperature[initial_extruder]} EXTRUDER_TEMP={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]} CHAMBER_TEMP={chamber_temperature}

As SuperSlicer supports Klipper directly, you can get even more control using the format in the [Advanced SuperSlicer Start G-code section](#advanced-superslicer-start-g-code) below.
## SuperSlicer/PrusaSlicer/Cura End G-Code

    end_print

> Note: This code is the same for all Slicers. We just need to call the `END_PRINT` macro, there's no need to pass any values to it.

### Update:

I am now including the `M109`/`M190` dummy commands in the SuperSlicer/PrusaSlicer Start Gcode. PrusaSlicer appears to need them for the same reasons as Cura.

SuperSlicer *shouldn't* when selecting `Klipper` for the G-code Flavor. However, on the latest version the merge with the PrusaSlicer source overwrote this check and it behaves the same way as the others. This has been [confirmed fixed for the next SuperSlicer release](https://github.com/supermerill/SuperSlicer/issues/875) and I will update the guide when that changes.

It's also worth noting this shouldn't be a serious concern in most cases. At most, allowing the Slicer to automatically add those commands after the macro may just cause a slight hesitation/lag immediately before the print begins. 

However, if you wish to do something like offset temperature values using code in your macro, you may have an issue without the dummy commands because the Slicer will set them back at the start of the first layer.

### Advanced SuperSlicer Start G-code

SuperSlicer (when configured for Klipper flavor) has the option to completely disable any automatic gcode insertion for things like the start gcode. You can use this to get around the need to add additional "dummy" commands.

This is achieved by going to the custom gcode settings and checking the box for "Only custom Start G-Code"

It's important to note that when using this option, the slicer will not add ***any*** of the automatic start g-code commands that are normally used. This goes beyond just simple temperature settings.

I compared generated gcode files with and without this box selected and aside from preheat temperatures (which should already be handled by your macro) SuperSlicer also added the following commands:

    M107 ; disable fan
    G21 ; set units to millimeters
    G90 ; use absolute coordinates
    M82 ; use absolute distances for extrusion
    G92 E0 ; reset extrusion distance

If using this option, I would recommend adding those commands to your `START_PRINT` macro so that you do not run into any issues.

With those added in your `START_PRINT` macro, your start gcode in SuperSlicer could simply be the following:

    start_print BED_TEMP={first_layer_bed_temperature} EXTRUDER_TEMP={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]} CHAMBER_TEMP={chamber_temperature}

While more advanced, this feature gives you far more control over the behavior of your prints (or at least the pre-print behavior).

If you are using SuperSlicer and comfortable with adding the additional commands to your macro then I would recommend using this feature for more granular control over your prints.

## Why use macros?

There are many benefits to using a start_print macro!

Because the actual code in the slicer will consist of only a call to the macro, it allows you to change the start procedure without reslicing the model.

For example: Let's say you add a bltouch to your printer and you would like to perform a `BED_MESH_CALIBRATE` during your pre-print procedure. You can add that command to your macro and it will be used by all your gcode files, even older ones that were sliced before this change.

You could even use .gcode files on multiple printers with different start requirements so long as each printer has a start_print macro and doesn't have other differences such as temperature or bed size constraints.

It's actually possible to account for those factors as well if you really want to.

Which brings us to the final benefit I'm going to mention: 

Macros can use more complex logic that doesn't exist in basic gcode commands that can be used in the slicer start gcode. Using a scripting language called Jinja2, we can perform logic tests in macros (if statements, variables, etc)

Here's a really basic example:

    {% set NOZZLE = printer.extruder.nozzle_diameter|default(0.4)|float %}
    {% if NOZZLE > 0.4 %}
        M220 S75
    {% else %}
        M220 S100
    {% endif %}

This is not a Jinja2 guide, so I will just briefly explain what this does:

The first line gets the nozzle diameter from Klipper using [the Status Reference function described here](https://www.klipper3d.org/Status_Reference.html#toolhead). 

It also assigns a default in case it's unable to retrieve that value (unlikely)

Then we test whether the value is greater than 0.4mm.

If it is we set the printing speed to 75%.

Otherwise, we set it to 100%.

This is just a very basic example, Jinja2 allows us to basically write mini-programs that make our macros behave dynamically.

The [Status Reference](https://www.klipper3d.org/Status_Reference.html) functionality in Klipper allows us to retrieve basically ***any*** value the printer can access. 

You can even read values directly from the config file, or check whether a `SAVE_CONFIG` is necessary and what items are queued to be saved.

It's pretty powerful stuff, and macros are absolutely worth using!

## Passing Other Parameters

You can pass all sorts of values from the slicer to your macros if you want to get other information into Klipper such as the material/filament type, the nozzle diameter, etc.

Check out [my SET_MATERIAL and SET_NOZZLE macros](../extras/SET_MATERIAL.cfg) for an example of using other slicer values in your macros.

In Cura we call those using:

    SET_MATERIAL MATERIAL='{material_type}'

In PrusaSlicer/SuperSlicer:

    SET_MATERIAL MATERIAL='{filament_type[initial_extruder]}'

Then in the macro the variable is assigned just like we do in the `START_PRINT` macro:

    {% set MATERIAL = params.MATERIAL|default('PLA')|string %}

So how do we find those varible names?

In PrusaSlicer/SuperSlicer it's simple: just hover your mouse cursor over a settings field and the tooltip will show something like this:

    parameter name: wall_thickness

In this above example, the variable we'd use is `wall_thickness`

Cura is less direct. 

I've found [this page](https://files.fieldofview.com/cura/Replacement_Patterns.html) to be fairly accurate and complete.

[There's also a good list for SuperSlicer here.](https://github.com/supermerill/SuperSlicer/wiki/Macro-&-Variable-list)

Typically I prefer to address these additional parameters using a separate/specific macro like the `SET_MATERIAL` one in my example above.

However, you can add them on to the end of your `START_PRINT` command and use them inside that macro if you prefer.

For example, in Cura you might use:

    start_print BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0} MATERIAL='{material_type}'

and then add this inside your `START_PRINT` macro:

    {% set MATERIAL = params.MATERIAL|default('PLA')|string %}

You could even work with gcode variables directly using a `SET_GCODE_VARIABLE` command.

Check out my [Advanced Macro Techniques](GUIDE-variables.md) guide for more information on that kind of thing.

## Additional Notes

In the start gcodes above for PrusaSlicer and SuperSlicer I included a `CHAMBER_TEMP` parameter. This allows you to pass the chamber temperature configured in those slicers to your macro.

Cura does not have an option for this that I could find.

The sample `START_PRINT` macro included does not make use of that parameter. Your macro may or may not. You may not have a chamber heater.

All of that is ok, even with that parameter included. If your `START_PRINT` macro doesn't use the parameter, it will just be ignored.

I decided it was worth including this in my guide despite many users not needing it, and it not being included in the same `START_PRINT` macro because it doesn't hurt to have it and not use it.

It also serves as an additional example of a parameter.

If you *are* interested in using it in your macro, simply include something like this in your macro:

    {% set CHAMBER_TEMP = params.CHAMBER_TEMP|default(50)|float %}

and then use it in a command like this:

    SET_HEATER_TEMPERATURE HEATER=chamber_heater TARGET={CHAMBER_TEMP}

And again, if you don't need this or use it, the start gcode will still work perfectly with that parameter whether you use it or not.