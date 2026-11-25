#!/usr/bin/env bash
# Usage: scripts/build.sh src/game.bas [run]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:?usage: build.sh src/game.bas [run]}"
NAME="$(basename "${SRC%.*}")"
IB="$ROOT/tools/intybasic"
JZ="$ROOT/tools/jzintv"
mkdir -p "$ROOT/build"
[ -x "$IB/intybasic" ] || make -C "$IB"
"$IB/intybasic" "$SRC" "$ROOT/build/$NAME.asm" "$IB"
"$JZ/bin/as1600" -o "$ROOT/build/$NAME.bin" -l "$ROOT/build/$NAME.lst" "$ROOT/build/$NAME.asm"
echo "Built build/$NAME.bin"
if [ "${2:-}" = "run" ]; then
  "$JZ/bin/jzintv" -p "$JZ/rom" "$ROOT/build/$NAME.bin"
fi
