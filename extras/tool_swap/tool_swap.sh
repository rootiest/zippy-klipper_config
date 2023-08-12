#!/bin/bash

# Copyright (C) 2022 Chris Laprade
#
# This file is part of zippy_config.
#
# zippy_config is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# zippy_config is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with zippy_config.  If not, see <http://www.gnu.org/licenses/>.


########      Tool Swap Script      ########
### Written with the assistance of an AI ###
############################################

# Define the file to be searched
filename=~/printer_data/config/printer.cfg

# Check if the required number of arguments have been provided
if [ $# -ne 1 ]
then
    echo "Error: Incorrect number of arguments. 1 argument required."
    exit 1
fi

# Assign the argument to a variable as an integer

tool_number=$1
# Convert to an inteeger
tool_number=$((tool_number))


# Check if the input parameter is a valid integer
if [ $tool_number -lt 0 ]
then
    echo "Error: Invalid input. Integer must be greater than or equal to 0."
    exit 1
fi

# Construct the replacement string
replace_string="[include tool$tool_number.cfg]"

# Check if the file exists
if [ ! -f "$filename" ]
then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Use sed to search for the regex pattern and replace the matching line with the replace string
temp_file=$(mktemp)
sed -e '/\[include tool[0-9]\+\.cfg\]/c\'"$replace_string" "$filename" > "$temp_file"

# Check if any changes were made
if cmp -s "$temp_file" "$filename"
then
    echo "No changes made."
else
    # Check if more than one occurrence of the regex pattern was found
    occurrences=$(grep -c '\[include tool[0-9]\+\.cfg\]' "$filename")
    if [ "$occurrences" -gt 1 ]
    then
        echo "Error: More than one occurrence of the regex pattern was found."
        exit 1
    fi
    
    mv "$temp_file" "$filename"
fi

