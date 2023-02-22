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

# Finding the axis limits


- [Finding the axis limits](#finding-the-axis-limits)
  - [Calibrating 0,0 and position\_min](#calibrating-00-and-position_min)
    - [Notes](#notes)
    - [Calibration steps](#calibration-steps)
  - [Finding position\_max](#finding-position_max)
    - [Notes](#notes-1)
    - [Calibration steps](#calibration-steps-1)
  - [What about Bed Size](#what-about-bed-size)
    - [Configure the Slicer](#configure-the-slicer)
  - [You did it!](#you-did-it)


The purpose of the stepper `position_min` and `position_max` is to establish the maximum ***physical*** range for each axis, not just the bed size on paper.

These values shouldn't represent your bed size, particularly on the X-axis where you should be able to travel well beyond the range of your bed on a typical Ender-style printer.

At the same time, you don't want the printer to try to travel *further* than it's physically able to, as that will cause grinding, layer shifting, and inaccurate coordinates.

## Calibrating 0,0 and position_min

### Notes

You want to make sure your 0,0 position is the **front-left corner of your bed/printable area** exactly.

This will likely mean your endstop positions have negative values. That's normal.

In almost all cases the `position_endstop` and `position_min` values will be the same. 

Unless your endstops are at the max positions in which case the `position_endstop` and `position_max` will be the same.

As the printer cannot move beyond the endstops, those mark the minimum (or maximum) positions.

If your chosen web interface does not display the current position, you can use the following terminal command: `GET_POSITION`

This will return several lines of position data.

For our purposes we can use the values on the "toolhead" line to represent our **current coordinates**.

Ex:

    Recv: // toolhead: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000

### Calibration steps

Home your printer and then use the Mainsail/Fluidd interface controls to manually move the nozzle directly above the front-left corner. Make note of the coordinates it shows.

If they are ***not*** `0,0` you will need to adjust the `position_endstop` and `position_min` values to make it so.

For example: if your `position_min`/`position_endstop` for the X-axis is -5 and the front-left corner is registering as 5,0 then you need to correct your `position_min`/`position_endstop` to be -10.

Do the same calculation for the Y-axis.

Change these values in your config and then do a `FIRMWARE_RESTART`

Return the nozzle to the front-left corner and verify that the coordinates are now `0,0`.

This step is necessary to find the correct values for `position_max`. If you do not properly calibrate your `0,0` and `position_min` then your `position_max` values will be incorrect.

## Finding position_max

### Notes

Remember to calibrate the `position_min` and `0,0` as described above *before* beginning this step.
### Calibration steps

Once your `0,0` is correct, set your `position_max` for each axis to a value much higher than you know is possible, for an Ender 3 try 300 for each `position_max`. If your printer has a larger bed, use a suitably large number that would allow for moves far beyond the limits of your machine.

Don't worry, this is temporary and we are going to be careful for the short time we have those unreasonable values. 

Save the config and `FIRMWARE_RESTART`.

Home the printer and use the Mainsail/Fluidd interface to manually move the nozzle ***very slowly*** (like 1mm or less) as you start to get close to the limit. Do this slowly in very small increments!

We are doing it carefully for 2 reasons:

1. To not damage the printer
2. Because once it skips/grinds the coordinate values are no longer accurate and you will have to restart and retry.

You want to find the coordinates where it first hits the physical limit (grinds/skips) and subtract 1mm. 

Do this for each axis.

Change your `position_max` values to those coordinates and restart.

Repeat the process, ***very slowly*** again, to verify that the printer now stops before hitting the limit.

If you still hear/feel grinding or other indications of the printer trying to move beyond its limits, you will need to restart and retry the steps again. Reduce the limits until you no longer observe any physical contact with the limits.

Then update your `position_max` values again if necessary and restart.

Your physical range should now be properly configured. Test it by moving with the interface controls and ensure that you can move from one end to the other of each axis without any physical contact or slipping/skipping.

## What about Bed Size

But what about the bed size? 

Obviously we can't print within that entire physical range we just established. We only want to be able to **print** where the bed is.

We've already correctly established the first half by setting the front-left of the bed to 0,0.

The second half is finding the position of the back-right corner.

> IMPORTANT: You don't want to just depend on the specs, you want the exact values according to your machine itself because that's what matters here, not the specs. 
>
> The printer doesn't care what the manufacturer claims, and there's a lot of factors which can reduce/change our travel/printing boundaries. 
>
>We want to calibrate for ***your*** machine no matter what its range is, or is supposed to be.

### Configure the Slicer

Move the nozzle to the back-right corner of the bed and note those coordinates.

Put those values in your slicer for the `bed size`.

> NOTE: Make sure you have `Origin at center` unchecked/disabled. The origin should be 0,0 or the front-left of the bed as we established earlier. This is especially relevant for Cura users.

Set the `stepper_z` `position_max` to something excessively high (like we did for the other `position_max` calibrations)

Save the config and `FIRMWARE_RESTART`

Home the printer and then move the z-axis slowly to its physical maximum.

This also requires caution, you may or may not physically contact anything, but there's still a maximum range for your Z axis and you want to set it accurately.

Note the Z coordinates at that position and assign that value to your `stepper_z` `position_max`. This will establish your maximum travel height.

You can also enter that value in your Slicer settings as the maximum height so that the slicer will not generate prints outside of your printer's physical limits.

## You did it!

And you're done!

Now your printer is properly configured to be able to utilize it's full physical range while also confining the printing area to the size of the bed.
