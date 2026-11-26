#!/usr/bin/env bash
# Usage: [IB_FLAGS="--jlp"] [JZ_FLAGS="--jlp --jlp-savegame=save.jlp"] scripts/build.sh src/game.bas [run]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$(cd "$(dirname "${1:?usage: build.sh src/game.bas [run]}")" && pwd)/$(basename "$1")"
NAME="$(basename "${SRC%.*}")"
IB="$ROOT/tools/intybasic"
JZ="$ROOT/tools"
mkdir -p "$ROOT/build"
[ -x "$IB/intybasic" ] || make -C "$IB"
# IntyBASIC resolves INCLUDEs from the current directory, so run it next to the source
(cd "$(dirname "$SRC")" && "$IB/intybasic" ${IB_FLAGS:-} "$(basename "$SRC")" "$ROOT/build/$NAME.asm" "$IB")
"$JZ/as1600" -o "$ROOT/build/$NAME.bin" -l "$ROOT/build/$NAME.lst" "$ROOT/build/$NAME.asm"
echo "Built build/$NAME.bin"
if [ "${2:-}" = "run" ]; then
  "$JZ/jzintv" ${JZ_FLAGS:-} -p "$JZ" "$ROOT/build/$NAME.bin"
fi
