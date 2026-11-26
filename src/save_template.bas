	REM Save-game template for JLP flash (JLP cartridges and LTO Flash!).
	REM Build with:  intybasic --jlp save_template.bas out.asm lib
	REM Run with:    jzintv --jlp --jlp-savegame=save.jlp save_template.bin
	REM
	REM Each save is ONE 96-word flash row:
	REM   word 0 = generation number (1..65534; $FFFF = erased/empty)
	REM   word 1 = level   word 2 = score   word 3 = lives
	REM   word 95 = checksum of words 0-3
	REM Rows are written one after another and wrap around. A sector (8 rows) is
	REM erased only when the write position reaches its first row, so the newest
	REM save always survives a power loss, and wear is spread over every row.
	INCLUDE "constants.bas"

	FLASH INIT SIZE 4		' 4 sectors = 32 rows (wear spread, per jzintv community advice)

	DIM #row(96)
	DIM #gen, #best, #bestrow
	DIM cur				' row index where the newest save lives
	DIM level, lives
	DIM #score

	GOSUB load_game
	level = #row(1) : #score = #row(2) : lives = #row(3)
	IF #best = 0 THEN level = 1 : #score = 0 : lives = 3

	PRINT AT 20 COLOR CS_WHITE,"LEVEL"
	PRINT AT 40 COLOR CS_WHITE,"SCORE"
	PRINT AT 60 COLOR CS_WHITE,"LIVES"

main_loop:
	WAIT
	PRINT AT 26,<2>level
	PRINT AT 46,<5>#score
	PRINT AT 66,<1>lives
	' Demo: button 1 = score up, button 2 = next level, button 3 = save
	IF CONT1.BUTTON THEN #score = #score + 10
	IF CONT1.B1 THEN level = level + 1
	IF CONT1.B2 THEN GOSUB save_game
	FOR i = 0 TO 20 : WAIT : NEXT i
	GOTO main_loop

	' Scan every row; keep the highest generation with a valid checksum
load_game: PROCEDURE
	#best = 0 : #bestrow = FLASH.FIRST
	FOR cur = FLASH.FIRST TO FLASH.LAST
		FLASH READ cur,VARPTR #row(0)
		IF #row(0) <> $FFFF THEN
			IF #row(95) = (#row(0) + #row(1) + #row(2) + #row(3)) AND $FFFF THEN
				IF #row(0) > #best THEN #best = #row(0) : #bestrow = cur
			END IF
		END IF
	NEXT cur
	IF #best > 0 THEN FLASH READ #bestrow,VARPTR #row(0)
	#gen = #best
	END

save_game: PROCEDURE
	DIM nxt
	' Next row after the newest; wrap at the end of flash
	nxt = #bestrow + 1
	IF #best = 0 THEN nxt = FLASH.FIRST
	IF nxt > FLASH.LAST THEN nxt = FLASH.FIRST
	' Entering a new sector: erase it first (the newest save is in the previous sector)
	IF ((nxt - FLASH.FIRST) AND 7) = 0 THEN FLASH ERASE nxt
	#gen = #gen + 1
	IF #gen = $FFFF THEN #gen = 1
	#row(0) = #gen : #row(1) = level : #row(2) = #score : #row(3) = lives
	#row(95) = (#row(0) + #row(1) + #row(2) + #row(3)) AND $FFFF
	FLASH WRITE nxt,VARPTR #row(0)
	#best = #gen : #bestrow = nxt
	END
