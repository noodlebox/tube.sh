#!/usr/bin/env bash
# cache.sh - Cache a frame
# Usage:
#   cache.sh [ -z ] FILE [ FRAME ]
set -e

if [[ "$1" == "-z" ]]; then
	compress=1
	shift
else
	unset compress
fi

infile="$1[${2:-0}]"
outfile="$1${2+.$2}.dump${compress+.gz}"

trap 'rm "$outfile"' INT TERM

if [[ ! -f "$outfile" ]]; then
	if [[ -v compress ]]; then
		./dump.sh "$infile" | gzip -c >"$outfile"
	else
		./dump.sh "$infile" >"$outfile"
	fi
fi
