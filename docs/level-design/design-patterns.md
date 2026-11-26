# Level-design patterns from the mapped games

Status: general knowledge plus the atlas's image sizes. Not verified against the map images.
Open the maps from [vgmaps-intellivision-atlas.md](vgmaps-intellivision-atlas.md) and check each point.

## Donkey Kong, Popeye (single-screen platformers)
- The map images are small (598 px wide), so these are a handful of single-screen stages shown side by side.
- Each stage fits one 20x12 screen: study how platforms, ladders and hazards are arranged inside that grid.
- Questions to answer from the map: how many stages, what changes between them, where ladders sit, and how much open floor is left for the player.
- In IntyBASIC: one `DATA` block per stage, drawn with `SCREEN`; ladders and platforms checked via `#BACKTAB`. `src/level_template.bas` is this pattern.

## Kool-Aid Man (single large play area)
- The map is 907 x 452 px, wider than one screen. Check whether it is one arena, several screens, or a scrolling field.
- If it is larger than 160x96, copy windows with `SCREEN ...,origin_width`.

## Tower Of Doom (large dungeon crawl)
- Four huge maps: a Novice dungeon and a tower with 8, 12 and 20 levels. Each image is thousands of pixels across.
- Study: room size, corridor widths, how levels connect, and how difficulty grows with depth.
- In IntyBASIC: store the dungeon as a big `DATA` map, show a room-sized window with `SCREEN`, and use banked ROM when it outgrows one bank.

## Checklist for every new level
1. Does it fit 20x12 cells, or does it need scrolling?
2. How many distinct tiles (budget of 64 GRAM cards)?
3. How many moving objects at once (budget of 8 sprites)?
4. Where does the player start, what is the exit, and what teaches each mechanic?
5. Are collisions read from `#BACKTAB` rather than a RAM copy of the map?
