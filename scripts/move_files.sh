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


# Display help information
function display_help() {
    echo "Usage: $0 <source_folder> <destination_folder> <regex>"
    echo ""
    echo "Description:"
    echo "  This script searches for files in the source folder whose filename matches the regex string."
    echo "  It then moves all matching files to the destination folder and provides a summary."
    echo ""
    echo "Parameters:"
    echo "  <source_folder>      The folder to search for files."
    echo "  <destination_folder> The folder to move matching files to."
    echo "  <regex>              The regex string to match against file names."
}

# Validate parameters
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    display_help
    exit 0
fi

if [ $# -lt 3 ]; then
    echo "Error: Not enough parameters provided."
    display_help
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Source folder does not exist."
    display_help
    exit 1
fi

if [ ! -d "$2" ]; then
    echo "Destination folder does not exist. Creating destination folder..."
    mkdir -p "$2"
fi

# Search for and move files
matching_files=$(find "$1" -type f -wholename "$3")
if [ -z "$matching_files" ]; then
    echo "No files matching the regex were found in the source folder."
    exit 0
fi

for file in $matching_files; do
    mv "$file" "$2"
done

# Provide summary
num_files=$(echo "$matching_files" | wc -w)
echo "Moved $num_files file(s) from $1 to $2."
