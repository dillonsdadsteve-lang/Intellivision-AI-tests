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
`tools/` holds the Windows jzintv utilities (`as1600.exe`, `jzintv.exe`, `*.exe`), the SDL DLLs, a Linux jzintv
package (`jzintv-20200712-linux-x86-64-sdl2/`), the IntyBASIC folder, the IntyBASIC SDK installer, and the Tracker
files. The BIOS ROMs (`exec.bin`, `grom.bin`, `ECS.BIN`, `ECSPATCH.BIN`) are copyrighted and NOT in the repo: copy
them into `tools/` on your own PC (they are git-ignored).

See [../docs/TOOLS-STATUS.md](../docs/TOOLS-STATUS.md) for the version of each tool and what is out of date.

## Build and run
- `.\scripts\build.ps1 src\hello.bas -Run`
- `scripts/build.sh src/hello.bas run`
- With JLP flash saves: `.\scripts\build.ps1 src\save_template.bas -Run -IbFlags "--jlp" -JzFlags "--jlp --jlp-savegame=save.jlp"`

Shared includes such as `constants.bas` live in `src/`. Output goes to `build/` (git-ignored).
See [../docs/saving-and-banking.md](../docs/saving-and-banking.md) for saving and bank switching.
