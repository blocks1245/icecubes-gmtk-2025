#!/bin/sh
echo -ne '\033c\033]0;icecubes gmtk 2025\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/8EA.x86_64" "$@"
