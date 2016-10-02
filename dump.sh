#!/usr/bin/env bash
# dump.sh - Use terminal escape sequences to render an image
# Usage:
#   dump.sh FILE [COLORS [WIDTH [HEIGHT]]]
set -e

# Parse ImageMagick's 'map:' format
# dump_from_map COLORS WIDTH HEIGHT DISPOSE
dump_from_map() {
	# Read palette
	local n=0 colors=$1 width=$2 height=$3 dispose=$4
	while read r g b; do
		#tput initc $n $((r * 1000 / 255)) $((g * 1000 / 255)) $((b * 1000 / 255))
		# Every terminal supporting initc and 256 colors seems to support this syntax
		# (except rxvt-unicode-256color, which expects 16bpc color values)
		printf '\x1b]4;%d;rgb:%2.2X/%2.2X/%2.2X\x1b\\' "$n" "$r" "$g" "$b"
		n=$((n + 1))
	done < <(od -v -tuC -An -N"$((colors * 3))" -w3)

	# Read pixels
	while read -a row; do
		for n in ${row[@]}; do
			# FIXME: use the correct transparent index
			if [[ "$dispose" == 'None' && "$n" -eq '255' ]]; then
				#tput cuf 2
				printf '\x1b[2C'
			else
				#tput setab $n
				#printf '  '
				# Every terminal supporting initc and 256 colors seems to support this syntax
				printf '\x1b[48;5;%dm  ' "$n"
			fi
		done
		#tput sgr0
		#printf '\n'
		printf '\x1b[m\n'
	done < <(od -v -tuC -An -w"$width")
}

# dump_image FILE [ COLORS WIDTH HEIGHT ]
dump_image() {
	local dispose=$(identify -format '%D\n' "$1" | head -n1)
	convert "$1" map:- | dump_from_map "${2:-256}" "${3:-64}" "${4:-64}" "$dispose"
}

dump_image "$@"
