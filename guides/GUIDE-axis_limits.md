<!--
 Copyright (c) 2022 Chris Laprade (chris@rootiest.com)
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Warning: This is just a copy-pasted comment for the moment, but it should still be a reasonably effective guide for most cartesian-style printers

The purpose of the stepper min_position and max_position is to establish the maximum physical range for each axis, not just the bed size on paper.

It shouldn't be your bed size, particularly on the X-axis where you should be able to travel well beyond the range of your bed.

Rather than just guessing at it, there is a way to calibrate this to the correct values.

To begin, you want to make sure your 0,0 position is the front-left corner of your bed/printable area exactly. 
This will likely mean your endstop positions have negative values.

To do this, home your printer and then use the Mainsail/Fluidd interface controls to manually move the nozzle directly above the front-left corner. Make note of the coordinates it shows.

If they are not 0,0 you will need to adjust the position_endstop and position_min values (they should be the same)

For example, if your position_min/position_endstop for the X-axis is -5 and the front-left corner is registering as 5,0 then you need to correct your position_min/position_endstop to be -10.

Do the same calculation for the Y-axis.

Change these values in your config and then do a FIRMWARE_RESTART

Verify that your front-left corner of the bed is now 0,0.

This is necessary to find the correct values for position_max.

Once your 0,0 is correct, set your position_max for each axis to a value much higher than you know is possible, for your Ender 3 try 300 for each position_max.

Don't worry, this is temporary. Save the config and restart.

Now home the printer again and use the mainsail interface to manually move the nozzle slowly like 1mm or less as you start to get close to the limit. Do this slowly in very small increments!

We are doing it carefully for 2 reasons:
First to not damage the printer, and second because once it skips/grinds the coordinate values are no longer accurate. 

So you want to find the coordinates where it first hits the physical limit (grinds/skips) and subtract 1mm. Do this for each axis.

Change your position_max to those coordinates and restart.

Repeat the process, slowly again, to verify that the printer now stops before hitting the limit.

Now you should have your physical range configured.

But what about the bed size? Obviously we can't print within that entire range, just where the bed is.

Well we've already correctly established the first half by setting the front-left of the bed to 0,0.

The second half is finding the position of the back-right corner.

You don't want to just depend on the specs, you want the exact values according to your machine itself because that's what matters here, not the specs.

So all you need to do is move the nozzle to the back-right corner of the bed and note those coordinates.

That's what you put in your slicer for the bed size.

If you want, you can then set the z_stepper max_position to something excessively high, and then move the z-axis slowly to its physical maximum and change it's pos_max to that value. You can also configure that in your slicer as the max height.

And you're done!

Now your printer is properly configured to be able to utilize it's full physical range while also confining the printing area to the size of the bed.