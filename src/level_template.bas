	REM Level template: 20x12 tile map stored as BACKTAB words in ROM.
	REM Copy this file to start a new level-based game.
	REM Tiles are GRAM cards: wall = card 0 (tan), ladder = card 1 (white).
	INCLUDE "constants.bas"

	CONST T_WALL   = $0803	' GRAM card 0, colour tan
	CONST T_LADDER = $080F	' GRAM card 1, colour white

	DIM px, py			' player position in tiles

	DEFINE 0,2,tile_gfx
	WAIT

	SCREEN level_1		' draw the whole level (fast copy to video)
	px = 1 : py = 10

main_loop:
	WAIT
	' Collision is read straight from the screen buffer
	IF CONT.LEFT  THEN IF #BACKTAB(py * 20 + px - 1) <> T_WALL THEN px = px - 1
	IF CONT.RIGHT THEN IF #BACKTAB(py * 20 + px + 1) <> T_WALL THEN px = px + 1
	IF CONT.UP    THEN IF #BACKTAB(py * 20 + px) = T_LADDER THEN py = py - 1
	IF CONT.DOWN  THEN IF #BACKTAB((py + 1) * 20 + px) = T_LADDER THEN py = py + 1
	' Player is a sprite (GROM card 33 = letter A) so it never overwrites the map
	SPRITE 0, $200 + px * 8 + 8, py * 8 + 8, 33 * 8 + CS_WHITE
	GOTO main_loop

	' Level 1: 0 = empty, $0803 = wall, $080F = ladder (20 x 12 words)
level_1:
	DATA $0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803
	DATA $0803,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$0803
	DATA $0803,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$0803
	DATA $0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,0,0,$080F,0,$0803
	DATA $0803,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$080F,0,$0803
	DATA $0803,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$080F,0,$0803
	DATA $0803,0,$080F,0,0,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803
	DATA $0803,0,$080F,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$0803
	DATA $0803,0,$080F,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$0803
	DATA $0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,0,0,0,0,0,0,0,0,$0803
	DATA $0803,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$0803
	DATA $0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803,$0803

tile_gfx:
	BITMAP "XXXXXXXX"
	BITMAP "X__X__X_"
	BITMAP "XXXXXXXX"
	BITMAP "_X__X__X"
	BITMAP "XXXXXXXX"
	BITMAP "X__X__X_"
	BITMAP "XXXXXXXX"
	BITMAP "_X__X__X"

	BITMAP "X______X"
	BITMAP "XXXXXXXX"
	BITMAP "X______X"
	BITMAP "X______X"
	BITMAP "XXXXXXXX"
	BITMAP "X______X"
	BITMAP "X______X"
	BITMAP "XXXXXXXX"
