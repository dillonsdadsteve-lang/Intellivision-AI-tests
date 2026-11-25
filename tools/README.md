# Intellivision toolchain

| Tool | Purpose | Location |
|------|---------|----------|
| IntyBASIC | BASIC cross-compiler (`.bas` -> `.asm`) | `tools/intybasic/` (source, vendored from https://github.com/nanochess/intybasic, BSD-style license) |
| as1600 | CP1610 assembler (`.asm` -> `.bin`) | ships with jzintv |
| jzintv | Emulator/debugger | download locally into `tools/jzintv/` |

jzintv and as1600 are distributed together by Joe Zbiciak at
http://spatula-city.org/~im14u2c/intv/ . They are not committed here
(`tools/jzintv/` is git-ignored).

## Setup
1. Download the jzintv package for your OS from the page above and unzip it so you have
   `tools/jzintv/bin/as1600(.exe)` and `tools/jzintv/bin/jzintv(.exe)`.
2. Put `exec.bin`, `grom.bin` (and optionally `ecs.bin`, `ivoice.bin`) in `tools/jzintv/rom/`.
   These BIOS ROMs are copyrighted and must come from you; do not commit them.
3. Build IntyBASIC:
   - Linux/macOS: `make -C tools/intybasic`
   - Windows: in a MinGW or MSYS2 shell, `g++ -O2 -o tools/intybasic/intybasic.exe tools/intybasic/*.cpp`
4. Build and run:
   - `scripts/build.sh src/hello.bas run`
   - `.\scripts\build.ps1 src\hello.bas -Run`

Shared includes such as `constants.bas` live in `src/`.

Output goes to `build/` (git-ignored).
