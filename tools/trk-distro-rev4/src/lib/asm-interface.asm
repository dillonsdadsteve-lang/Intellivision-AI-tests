; =========================================================================
; Intellivision Music Tracker - Assembly Language Interface
; =========================================================================

; Set up the global configuration
    INCLUDE "lib/global-config.asm"

; Include the Intellivision Music Tracker library
    INCLUDE "lib/asm-memmap.asm"
    INCLUDE "lib/tracker.mac"
    INCLUDE "lib/tracker.asm"

;; ======================================================================== ;;
;;  SET_ACTIVE_CHANNELS(count)                                              ;;
;;  Sets the global channel state to a special code representing the number ;;
;;  of active channels available to the tracker.                            ;;
;;                                                                          ;;
;;  The active channel code is derived from the number of active channels   ;;
;;  available to the tracker, and is computed using the following formula:  ;;
;;                                                                          ;;
;;              StateCode = ((6 - ActiveChannels) × 3)                      ;;
;;                                                                          ;;
;;  The availability of each channel depends on its priority, according to  ;;
;;  the chart below:                                                        ;;
;;                            +-----------+-----------+                     ;;
;;                            |    MAIN   |    ECS    |    +-----------+    ;;
;;                            |   PSG #1  |   PSG #2  |    |  Channel  |    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  Priority |    ;;
;;        |  Count  |  Code   | A | B | C | D | E | F |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  A  |  1  |    ;;
;;        |    1    |    0    | X | - | - | - | - | - |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  B  |  2  |    ;;
;;        |    2    |    3    | X | X | - | - | - | - |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  C  |  6  |    ;;
;;        |    3    |    6    | X | X | - | X | - | - |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  D  |  3  |    ;;
;;        |    4    |    9    | X | X | - | X | X | - |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  E  |  4  |    ;;
;;        |    5    |   12    | X | X | - | X | X | X |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+    |  F  |  5  |    ;;
;;        |    6    |   15    | X | X | X | X | X | X |    +-----+-----+    ;;
;;        +---------+---------+---+---+---+---+---+---+                     ;;
;;                                                                          ;;
;;      LEGEND:                                                             ;;
;;          [ - ] Unused                                                    ;;
;;          [ X ] Active                                                    ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      count       The number of active channels to use.                   ;;
;;                                                                          ;;
;;  OUTPUT                                                                  ;;
;;      R0          The computed active channels code.                      ;;
;; ======================================================================== ;;
MACRO   SET_ACTIVE_CHANNELS(count)
;
    LISTING "code"

_trk.recsize    QSET    3

        IF (((%count%) < 1) OR ((%count%) > TRK_MAX_CHANNELS))
            ERR $("Invalid channel count '", $#(%count%), "'.  Value must be a number between 1 and ", $#(TRK_MAX_CHANNELS), ", inclusively.")
        ELSE
            MVII    #((TRK_MAX_CHANNELS - %count%) * _trk.recsize), R0
            MVO     R0,     _b_var(CHN_STATE)
        ENDI

    LISTING "prev"
ENDM

;; ======================================================================== ;;
;;  End of File:  asm-interface.asm                                         ;;
;; ======================================================================== ;;
