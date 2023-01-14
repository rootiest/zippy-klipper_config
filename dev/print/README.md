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

# Print Management Macros

These macros manage behavior for starting, ending, and canceling prints.

They also support layer-specific triggers.

The purpose of these macros should be familiar to anyone who has used a `START_PRINT` or similar macro in Klipper before.

The method by which we achieve that result is somewhat different however.

## Contents

- [Print Management Macros](#print-management-macros)
  - [Contents](#contents)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Using](#using)
    - [How it works](#how-it-works)
  - [Macros](#macros)
    - [START\_PRINT Macro](#start_print-macro)
      - [Breakdown the purpose of individual parts:](#breakdown-the-purpose-of-individual-parts)
    - [END\_PRINT Macro](#end_print-macro)
    - [CANCEL\_PRINT Macro](#cancel_print-macro)
    - [Working with Layers](#working-with-layers)
    - [Filament Changes](#filament-changes)
    - [Nozzle Cleaning](#nozzle-cleaning)
    - [Adaptive Mesh and Purge](#adaptive-mesh-and-purge)
    - [Idler](#idler)
    - [Parking and Homing](#parking-and-homing)
  
## Installation

> Describe steps to install macros onto Klipper
## Configuration

Get ready to see a lot of `SET_GCODE_VARIABLE`!

Unlike the common `START_PRINT` macro format, we aren't using a set of parameters to pass information from the slicer.

Instead we will use the `SET_GCODE_VARIABLE` commands to pass variables from the slicer and our macros will reference those.

Configuration of these macros will consist of adjusting some default values and adding some code to the slicer's custom gcode fields.

## Using

Using these macros will require adding/changing some gcode in the slicer's custom gcode sections as well as configuring the default values for several variables.

### How it works

These macros use gcode variables extensively, allowing for easy and deep configuration of all parts of the macro's behavior.

Most of these variables will be, or will need to be, configured to default values that won't need to change once set.

The rest will be set by the slicer and represent values that we traditionally would have used parameters for.

> NOTES: 
> 
> Using parameters the traditional way is also still supported for some basic functions. However, parameters are no longer *required*.
>
> Although most variables won't *need* to be configured after the initial configuration, they all still *can* be set to new values at any time, even during the print!

Here is an example of the type of thing we are looking to avoid:

This is a SuperSlicer `START_PRINT` call for a fairly complex printer build:

    start_print EXTRUDER={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]} BED={first_layer_bed_temperature[initial_extruder]} CHAMBER={chamber_temperature} MATERIAL={filament_type} COUNT={total_layer_count} TOOLS={total_toolchanges} FILTER=1 PRINT_MIN={first_layer_print_min[0]},{first_layer_print_min[1]} PRINT_MAX={first_layer_print_max[0]},{first_layer_print_max[1]} COLOUR={filament_colour}

This is all one line!

On the one hand, it's great to get all of that data from the slicer into Klipper. But this many parameters starts to become very messy and unwieldy.

Here is how the above example would work in this new format:

    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=extruder_temp VALUE={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=bed_temp VALUE={first_layer_bed_temperature[initial_extruder]}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=chamber_temp VALUE={chamber_temperature}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=material_type VALUE={filament_type}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=material_color VALUE={filament_colour}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=layer_count VALUE={total_layer_count}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=tool_count VALUE={total_toolchanges}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=nevermore VALUE=True
    START_PRINT

This may not seem a lot simpler, but it allows us to bring as much or as little information in from the slicer without needing to worry about fitting each parameter in to one big line.

A simpler/more common example might be:

This old `START_PRINT` call:

    start_print BED_TEMP={first_layer_bed_temperature} EXTRUDER_TEMP={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]}

and in the new format:

    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=extruder_temp VALUE={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]}
    SET_GCODE_VARIABLE MACRO=_printcfg VARIABLE=bed_temp VALUE={first_layer_bed_temperature[initial_extruder]}
    START_PRINT

As you can see, there is some minor improvements in readability. The real benefits are below the surface however.

Most users will be able to just use a default set of `SET_GCODE_VARIABLE` commands to match their slicer, and any values unique to your machine can be set in the configuration.

However, this also opens the door for changing any of the values at any time using a simple `SET_GCODE_VARIABLE` command that can even be run manually from the console!

## Macros
### START_PRINT Macro

> Describe macro features and steps to use

#### Breakdown the purpose of individual parts:

> HEAT_SURFACE
> 
> PREP_CHAMBER: Will include optional heat-soak process
> 
> PREP_FANS
> 
> PREP_SURFACE
> 
> PREP_EXTRUDER

### END_PRINT Macro

> Describe macro features and steps to use
### CANCEL_PRINT Macro

> Describe macro features and steps to use
### Working with Layers

> Describe how these macros are able to work with layers

### Filament Changes

> Describe how these macros perform filament changes and address runouts

### Nozzle Cleaning

> Describe how the nozzle brush macro works

### Adaptive Mesh and Purge

> We are using a modified version of [this project](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging)

### Idler

> The Idler macros allow changing the idle_timeout behavior as well as time, even during a print.

### Parking and Homing

> Allow parking and homing to use our configuration variables

