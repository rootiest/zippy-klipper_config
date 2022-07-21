<!--
 Copyright (c) 2022 Chris Laprade (chris@rootiest.com)
 
 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Warning: This is just some copy-pasted comments for the moment, it needs to be cleaned up and organized and more detail added.

Read The Docs:

[Klipper Config Reference](https://www.klipper3d.org/Config_Reference.html#bltouch)

[BL-Touch](https://www.klipper3d.org/Config_Reference.html#bltouch)

I'm not sure what board your printer uses but if it's the stock Creality 4.2.2 or 4.2.7, the following will work:

    [bltouch] sensor_pin: PB1
    control_pin: ^PB0
    x_offset: 0                  # Change to fit your printer
    y_offset: 0                  # Change to fit your printer
    z_offset: 2.295              # Change to fit your printer
    probe_with_touch_mode: True
    stow_on_each_sample: False   # Keep the probe extended between points
    samples: 2                   # Probe each point at least twice
    samples_tolerance: 0.0125    # If those measurements aren't this close then
    samples_tolerance_retries: 5 # Re-probe this many times and use the average

I have that same board and a CRtouch so this is taken directly from my config.

Note that my sample tolerance is quite low so it frequently will probe a point several times and use the average. You can change the samples and tolerance settings to fit your needs.

You ***will*** need to change the x and y offsets to be accurate for your probe's position relative to the nozzle. Follow [the directions in the docs](https://www.klipper3d.org/Probe_Calibrate.html) to measure those values. Then you will also need to calibrate the z-offset. (Again, follow [the docs](https://www.klipper3d.org/Probe_Calibrate.html#calibrating-probe-z-offset))

Run the `PROBE` command. Mark the point on the bed where the probe pin touched using whatever method works for you.

Use tape, your memory, a sharpie, it doesn't matter. Whatever works.

Run `GET_POSITION` and write down the coordinates as "probe coordinates".

Use the mainsail/fluidd interface to manually move the ***NOZZLE*** as close as you possibly can to that point you marked where the **probe pin** touched.

Run `GET_POSITION` again and note the new coordinates as "nozzle coordinates".

Then:

The probe x\_offset is the X "nozzle coordinates" minus the X "probe coordinates"(This is typically a negative number if your probe is on the left of the nozzle)

The probe y\_offset is the Y "nozzle coordinates" minus the Y "probe coordinates"

Put those values in your config and restart. Done.

Let me know if some part of that is confusing and I will try to explain in more detail.

The basic idea is you are comparing the coordinates the printer registers for the nozzle and probe in the same physical location on the bed. The offset is the difference between them.

How did you calibrate the Z-offset?

Did you use the `PROBE_CALIBRATE` command?

Like this:

Run `PROBE_CALIBRATE`

Then use `TESTZ Z=-1` to bring the nozzle 1mm **closer** to the bed

Use `TESTZ Z=+1` to bring the nozzle 1mm **further** from the bed

And of course you can do `TESTZ Z=-0.001` to go 0.001mm closer, etc

When you are happy with it (0 is actually 0) run `ACCEPT` followed by `SAVE_CONFIG`

Some notes:

The `+` or `-` are necessary in the `TESTZ` commands! If you do `TESTZ Z=1` it will move the nozzle to what it currently thinks 1mm from the bed is. We use the `TESTZ Z=+1` and `TESTZ Z=-1` to move it +1 or -1 from the **current** position.

Typically this is combined with "the paper test" where you use a sheet of paper (a standard printer paper is about 0.1mm thick) When you feel resistance from the nozzle pressing against the paper, that means you are about 0.1mm away from the bed. This way you don't have to actually contact the bed with the nozzle to do this calibration. (We need the exact 0 height, but obviously we never print that close to the bed or no filament would come out)

When you run `TESTZ Z=-0.001` and other very small values then nozzle will life a little before lowering in a kind of bouncing motion. This often looks like it's hit a soft limit and not lowering, but it actually ***is*** still lowering. Klipper does this to get more precise movements and hopefully do less damage if it *does* hit the bed. The little bounce is normal, and it's still working! (You'll understand when you see it)