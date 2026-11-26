# Tool versions in this repo (checked 2026-11-26)

| Component | In repo | Latest I could confirm | Status |
|-----------|---------|------------------------|--------|
| IntyBASIC source (`tools/intybasic/*.cpp`, `manual.txt`) | v1.5.2 | upstream `nanochess/intybasic` commit `d9adb35` (2026-11-02) | Matches upstream |
| IntyBASIC library (`intybasic_prologue.asm`, `intybasic_epilogue.asm`) | Older than upstream | Upstream has newer versions | Out of date (see below) |
| `tools/intybasic/intybasic.exe` | v1.5.1 (May 2025) | Source is v1.5.2 | Older than the source |
| `tools/as1600.exe` | SVN revision 2108 | Linux package in repo has 2110; FujiNet fork builds newer | Older |
| `tools/jzintv.exe` | Version not readable from the file | Official site not reachable from my sandbox | Unknown |
| `tools/jzintv-20200712-linux-x86-64-sdl2/` | jzintv 2020-07-12 | Fork notes say the community build is based on the 2020-08-22 release | One official release behind (not confirmed) |
| SDL / SDL2 DLLs | present | n/a | OK |
| IntyBASIC SDK installer | 1.2.2 | n/a | Present for convenience |
| Tracker v1.5 manual and demo | present | n/a | Present |

## What the checks found
- **Library mismatch:** the uploaded `intybasic_prologue.asm` and `intybasic_epilogue.asm` are older than upstream. The upstream versions add a BUSRQ fix for `PLAY` (2025-07-24), a `DIS` fix in the epilogue, a prologue fix for `VOICE.AVAILABLE`, and a new header from 2026-03-20.
- **Compiler and library should match.** Because `intybasic.exe` is v1.5.1, I did not swap in the newer library files, to avoid breaking your working build.
- **Linux builds:** my tests used a v1.5.2 compiler built from upstream source and an as1600 built from the FujiNet jzintv fork. The generated ROMs assembled with 0 errors.

## How to bring everything up to date
1. Rebuild the compiler from the repo source, using MinGW or MSYS2:
   `g++ -O2 -o tools/intybasic/intybasic.exe tools/intybasic/*.cpp`
2. Then replace the two library files with the current upstream copies from https://github.com/nanochess/intybasic (tell me and I will do this part).
3. Replace `jzintv.exe` and `as1600.exe` with the newest official jzintv from Joe Zbiciak's page, http://spatula-city.org/~im14u2c/intv/, or with a build of the FujiNet fork (https://github.com/FujiNetWIFI/jzintv, a custom build, not an official release).

## Not done and why
- I cannot download from the official jzintv site or build Windows `.exe` files in this sandbox (no MinGW).
- I could not run the Linux jzintv in the repo because it needs `libreadline.so.6`, which is not installed here, so none of the ROMs have been played in an emulator by me.
