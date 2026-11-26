# Using NES maps for Intellivision games

Status: general knowledge plus map counts from the atlas page. Not verified against the map images.

## The consoles differ a lot
- NES: 256 x 240 pixels (32 x 30 tiles of 8x8), background scrolling with two screens of tiles, up to 64 sprites with 8 per scanline.
- Intellivision: 160 x 96 pixels (20 x 12 cards), 8 sprites in total, 64 GRAM cards.
- An NES screen holds about 4x the cells of an Intellivision screen, and NES games assume lots of sprites and smooth scrolling. Copy ideas, not layouts.

## What translates well
- **Single-screen stages** (Donkey Kong, Popeye, BurgerTime, Balloon Fight, Mappy-Land): the Intellivision originals had stages of exactly this kind. Redraw each stage on 20 x 12.
- **Grid puzzles** (Boulder Dash, Lolo, Eggerland, Fire 'N Ice, Kickle Cubicle): tile maps with few moving parts. Store each puzzle in ROM as `DATA` and read collisions from `#BACKTAB`. Small puzzles of 12 x 8 or so leave room for a status row.
- **Mazes** (Pac-Man, Battle City, Gauntlet): corridor layouts survive scaling if you keep them one cell wide.
- **Wrecking Crew** [125 entries] and **Mappy-Land** [32]: many short single-screen phases, a good model for a level-per-screen structure with a level-select table.

## What does not translate
- Large scrolling adventures and platformers (Zelda, Metroid, Castlevania, Mario): entire worlds do not fit in 64 GRAM cards and 8 sprites. Use only for pacing ideas: how often a hazard appears, where rest areas sit.
- Anything relying on many on-screen enemies: cap at the 8-sprite budget, or draw enemies as background cards.

## Workflow
1. Pick a genre in [vgmaps-nes-atlas.md](vgmaps-nes-atlas.md) and open the map in a browser.
2. Count the distinct tiles, and decide if they fit the 64-card budget.
3. Sketch the layout on a 20 x 12 grid (see [hardware-constraints.md](hardware-constraints.md)).
4. Start from `src/level_template.bas`.
