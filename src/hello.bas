	REM Minimal IntyBASIC test program
	INCLUDE "constants.bas"

	CLS
	PRINT AT SCREENPOS(4, 5) COLOR CS_WHITE,"HELLO INTELLIVISION"
loop:
	WAIT
	GOTO loop
