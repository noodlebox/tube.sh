#!/usr/bin/env bash
# tube.sh - display an indexed-color image in your terminal
# Usage:
#   tube.sh [ -z ] FILE [ DELAY ]
trap 'tput rs1' INT TERM EXIT
set -e

if [[ "$1" == "-z" ]]; then
	compress=1
	shift
else
	unset compress
fi

# TODO: use each frame's specific delay and disposal setting
# Some useful identify -format escapes
# %n - number of frames
# %[scene] - frame number
# %T - frame delay in centi-seconds
# %D - GIF dispose method
# %W, %H - width, height
frames=$(identify -format '%n\n' "$1")
delay=${2:-$(identify -format '%T * 0.01\n' "$1[0]" | bc)}

# Pre-generate terminal escape sequences
identify -format '%[scene]\n' "$1" | parallel --bar ./cache.sh ${compress+'-z'} "$1"

tput rs1
tput sc
if [[ -v compress ]]; then
	dump="gunzip -c"
else
	dump="cat"
fi
if [[ "$frames" -gt 1 ]]; then
	n=0
	until read -n1 -t "$delay"; do
		tput rc
		$dump "$1.$n.dump${compress+.gz}"
		n=$(((n + 1) % frames))
	done
else
	$dump "$1.0.dump${compress+.gz}"
	read -n1
fi
