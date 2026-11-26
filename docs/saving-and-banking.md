# Saving games, JLP, LTO Flash, and bank switching

Sources: the IntyBASIC manual in `tools/intybasic/manual.txt`, the jzintv docs and release notes in
`tools/jzintv-20200712-linux-x86-64-sdl2/`, and the AtariAge and Intellivision Funhouse pages linked
at the bottom. Items marked (unverified) came from forum posts and were not tested on hardware.

## 1. How an Intellivision game saves data
Stock Intellivision cartridges are ROM, so there is nowhere to write. Saving works only on hardware
with writable, non-volatile storage:

| Hardware | Saving |
|----------|--------|
| JLP cartridge | Onboard flash, used for high scores and progress |
| LTO Flash! cartridge | Same JLP flash interface; the menu software lists ROMs that "require" or "use if possible" flash storage |
| Intellicart | RAM only; contents are lost without power (not a save device) |
| ECS | The ECS has a cassette port, which the LTO Flash! flag list also mentions; this repo has no cassette-save examples |

So "game saving" for a new game usually means **JLP flash**.

## 2. JLP flash from IntyBASIC
Compile with `--jlp`. The compiler sets `jlp = 3` and `jlpflash` in the generated `.cfg`
(checked with `src/save_template.bas`).

| Statement | What it does |
|-----------|--------------|
| `FLASH INIT` / `FLASH INIT SIZE n` | Call once at the start. Default size is 16 = 128 rows. `SIZE n` gives `8*n` rows (n sectors) |
| `FLASH.FIRST`, `FLASH.LAST` | First and last usable row numbers |
| `FLASH ERASE row` | Erases the whole sector containing `row` (8 rows) |
| `FLASH READ row,VARPTR #arr(0)` | Copies one row into a 16-bit array of at least 96 entries |
| `FLASH WRITE row,VARPTR #arr(0)` | Writes one row; only works on an erased row |

Facts to design around:
- A row is 96 words. A sector is 8 rows (768 words). Erase is per sector; read and write are per row.
- A row can be written only once until its sector is erased.
- The screen goes black and everything, including music, pauses for a few milliseconds during an erase or write.
- Endurance: community figure of at least 10,000 erase/write cycles (AtariAge forum post by user intvnut, unverified). Save only when something changed and spread writes over many rows.
- Variables must be copied into the `#row` array before `FLASH WRITE`, and copied out after `FLASH READ`.

`src/save_template.bas` implements this: one generation-numbered, checksummed record per row, rotating through
32 rows, erasing a sector only when the write position enters it. The newest save is always in a different
sector from the one being erased. The template compiles and assembles with 0 errors. I have not run it in jzintv.

If you code in assembly instead, jzintv ships `examples/library/jlp_savegame.asm`, with `JF.LOAD`
and `JF.SAVE` for a 94-word record and a 96-word `JF.BUF` buffer.

## 3. Testing saves in jzintv
- Run with `--jlp` to enable the JLP hardware.
- Add `--jlp-savegame=<file>` so saves persist between runs. Without it, flash contents are lost when you quit.
- jzintv prints a message for each JLP save read, write, and erase (since the 2020-07-12 release).
- With the repo scripts: `JZ_FLAGS="--jlp --jlp-savegame=save.jlp" IB_FLAGS="--jlp" scripts/build.sh src/save_template.bas run`
  or `.\scripts\build.ps1 src\save_template.bas -Run -IbFlags "--jlp" -JzFlags "--jlp --jlp-savegame=save.jlp"`.
- The FujiNet jzintv fork (2026-08-13 custom build) adds emulator save states (F2 save, F3 load). Those save the whole machine, not the JLP flash, so they are a debugging aid and not a game-save test.

## 4. LTO Flash!
- The LTO Flash! menu software has flags for ROMs that require JLP/LTO flash storage and for ROMs that use it if present.
- It also has flags for ECS use, Intellivoice, JLP accelerator hardware revisions 3 to 5, PAL/NTSC, and bank switching styles ("Intellicart-style" and "Mattel-style").
- Official manual: https://intvfunhouse.com/intvfunhouse/ltoflash/LTO_Flash_Manual_(Web).pdf. I could not read the PDF, so capacity and ROM-format details are not recorded here.
- For hardware testing, build `.bin` + `.cfg` (as1600 writes both) and, if your tool chain needs it, convert with the LUIGI tools (`bin2luigi`, `rom2luigi` are in the jzintv Linux package; the Windows `tools/` folder has `luigi2bin.exe` only).

## 5. Bank switching
The Intellivision CPU addresses 64K words, and cartridge space is limited. Larger games swap ROM into
a window.

IntyBASIC supports this directly (v1.5.0 and later): `OPTION MAP n`, then `SEGMENT`, `BANK`,
`BANK SELECT`. Maps from the manual:

| Map | Type | Notes |
|-----|------|-------|
| 0 | Manual | Older behaviour; you place code with `ORG` |
| 1 | Static, 16K | Original Mattel map: `$5000-$6FFF`, `$D000-$DFFF`, `$F000-$FFFF` |
| 2 | Static, 42K | Compatible with JLP and the AtariAge PCB |
| 3 | Banked, 98K | 4K banks at `$7000-$7FFF` (banks 0-14) |
| 4 | Banked, 154K | 8K banks at `$E000-$FFFF` |
| 5 | Banked, 254K | 16K banks at `$C040-$FFFF` |
| 6 | Banked, 256K | Two dynamic segments (`$A000-$BFFF`, `$E000-$EFFF`) |
| 7 | Banked, 238K | Four dynamic segments |
| 8 | Static, 50K | Cannot use JLP or CC3 RAM |

Use `BANK n` to put following code or data into a bank, `SEGMENT s BANK n` when several segments
are banked, and `BANK SELECT n` to switch before calling or reading it. With `OPTION MAP 1` or higher the
compiler prints a space-usage report for each segment.

Memory-map facts (Intellivision Wiki, Memory Map page):
- `$5000-$6FFF` ROM is the normal start of cartridge code. `$D000-$DFFF` and `$F000-$F7FF` are free for RAM or ROM.
- Avoid RAM at `$7800-$7FFF`, `$B800-$BFFF`, `$F800-$FFFF` (Graphics RAM write aliases) and the STIC aliases at `$4000`, `$8000`, `$C000`.
- `$2000-$2FFF`, `$4000-$47FF`, `$7001-$77FF`, `$E000-$EFFF` are usable only without an ECS attached.

Intellicart (from `doc/programming/intellicart.txt`): 64K words of RAM; memory ranges carry Read,
Write, and Bank-switched attributes at 2K-word granularity, with 256-word granularity for banking.

as1600 note: its help says page-flipping and bank switching only work in one output format.
If you use banking, watch as1600 for format warnings and compare `.bin` and `.rom` output.

## 6. Checklist for a new game that saves
1. Decide what to save (level, score, lives) and fit it in under 94 words.
2. Compile with `--jlp`, call `FLASH INIT` once, and copy `src/save_template.bas`.
3. Save only on level completion or a new high score, never every frame.
4. Test with `--jlp-savegame=` in jzintv, quit, relaunch, and confirm the data comes back.
5. If the game outgrows one ROM bank, add `OPTION MAP 3` or higher and move level data into banks.

## Links
- IntyBASIC manual and source: https://github.com/nanochess/intybasic
- AtariAge: "Help with saving in IntyBASIC" https://forums.atariage.com/topic/317488-help-with-saving-in-intybasic/
- AtariAge: JLP storage guarantees https://atariage.com/forums/topic/252451-intybasicjlp-guarantees-on-storage-capacity/
- Intellivision Wiki, Memory Map: https://wiki.intellivision.us/index.php/Memory_Map
- LTO Flash! help: https://intvfunhouse.com/intvfunhouse/ltoflash/help/detailed_help/romfeatures.php
