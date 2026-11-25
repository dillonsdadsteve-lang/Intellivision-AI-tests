#!/bin/sh
# Build Runner Pro: IntyBASIC -> CP1610 assembly -> ROM, then (optionally) run in jzintv.
#
# Usage:
#   INTYBASIC_DIR=/path/to/intybasic ./build.sh          # build only
#   INTYBASIC_DIR=/path/to/intybasic JZINTV_ROMS=/path/to/roms ./build.sh run
#
# INTYBASIC_DIR must contain the intybasic binary and its lib/ folder.
# JZINTV_ROMS must contain exec.bin and grom.bin (your own dumps).

set -e
: "${INTYBASIC_DIR:?Set INTYBASIC_DIR to your IntyBASIC folder}"
NAME=runnerpro

"$INTYBASIC_DIR/intybasic" "$NAME.bas" "$NAME.asm" "$INTYBASIC_DIR/lib"
as1600 -o "$NAME.bin" -i "$INTYBASIC_DIR/lib" -l "$NAME.lst" "$NAME.asm"

echo "Built $NAME.bin (+ $NAME.cfg)"

if [ "$1" = "run" ]; then
    : "${JZINTV_ROMS:?Set JZINTV_ROMS to the folder holding exec.bin and grom.bin}"
    jzintv -p "$JZINTV_ROMS" "$NAME.bin"
fi
