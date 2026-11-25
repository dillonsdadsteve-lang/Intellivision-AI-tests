# Intellivision toolchain

| Tool | Purpose | Location |
|------|---------|----------|
| IntyBASIC | BASIC cross-compiler (`.bas` -> `.asm`) | `tools/intybasic/` (source, vendored from https://github.com/nanochess/intybasic, BSD-style license) |
| as1600 | CP1610 assembler (`.asm` -> `.bin`) | ships with jzintv |
| jzintv | Emulator/debugger | download locally into `tools/jzintv/` |

jzintv and as1600 are distributed together by Joe Zbiciak at
http://spatula-city.org/~im14u2c/intv/ . They are not committed here
(`tools/jzintv/` is git-ignored).

## Layout
jzintv, as1600 and the other jzintv utilities (`*.exe`) 
sit directly in `tools/`. The BIOS ROMs (`exec.bin`, `grom.bin`, `ECS.BIN`, `ECSPATCH.BIN`) are
copyrighted and NOT in the repo: copy them into `tools/` on your own PC (they are git-ignored).

IntyBASIC still needs compiling (not yet provided as an .exe):
- Windows (MinGW/MSYS2): `g++ -O2 -o tools/intybasic/intybasic.exe tools/intybasic/*.cpp`
- Linux/macOS: `make -C tools/intybasic`

jzintv.exe needs the SDL runtime DLL next to it; if it fails to start, copy that DLL into `tools/`.

## Build and run
- `.\scripts\build.ps1 src\hello.bas -Run`
- `scripts/build.sh src/hello.bas run`

Shared includes such as `constants.bas` live in `src/`. Output goes to `build/` (git-ignored).
