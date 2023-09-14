#!/bin/bash
# Copyright (C) 2023 Chris Laprade (chris@rootiest.com)
#
# This file is part of config.
#
# config is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# config is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with config.  If not, see <http://www.gnu.org/licenses/>.

# Check if both the source and output filename arguments are provided
if [ $# -lt 2 ]
then
    echo "Error: Two filenames are required."
    exit 1
fi

# Check if the source file exists
if [ ! -f "$1" ]
then
    echo "Error: Source file not found."
    exit 1
fi

# Extract the filename and extension of the source file
source_filename=$(basename -- "$1")
source_extension="${source_filename##*.}"
source_filename="${source_filename%.*}"

# Create the new filename with the provided output filename and extension of the source file
output_filename=$2
output_extension="${source_extension}"
output_basename=$(basename -- "$2")
output_basename="${output_basename%.*}"
if [ "${output_filename}" = "${output_basename}" ]
then
    output_filename="${output_filename}.${output_extension}"
fi

# Invert the file
tac "$1" > "$output_filename"

# Confirm successful inversion
if [ $? -eq 0 ]
then
    echo "File successfully inverted as $output_filename."
else
    echo "Error: Unable to invert file."
fi
