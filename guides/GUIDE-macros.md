<!--
 Copyright (c) 2022 Chris Laprade (chris@rootiest.com)
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->
# The Macros

## Start print macro

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

## End print macro

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

## Cura Start G-Code

    M109 S0
    M190 S0
    start_print BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}

### Cura End G-Code

    end_print

Note: Cura requires the `M109 S0` and `M190 S0` lines to prevent the slicer from adding it's own M109/M190 commands automatically. This is because Cura doesn't take macros into account and will try to add commands it deems "missing" By setting them each to 0 at the start of the gcode it effectively does absolutely nothing, except to appease Cura and allow your macro to do its job.

## SuperSlicer/PrusaSlicer Start G-Code

    start_print BED_TEMP={first_layer_bed_temperature} EXTRUDER_TEMP={first_layer_temperature[initial_extruder] + extruder_temperature_offset[initial_extruder]}

## SuperSlicer/PrusaSlicer End G-Code

    end_print

Note: In most cases you could get away with using just `{first_layer_temperature}` for the extruder temp, but the one used above is a better, more inclusive option that will account for edge cases like printers with multiple extruders while also still working perfectly for more traditional builds.