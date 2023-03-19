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



# Bed Mesh Boundaries

- [Bed Mesh Boundaries](#bed-mesh-boundaries)
  - [Prerequisites](#prerequisites)
  - [Configuring mesh boundaries](#configuring-mesh-boundaries)
    - [Sample values:](#sample-values)
    - [The Math](#the-math)
  - [Probe Limits Macro](#probe-limits-macro)
  - [Leveling Assistance](#leveling-assistance)
  - [References](#references)

This guide outlines how to configure the boundaries for your bed meshes. This will help you prevent out-of-range errors and other issues like probing off the edge of the bed during meshes.

## Prerequisites

You should first complete these two guides:

[Axis Limits](GUIDE-axis_limits.md): Find the travel/print boundaries for your machine

[Probe Offsets](GUIDE-probe.md): Calibrate your probe offsets for X,Y,Z

## Configuring mesh boundaries

The `mesh_min` and `mesh_max` configuration frequently trips people up.

These values need to be ***PROBE*** coordinates, not ***nozzle*** coordinates.

However, the Klipper backend does not offset these values automatically for you.

We need to manually apply the offsets to the mesh boundaries.

The simplest way to explain this is to use an example. So I will include a snippet of example config values so we can demonstrate the math.

### Sample values:

    [stepper_x]
    position_min: -5
    position_endstop: -5
    position_max: 250

    [stepper_y]
    position_min: -5
    position_endstop: -5
    position_max: 200

    [bltouch]
    x_offset: -50
    y_offset: -10

In this example, our mesh_min and mesh_max values would be:

    [bed_mesh]
    mesh_min: 0, 0
    mesh_max: 199, 189

### The Math

Typically the probe is mounted to the left of the nozzle. That will result in the larger offset (X) being a negative value. In my experience the Y value usually is as well, but in any case it's less of a concern due to its smaller offset.

`mesh_min` is simple, we can use `0,0` (the front-left corner) or bump it in a little to something like `10,10` (if we don't want to be that close to the edge)

`mesh_max` has to account for the range the ***probe*** can travel to. This will be less than your `position_max` and it's common for it to even be less than your bed size.

In my example above the probe's `x_offset` is `-50`

The `stepper_x` `position_max` is `250`

That means the absolute maximum point the probe can move to is `200` (250 - 50). We use `199` (200 - 1) to be safe.

`199` is the furthest point that can be used for `mesh_max.x`

Our probe's `y_offset` is  `-10`

The `stepper_y` `position_max` is `200`

That means the absolute maximum point the probe can move to is `190` (250 - 10). We use `189` (190 - 1) to be safe.

So in this example, our `mesh_max` has to be `199, 189` or less.

If you do not do this correctly your `BED_MESH_CALIBRATE` command will fail with a move-out-of-range error.

If that happens, make note of the invalid coordinates in the error message. These will provide a clue for the source of the problem. 

It will likely be one of your axis moving beyond the `max_position`.

In that case, you'll need to revisit your `mesh_max` configuration for that axis and correct the error.

If the error shows a move to negative coordinates and/or the failure occurs on the left/front side of the bed, then you will need to correct your `mesh_min` configuration to account for the offset that was moving you beyond the physical limits.

## Probe Limits Macro

You can use [this GET_PROBE_LIMITS macro](resources/GET_PROBE_LIMITS.cfg) to find the physical minimum and maximum probe coordinates as well as the current probe coordinates. 

This can be helpful if you'd like to avoid doing the math yourself as it will display the range of possible values that can be successfully used for `mesh_min` and `mesh_max`.

To use this macro, download the `GET_PROBE_LIMITS.cfg` file to your `~/printer_data/config` directory and add the following near the top of your `printer.cfg` file: 

    [include GET_PROBE_LIMITS.cfg]

Credit to [u/davidosmithII](https://www.reddit.com/user/davidosmithII/) who came up with the idea and created the original macro to do it.

> Nows supports the beacon probe as well. (Thanks [DrFate09](https://github.com/DrFate09))

## Leveling Assistance

When you have a probe, you can also use it to help you level your bed.

This is performed using the [SCREWS_TILT_CALCULATE command](https://www.klipper3d.org/G-Codes.html#screws_tilt_calculate).

In order to use this, we need to set up a `screws_tilt_adjust` section in the config.

Here is an example:

    # Bed screw adjustment
    [screws_tilt_adjust]
    screw1: 83,43
    screw1_name: front left screw
    screw2: 250,43
    screw2_name: front right screw
    screw3: 250,210
    screw3_name: rear right screw
    screw4: 83,210
    screw4_name: rear left screw
    screw_thread: CW-M4

The `screw_thread` is the threading used on your bed-adjustment screws. Typical Ender 3 style beds use M4 threading and turn clockwise to decrease the bed height. M3-clockwise is also somewhat common.

If you are unsure, you can check your bed screws to verify the correct threading for your config.

The `screw_name`'s can be anything you'd like. They are just for your own reference (and some UI stuff) There is no rules to how you may name them.

The number/order of the screws *does* matter however. Note the names I used for mine, your screws will also be referenced in that order so you should label yours accordingly (or at least use the correct coordinates) They are listed in a counter-clockwise order starting from the front-left.

The final step is finding the coordinates to use for each screw.

This process should be familiar if you followed my [previous guides](GUIDE-axis_limits.md):

- Start Klipper and home the printer.
- Using your display controls/web interface or `G1` commands, move the printhead until the probe pin is positioned above the front-left bed screw.
- Note the X,Y coordinates either using your display/web interface or by executing the `GET_POSITION` command and checking the values for `toolhead`
- Repeat for the other bed screws until you have coordinates for all of them. 
- If your printer does not have enough physical range to position the probe over a bed scew, just position it as close as possible and use those coordinates.

You will then use those coordinates in your `screws_tilt_adjust` config for the `screw` positions.

That's it for the configuration!

When you run `SCREWS_TILT_CALCULATE` it will probe all the bed screws and then tell you how much to adjust each to achieve level. 

Keep in mind that even with a perfectly configured setup, adjusting one screw will cause some deviation in the others.

You will need to repeat this process several times. I recommend repeating until you are able to probe all screws twice without needing to make any adjustments.

## References

[Bed Mesh](https://www.klipper3d.org/Bed_Mesh.html)

[Config Reference](https://www.klipper3d.org/Config_Reference.html#bed_mesh)