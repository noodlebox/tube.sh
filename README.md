# tube.sh

Render indexed 256 color images on the terminal.

A bit like [picture-tube](https://github.com/substack/picture-tube), except that it supports more formats and it takes advantage of your terminal's capability for redefining colors to produce prettier output. Also, it's implemented in bash for some reason.

## Requires

- imagemagick
- tput (from ncurses)

## Usage

Check for capability:

    $ tput ccc && echo "yep" || echo ":("

Display `IMAGE`, which should be a path to a 64x64 indexed 256 color image:

    $ tube.sh IMAGE

Reset terminal's palette after viewing with:

    $ tput rs1

## TODO

- Detect image dimensions and palette size automatically
- Resize and (re-)quantize images as needed
- Command line options and/or interactive mode
