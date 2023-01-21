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

# Advanced Macro Techniques

- [Advanced Macro Techniques](#advanced-macro-techniques)
  - [Notation](#notation)
  - [Variables And Parameters](#variables-and-parameters)
    - [Parameters](#parameters)
  - [Local Variables](#local-variables)
  - [GCode Variables](#gcode-variables)
  - [Persistent Variables](#persistent-variables)
  - [Variable Types](#variable-types)
    - [Integer](#integer)
    - [Float](#float)
    - [Boolean](#boolean)
    - [String](#string)
  - [Arrays](#arrays)
  - [The Printer Object](#the-printer-object)
  - [Delayed Gcode Macros](#delayed-gcode-macros)
  - [Organizing your config](#organizing-your-config)
    - [The `[include]` function.](#the-include-function)
    - [NOTES](#notes)
  - [Useful Links](#useful-links)


This guide will outline some of the more advanced macro and macro-related features you can use in Klipper.

This is helpful information if you want to start writing your own macros, or just want a better understanding of existing macros you borrowed from elsewhere.

We are still going to stay within the realm of "basics" but the techniques explained here should be sufficient for most macro ideas.

## Notation

As most of what we are working with here is going to be Jinja2 scripting, I think the first thing to cover is going to be:

> What's up with those weird curly bracket things?

So the curly brackets: `{ }` or `{% %}` are used to designate when a piece of code is scripting rather than a normal gcode command. It may seem a bit abstract at first, but you will get the hang of it.

> Keep in mind that any scripting can *only* be done from within Klipper macros. You cannot add scripting in your slicer's custom gcode field or to the gcode file itself.

Alright let's look at some examples. 

I'm going to reference the macros in [my other guide](GUIDE-macros.md) for this as they are simple and probably familiar to more people.

Ok, so the first line of the `START_PRINT` macro:

    {% set BED_TEMP = params.BED_TEMP|default(60)|float %}

This is a conditional statement. As such it uses the `{% %}` wrapper. "Conditional statement" is [a mathematical term](https://www.cuemath.com/data/conditional-statement/). To simplify, when the bit of code involves comparing or setting a value with another value, that is a conditional statement.

Let's look at the other type:

    M140 S{BED_TEMP}

Ok so in this case, we have a normal gcode command, but we also are using those squiggly brackets again, this time without the percent symbols.

What is the difference? Well this time, we are not comparing or testing any values, we just have `BED_TEMP` in there.

So as you may know from the `START_PRINT` guide (and as I cover in more detail below) that first line:

    {% set BED_TEMP = params.BED_TEMP|default(60)|float %}

was setting a local variable called `BED_TEMP` to a value.

So in this line:

    M140 S{BED_TEMP}

we are using that value. This: `{BED_TEMP}` is processed by the gcode as the actual value assigned to that variable.

We could do this:

    M140 S{BED_TEMP + 5}

and the gcode processor would see the equivalent of 5 more than that value. 

So we use the `{ }` brackets to represent a value. We don't even need to use variables for this.

This:

    M140 S{25 * 3 - 2}

is also perfectly valid. 

The math will be solved and the resulting value will be returned in place of the whole curly bracket block.

Alright, so let's move on to the part we've been dancing around for a while now:

## Variables And Parameters

This is how we store information or pass it from one macro (or the slicer) to another macro.

You should have encountered these briefly when [configuring your first START_PRINT macro](GUIDE-macros.md).

There are a handful of different forms of variables used in Klipper and there is some overlap, particularly in how we interact with parameters.

I will go over the different forms, their strengths and weaknesses, and when best to use each kind.

### Parameters

Parameters are a sort of variable that is set by the initial call to the macro.

When you run:

    START_PRINT BED_TEMP=100 EXTRUDER_TEMP=250

The `BED_TEMP` and `EXTRUDER_TEMP` are parameters. They are variables that are being set to a value during the call to `START_PRINT`.

So how do we make use of those?

Let's continue with the above example, using [this START_PRINT macro](GUIDE-macros.md#start_print-macro).

So the first line in that macro shows how we traditionally work with parameters. Let's break it down:

    {% set BED_TEMP = params.BED_TEMP|default(60)|float %}

> Note: This example can be a little confusing as it uses the same name for [the local variable](#local-variables) and [the parameter](#parameters). They are two distinct variables that can have completely different values/names. Just keep this in mind.

So we are setting a local variable to a value with this line.

> Note: Setting and creating a variable are the same thing. The way that Jinja works, there is no real difference between an undefined variable and a variable set to `Null`. We don't really "create" variables, in a way they are already there, we just set a value to it.

See the section below on [local variables](#local-variables). 

Much like other variables, we do not need to "create" parameters. You are welcome to run:

    START_PRINT BED_TEMP=100 EXTRUDER_TEMP=250 PUFF=420

That last `PUFF` parameter is ***not*** invalid, it will just be ignored if our macro doesn't address it by using `params.PUFF` somewhere within the macro.

For now let's look at the rest of our line:

    params.BED_TEMP|default(60)|float

So first off, we are telling Klipper to set our local variable to the value of `params.BED_TEMP`. That is the parameter we have been referring to previously.

But what about all that other junk?

> This symbol: `|` is called a pipe. What it means is take the previous value and "pipe" or pass it to the next part.

So essentially what this means is the other bits are going to influence our original `params.BED_TEMP`.

So `default(60)` means that if a `BED_TEMP` parameter was not specified, we want the default value to be 60.

So if you ran just `START_PRINT`, nothing else, it would set our ***local variable*** to 60.

This is an important inclusion because if we don't have a default, the macro will just throw an error when a parameter is not included. 

It's always a good idea to try to address potential errors *before* they happen, so try to get in the habit of including default values for parameters.

So what's a `float`?

A float is a [type of variable](#variable-types). In this case it means a decimal number.

> I go into more detail on types in the below section.
 
For this particular scenario we are working with numbers. When it comes to numbers, there are two main types to know: integers and floats.

Integers are whole numbers: 1, 2, 3, 420, 99999, -42

Floats are decimal numbers: 1.0, 2.232, 420.69, -8008.135

We could probably get away with using an integer here (who sets their bed to a decimal value?) but the heater temps accept decimal values so we might as well support them too.

So why do we need to set the type? Shouldn't it know by the value we assign it?

Well yes, it does know from the value you assign it, and you certainly could choose not to specify a type. It's optional, just like the `default()` option.

But it does serve a purpose. It will force our local variable to the type we specify. Klipper will do its best to convert values when it can.

So if you have this:

    params.BED_TEMP|default(60)|float

and you try to run this:

    START_PRINT BED_TEMP=your_mom

Klipper will be unable to convert that to a float and instead our local variable will be assigned a value of 0.

But let's say you have this:

    params.BED_TEMP|default(60)|int

and you try to run this:

    START_PRINT BED_TEMP=42.69

Klipper *can* easily convert a float to an integer, and the result will be our local variable getting set to 43.

So as you can see, this is a useful way to address the user/slicer trying to give your macros invalid value types.

So that's the way we traditionally work with parameters. Typically we try to immediately assign them to a local variable and include a default value and a type specification to help prevent errors or invalid data.

That is not to say you can't work with parameters directly, it's just generally better to first assign them to a local variable.

This:

    M140 S{params.BED_TEMP}

is also completely valid.

However, it doesn't address the user setting that parameter to an invalid type or not setting it at all. The above line would throw an error in that case.

## Local Variables

A local variable is one that is defined in the macro. These can only be used from within the same macro.

This line:

    {% set BED_TEMP = params.BED_TEMP|default(60)|float %}

is setting a local variable to the value of a parameter.

I regret using this line as an example because it uses the same name for the parameter and the local variable.

In this example, `params.BED_TEMP` and `BED_TEMP` are not the same thing.

This is also a valid example:

    {% set HOT_TUB = params.BED_TEMP|default(60)|float %}

In this example, `HOT_TUB` is a local variable.

Here is another, simpler example:

    {% set my_variable = 42.69 %}

In this example, `my_variable` is the local variable and:

    M140 S{my_variable}

would set the bed temp to 42.69.

That's pretty much it. We will talk about (and use) local variables a lot, but there's not a whole lot to them.

## GCode Variables

GCode Variables are a special form of variable. These are "owned" by a particular macro but they can be accessed or written to by any macro.

These are useful if you want to pass values between macros but are unable to do so use parameters, or if you want to use a variable in several macros at different times.

Unlike the other kinds of variables, gcode variables *must* be defined.

The way we go about this may feel rather clunky at first, but it's actually fairly simple.

[Here is the relevant section of the Klipper docs](https://www.klipper3d.org/Command_Templates.html#variables)

Let's look at an example:

    [gcode_macro TEST_MACRO]
    variable_test: 0
    gcode:
        {% set my_test = params.SAMPLES|default(0)|int %}
        SET_GCODE_VARIABLE MACRO=TEST_MACRO VARIABLE=test VALUE={my_test}

Ok, so what are we doing here?

This first part:

    variable_test: 0

is defining the gcode variable. This line must always start with `variable_` and the rest of it is the name of the variable.

So:

    variable_boop_beep_boop: 0

would create a variable named `boop_beep_boop`

The number following the colon is the default value of that variable, much like we used the `default()` code for our local variables.

This all must go outside of the `gcode:` block because it's not part of the macro's gcode. It still goes below the `[gcode_macro]` line though because it is a part of that macro.

Now this macro "owns" that variable and we can reference or set it from another macro.

This line:

    {% set my_test = params.SAMPLES|default(0)|int %}

is just setting a local variable from a parameter (see the previous sections)

This line:

    SET_GCODE_VARIABLE MACRO=TEST_MACRO VARIABLE=test VALUE={my_test}

sets the value to our gcode variable.

Let's break it down:

    SET_GCODE_VARIABLE

is a gcode command. Kind of like a native Klipper "macro". 

> Note: This is different than the way we work with other variables, using Jinja. Gcode variables are not Jinja, they are used via actual gcode commands.

The rest are actually parameters being sent to that gcode command.

    MACRO=TEST_MACRO

tells it the variable we are setting is "owned" by the `TEST_MACRO` macro.

    VARIABLE=test

tells it the variable we are setting is named `test` (variable_test)

    VALUE={my_test}

tells it to set that variable's value to the value of our local variable, `my_test`.

> This command is unique because it can be run from anywhere:
> 
> From the "owner" macro, from a different macro, even from the slicer custom gcode or a gcode file!
> 
> Remember though, when using it in the slicer/gcode-file you cannot use the curly brackets, so the value must be real number (or a slicer "placeholder")

So that covers ***setting*** and creating gcode variables, but what about reading their value?

This is done using one of my favorite features: [the Printer object](#the-printer-object).

Let's look at an example:

This is a simple macro that reads the gcode variable we created/set previously and outputs its value to the display.

    [gcode_macro]
    gcode:
        {% set my_variable = printer["gcode_macro TEST_MACRO"].test %}
        M117 {my_variable}

Ok so most of this is pretty self-explanatory. 

It's just a basic macro, and the `M117` command should be familiar here.

The important line is:

    {% set my_variable = printer["gcode_macro TEST_MACRO"].test %}

The basic format should look pretty familiar as well. If not, go back and read the previous sections on parameters and local variables.

So we are once again setting a value to a local variable.

This time the value we are setting is:

    printer["gcode_macro TEST_MACRO"].test

So what does that mean?

See [the section below on the printer object](#the-printer-object), but the short version is that it's a way to access realtime information or values from the configfile. 

This is a *very* extensive topic, you can see all the possible values at [this Klipper docs page](https://www.klipper3d.org/Status_Reference.html).

We are going to use this to access our gcode variable's value.

    printer["gcode_macro TEST_MACRO"]
    
refers to the macro that "owns" the variable.

This may be familiar to those with programming experience as an array. We aren't going to get into that, but an array is like a set of variables.

The `gcode_macro TEST_MACRO` should be familiar as the same define we used to create the macro. It's telling Klipper we are talking about that part of the config (the macro itself).

Then the `.test` is saying we want the variable named `test` that's part of that macro.

So altogether:

    printer["gcode_macro TEST_MACRO"].test

is equal to the value assigned to the variable named `test` that is "owned" by the gcode_macro named `TEST_MACRO`.

This can be used in any macro, but not outside of macros (such as in gcode files or the slicer gcode) because it is Jinja scripting unlike the `SET_GCODE_VARIABLE` command.

## Persistent Variables

Persistent Variables are special in that they will retain their set value even after shutting down the printer or executing a `FIRMWARE_RESTART`.

There are some precautions to keep in mind and ideally you should only be using these when you actually have a need for them.

Persistent variables also have a prerequisite.

They require that you have a `[save_variables]` config section defined.

[See the Klipper docs page here](https://www.klipper3d.org/Config_Reference.html#save_variables)

An common example would be something like this:

    [save_variables]
    filename: ~/printer_data/config/variables.cfg

This is necessary for the same reason you should not overuse this kind of variable:

The variables' values are saved to a file whenever they are set, so repeatedly setting values to a persistent variable (like counting seconds or other frequent changes) is not ideal. 

Writing to disk is a relatively resource-intensive operation compared to working with variables in memory.

So try to only use persistent variables when you actually need them to persist. 

It may even be pertinent to use a local variable while the value is fluid and only set the persistent variable when you have a final value to assign before restart.

Ok, so how do we use them?

Let's look at an example:

    [gcode_macro TEST_MACRO]
    variable_test: 0
    gcode:
        {% set my_test = params.SAMPLES|default(0)|int %}
        SAVE_VARIABLE VARIABLE=test VALUE={my_test}

Most of this should be pretty self-explanatory if you have read through the previous sections of this guide.

The important line here is:

    SAVE_VARIABLE VARIABLE=test VALUE={my_test}

This tells Klipper to save a variable named `test` and test it's value to the value of our local variable named `my_test`.

Like the `SET_GCODE_VARIABLE` command, this one can be used from any macro, or even from the gcode file or slicer (if no Jinja scripting is used) 

> `{my_test}` would need to be changed to a real value to use it in the slicer/gcode-file

This will result in Klipper adding (or editing if it already exists) a line like this:

    test = 0

> That `0` will be whatever value we set to `test` with the command.

So then how do we read/use the persistent variable?

Let's look at a macro:

    [gcode_macro]
    gcode:
        {% set svv = printer.save_variables.variables %}
        {% set my_variable = svv.test %}
        M117 {my_variable}

Ok so let's break this down:

First we have this line:

    {% set svv = printer.save_variables.variables %}

This is just a "shortcut". Nobody wants to type out (or read) `printer.save_variables.variables.test` everytime we refer to that saved variable, so we use this shortcut to shorten:

    printer.save_variables.variables

to:

    svv

That means this:

    printer.save_variables.variables.test

and this:

    svv.test

are the same thing.

And they both refer to the persistent variable we saved previously.

So then:

    {% set my_variable = svv.test %}

is setting a local variable called `my_variable` to that saved value.

## Variable Types

### Integer

This is a whole number, defined as `int`

### Float

This is a decimal number, defined as `float`

### Boolean

This is a true/false value, defined as `bool`

### String

This is regular text, defined as `string`

## Arrays

__WIP__ (This section is not yet completed)

## The Printer Object

[Klipper Docs](https://www.klipper3d.org/Status_Reference.html)

__WIP__ (This section is not yet completed)

## Delayed Gcode Macros

Delayed Gcode macros allow you to run a macro after a delay. This delay can be set to run after startup, or it can be initiated by another macro.

These are configured as follows:

    [delayed_gcode my_delayed_gcode]
    gcode:
        MY_MACRO
    initial_duration: 10.0

In this example, Klipper will execute the macro named `MY_MACRO` 10 seconds after startup.

Alternatively, we could use it like so:

    [delayed_gcode my_delayed_gcode]
    gcode:
        MY_MACRO

This delayed_gcode will not run at startup.

We can then initiate it from another macro like so:

    UPDATE_DELAYED_GCODE ID=my_delayed_gcode DURATION=300

This will tell Klipper to execute the delayed_gcode (and then our `MY_MACRO` macro) 5 minutes after the `UPDATE_DELAYED_GCODE` command was run.

This can be used to set shutdown timers or disable preheat fans 15 minutes into a print, whatever you'd like!

## Organizing your config

Once we start adding additional components and macros, the `printer.cfg` file can get pretty crowded.

We can better organize our configuration by splitting it up into multiple files.

To do so we use:

### The `[include]` function.

[Config Reference](https://www.klipper3d.org/Config_Reference.html#include)

For example, to include a `pico.cfg` file stored in the same directory as `printer.cfg` we would use the following:

    [include pico.cfg]

If that file is in a subdirectory called `macros` we would use this:

    [include macros/pico.cfg]

To include ***every*** file in the `macros` subdirectory, we can use this:

    [include macros/*.cfg]

Now let's assume your `printer.cfg` file is located in `~/printer_data/config` but we want to include a `pico.cfg` file that's in the `~` directory.

We have two options.

We can use the absolute path:

    [include ~/pico.cfg]

or we can use the relative path:

    [include ../../pico.cfg]

Two periods `..` means "go up 1 directory level" so we can use those to reference the directory *above* the current one.

This feature can be used to better organize your config so you can do things such as:

- Organize your configs by mcu
- Group related macros together
- Easily swap between different configurations by changing a single line in your `printer.cfg` file
- much more!

### NOTES

__The `[include]` feature is not fully compatible with `SAVE_CONFIG`.__

Any sections for which you would like to use the `SAVE_CONFIG` function:

- extruder pid
- bed_mesh
- z_offset
- etc

These sections must be initially placed in the `printer.cfg` file to support `SAVE_CONFIG` overrides. 

You will not be able to perform a `SAVE_CONFIG` override on any of those settings while the originals are defined in an included file.

However, once you have successfully `SAVE_CONFIGGED` that setting, the original values will be commented out and the calibrated values added to the `SAVE_CONFIG` block at the end of the `printer.cfg` file.

After this point you can safely move the relevant section to an included file and subsequent `SAVE_CONFIG` operations against those values will execute successfully.

The originally only must be in the main `printer.cfg` file initially, for the first override. Once you have run `SAVE_CONFIG` for that section, it can be moved to any file.
## Useful Links

> __NOTE:__ Take precaution using some of these resources as they may/do contain some outdated information.

[Macro Creation Tutorial](https://klipper.discourse.group/t/macro-creation-tutorial/30)

This is a great resource that provides a ton of information along the same lines as this guide. It's a really useful reference.

However, use it with caution as some of it is outdated. For example: the references to `default_parameter` are no longer valid and have been deprecated on current Klipper versions.

If you have questions/criticisms or find parts of this guide confusing then please feel free to contact me on Discord at `rootiest#5668`.

I am always happy to explain topics in more detail or make corrections to my guides where warranted.