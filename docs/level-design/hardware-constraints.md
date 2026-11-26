# Hardware constraints that shape level design

Figures are standard Intellivision (STIC) facts. Confirm against `tools/intybasic/manual.txt` and the
jzintv docs before relying on a number.

- **Screen grid:** 20 columns x 12 rows of 8x8 cards (240 cells), 160 x 96 pixels. IntyBASIC exposes it as `#BACKTAB(0-239)`.
- **Background graphics:** 64 programmable GRAM cards (more with bank tricks), plus the 256-card GROM font/graphics. Level tiles are usually GRAM cards, so a level has at most ~64 distinct tiles.
- **Sprites (MOBs):** 8 hardware sprites, 8x8 or 8x16. Plan at most 8 moving things on screen, fewer if any need two parts.
- **GRAM updates:** IntyBASIC warns if more than 16 cards are defined in one frame. Load big tile sets across several frames, or while the screen is blank (`SCREEN DISABLE`).
- **RAM:** IntyBASIC has 228 8-bit and 55 16-bit variables. A full 240-cell map does NOT fit in a variable array, so keep levels in ROM (`DATA`) and copy to video with `SCREEN`, then read collisions from `#BACKTAB`.
- **Scrolling:** `SCREEN label,origin,target,cols,rows,origin_width` copies a window out of a wider map (see `samples/scroll.bas`, `samples/landscape.bas`). Tall or wide levels are stored as one large DATA block and windowed.
- **Colours:** Color Stack mode gives each card one foreground colour and a stacked background. Use `CS_*` constants from `src/constants.bas`. Design tiles as one-colour shapes.
- **ROM size:** Plain ROM space is limited; larger games use banked ROM (`samples/banks.bas`, `samples/segments.bas`).
