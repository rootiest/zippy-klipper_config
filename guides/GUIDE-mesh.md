<!--
 Copyright (c) 2022 Chris Laprade (chris@rootiest.com)
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Bed Mesh Boundaries

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

You can use [this GET_PROBE_LIMITS macro](../macros/GET_PROBE_LIMITS.cfg) to find the physical minimum and maximum probe coordinates as well as the current probe coordinates. 

This can be helpful if you'd like to avoid doing the math yourself as it will display the range of possible values that can be successfully used for `mesh_min` and `mesh_max`.

To use this macro, download the `GET_PROBE_LIMITS.cfg` file to your `~/klipper_config` directory and add the following near the top of your `printer.cfg` file: 

    [include GET_PROBE_LIMITS.cfg]

Credit to [u/davidosmithII](https://www.reddit.com/user/davidosmithII/) who came up with the idea and created the original macro to do it.

## References

[Bed Mesh](https://www.klipper3d.org/Bed_Mesh.html)

[Config Reference](https://www.klipper3d.org/Config_Reference.html#bed_mesh)