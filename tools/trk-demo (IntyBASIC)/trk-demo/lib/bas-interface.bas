' =========================================================================
' Intellivision Music Tracker - IntyBASIC Interface
' =========================================================================

' --------------------------------------------------------------
' NOTE:
'   The Intellivision Music Tracker supports either a three- or
'   six-channel configuration.  The six-channel configuration
'   takes advantage of the additional PSG in the ECS, and so
'   requires the expansion module.
'
'   The configuration of the tracker is done using symbolic
'   constants in the file "trk-memmap.asm".  It is recommended
'   that you use the default configuration unless you really
'   know what you are doing.
'
'   If you disable the six-channel configuration, you must
'   also change the array sizes below to match.  You must also
'   ensure that all your song structures conform to the same
'   configuration or else Bad Things may happen.
'
'   Consult the tracker's User Manual & Technical Guide for more
'   information on the supported configurations.
' --------------------------------------------------------------

' Support for 3 Channels (Does Not Require ECS)
'   Const BYTEVAR_SIZE = 21
'   Const WORDVAR_SIZE =  5

' Support for 6 Channels (Requires ECS)
	Const BYTEVAR_SIZE = 36
	Const WORDVAR_SIZE =  8

	' Induce IntyBASIC to enable ECS support
	SOUND 5, 0, 0

' Allocate blocks of RAM for variables
	DIM  TRK_BYTEVAR( BYTEVAR_SIZE )
	DIM #TRK_WORDVAR( WORDVAR_SIZE )

' Set up the global configuration
    ASM INCLUDE "lib/global-config.asm"

' Include the Intellivision Music Tracker library
	ASM INCLUDE "lib/bas-memmap.asm"
	ASM INCLUDE "lib/tracker.mac"
	ASM INCLUDE "lib/bas-callapi.asm"
	ASM INCLUDE "lib/tracker.asm"
