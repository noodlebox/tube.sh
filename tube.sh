#!/usr/bin/env bash
tput sgr0; convert "$1" map:- | { n=0; od -v -tuC -An -N0x300 -w3 | while read r g b; do tput initc $n $((r * 1000 / 255)) $((g * 1000 / 255)) $((b * 1000 / 255)); n=$((n + 1)); done; od -v -tuC -An -w64 | while read -a row; do for n in ${row[@]}; do tput setaf $n; printf '██'; done; printf '\n'; done; }; tput sgr0;
