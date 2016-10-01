# tube.sh

Render indexed 256 color images on the terminal.

A bit like [picture-tube](https://github.com/substack/picture-tube), except that it supports more formats and it takes advantage of your terminal's capability for redefining colors to produce prettier output. It even plays animated GIFs. Also, it's implemented in bash for some reason.

## Requires

- imagemagick
- tput (from ncurses)
- GNU parallel

## Usage

Check for capability:

    $ tput ccc && echo "yep" || echo ":("

Display `IMAGE`, which should be a path to a 64x64 indexed 256 color image:

    $ ./tube.sh [-z] IMAGE

Generating the terminal escape sequences for an image is slow (especially for animated GIFs), so they will be pre-generated the first time you view an image and saved as `IMAGE.dump` (`IMAGE.dump.gz` if `-z` option is given). Exit with any key.

To simply dump the sequences to print an image:

    $ ./dump.sh IMAGE [COLORS [WIDTH [HEIGHT]]]

Choose a specific frame, `n`, of an animated image by appending `[n]` to its filename.

## TODO

- Detect image dimensions and palette size automatically
- Resize and (re-)quantize images as needed
- Command line options and/or interactive mode
