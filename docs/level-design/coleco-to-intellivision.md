# Using ColecoVision maps for Intellivision games

Status: general knowledge plus the atlas's image sizes. Not verified against the map images.

## The screens differ, so layouts must be redrawn
- ColecoVision: 256 x 192 pixels, 32 x 24 cards of 8x8 (768 cells).
- Intellivision: 160 x 96 pixels, 20 x 12 cards (240 cells).
- A Coleco screen has about 3x the cells. Never copy a layout 1:1. Keep the idea (platform order, ladder rhythm, hazard timing) and redraw it on 20 x 12.
- Count cells, not pixels: divide a map's pixel size by 8 to get tiles, then check how many Intellivision screens that would fill.

## Map shapes seen in the atlas, by size
- **Wide strips (scrolling side view):** Dragonfire 9300 x 256, Smurf: Rescue in Gargamel's Castle 3546 x 170, Robin Hood 1080 x 234, Donkey Kong Jr. 1128 x 194. Model as one long `DATA` row-block and window it with `SCREEN ...,origin_width`.
- **Tall strips (vertical scroll):** FrontLine 704 x 2048 (two maps), Frogger II 320 x 984, Quest For The Golden Chalice quests (up to 1986 x 3395). Model as a tall map and scroll rows.
- **Sheets of single-screen stages:** Donkey Kong, Popeye, BurgerTime, Mr. Do!, Lady Bug, MouseTrap, Carnival, Centipede, Frogger, Q*bert, Venture, Pac-Man prototype, Joust prototype, Jumpman Junior, Slither, Omega Race. One `DATA` block per stage drawn with `SCREEN` (see `src/level_template.bas`).
- **Single large fields:** Super Action Soccer 2530 x 1326, Super-Action Baseball 596 x 436. Sports fields usually scroll or are redrawn at lower detail.

## Genre notes
- **Platform/ladder games** (Donkey Kong, Jumpman Junior, BurgerTime, Mr. Do's Castle): grid-aligned platforms and ladders suit tile maps. Read collisions from `#BACKTAB`.
- **Maze games** (Lady Bug, Pac-Man, MouseTrap, Mr. Do!): the maze is the tile map. Keep corridors one cell wide so sprite movement stays on the grid.
- **Fixed-screen shooters** (Centipede, Carnival, Omega Race): no scrolling; the budget is the 8 sprites, so use background cards for things like mushrooms or targets.
- **Lane/crossing games** (Frogger): rows of moving objects. Few sprites can be reused as a row, or draw lanes with scrolling background cards.
- **Isometric/puzzle** (Q*bert): diamond tiles built from several GRAM cards; check the 64-card budget.
- **Adventure/quest** (Quest For The Golden Chalice, Venture, Smurf, Robin Hood): rooms connected by exits; store each room as a screen and keep a small table of exits.

## Next step
Open the map for your target genre from [vgmaps-colecovision-atlas.md](vgmaps-colecovision-atlas.md), sketch the layout on a 20 x 12 grid, and start from `src/level_template.bas`.
