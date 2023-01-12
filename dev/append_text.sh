#!/bin/bash

# Copyright (C) 2023 Chris Laprade
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

usage() {
    echo "Usage: $0 [-t source_text] [-f source_file] [-h] target_file"
    echo ""
    echo "Append contents of a file or specified text to another file"
    echo ""
    echo "Options:"
    echo "  -t  source_text   specify the text to be appended to the target file"
    echo "  -f  source_file   specify the source file whose contents will be appended to the target file"
    echo "  -h                display this help and exit"
    exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

while getopts "t:f:h" opt; do
  case $opt in
    t) source_text="$OPTARG";;
    f) source_file="$OPTARG";;
    h) usage;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1;;
  esac
done
shift $((OPTIND-1))
target_file="$1"

if [ -n "$source_file" ]; then
    if [ ! -f "$source_file" ]; then
        echo "Error: $source_file does not exist or is not a regular file."
        exit 1
    fi
    cat "$source_file" >> "$target_file"
    echo "Contents of $source_file successfully appended to $target_file."
elif [ -n "$source_text" ]; then
    echo "$source_text" >> "$target_file"
    echo "Text '$source_text' successfully appended to $target_file."
else
    echo "Error: Neither source text nor file provided"
    exit 1
fi