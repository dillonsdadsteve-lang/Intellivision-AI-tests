; =========================================================================
; Intellivision Music Tracker - IntyBASIC Procedure Call API
; =========================================================================

;; ======================================================================== ;;
;;  SET_ACTIVE_CHANNELS                                                     ;;
;;  Sets the global channel state to a special code representing the number ;;
;;  of active channels available to the tracker.                            ;;
;;                                                                          ;;
;;  Supported values are 1 through 6.  Any other value will be ignored.     ;;
;;                                                                          ;;
;;  The availability of each channel depends on its priority, according to  ;;
;;  the chart below:                                                        ;;
;;                        +-----------+-----------+                         ;;
;;                        |    MAIN   |    ECS    |       +-----------+     ;;
;;                        |   PSG #1  |   PSG #2  |       |  Channel  |     ;;
;;          +-------------+---+---+---+---+---+---+       |  Priority |     ;;
;;          |    count    | A | B | C | D | E | F |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  A  |  1  |     ;;
;;          |      1      | X | - | - | - | - | - |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  B  |  2  |     ;;
;;          |      2      | X | X | - | - | - | - |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  C  |  6  |     ;;
;;          |      3      | X | X | - | X | - | - |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  D  |  3  |     ;;
;;          |      4      | X | X | - | X | X | - |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  E  |  4  |     ;;
;;          |      5      | X | X | - | X | X | X |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+       |  F  |  5  |     ;;
;;          |      6      | X | X | X | X | X | X |       +-----+-----+     ;;
;;          +-------------+---+---+---+---+---+---+                         ;;
;;                                                                          ;;
;;      LEGEND:                                                             ;;
;;          [ - ] Unused                                                    ;;
;;          [ X ] Active                                                    ;;
;;                                                                          ;;
;; ------------------------------------------------------------------------ ;;
;;  NOTE:   The only reason we need this procedure is because the tracker   ;;
;;          variables are not available to the program until after the      ;;
;;          "IntyBASIC Interface" module is included, which doesn't happen  ;;
;;          until the end of the end.                                       ;;
;;                                                                          ;;
;;          Since the interface module includes all dependencies, moving it ;;
;;          to the top of the program would cause other problems.           ;;
;;                                                                          ;;
;;          An alternative would be to split the dependencies into two      ;;
;;          separate modules, including all variable definitions at the top ;;
;;          and all procedure code at the bottom; but that would make the   ;;
;;          integration a bit more cumbersome, and put additional burdens   ;;
;;          on the programmer.                                              ;;
;;                                                                          ;;
;;          Because we want the interface and integration to be as simple   ;;
;;          as possible, with as little friction as is practical, we chose  ;;
;;          to implement it this way.                                       ;;
;; ------------------------------------------------------------------------ ;;
;;                                                                          ;;
;;  INPUTS                                                                  ;;
;;      R0      The number of active channels to use (1..6).                ;;
;;                                                                          ;;
;;  OUTPUT                                                                  ;;
;;      R0      The computed active channels code.                          ;;
;;      R1      Trashed.                                                    ;;
;; ======================================================================== ;;
SET_ACTIVE_CHANNELS  PROC
                CMPI    #1,     R0                          ; \
                BLT     @@__skip                            ;  |_ Check range: 1 .. TRK_MAX_CHANNELS
                CMPI    #TRK_MAX_CHANNELS,  R0              ;  |    (Skip if outside)
                BGT     @@__skip                            ; /

                SUBI    #TRK_MAX_CHANNELS,  R0              ; \
                NEGR    R0                                  ;  |
                MOVR    R0,     R1                          ;   > channel state = ((6 - R0) * 3)
                SLL     R0,     1                           ;  |
                ADDR    R1,     R0                          ; /
                MVO     R0,     _b_var(CHN_STATE)

@@__skip:       JR      R5
                ENDP

;; ======================================================================== ;;
;;  TRKLOADSONG    Song initialization (IntyBASIC Alternative Inteface)     ;;
;;      R0: Song address                                                    ;;
;;      R5: Return address                                                  ;;
;; ======================================================================== ;;
TRKLOADSONG     PROC
                MOVR    R0,     R1
                DECLE   $0208                               ; Cheap NOOP (skips next instruction)

                ; NOTE:
                ;   Routine falls through onto next,
                ;   skipping the first word.
                ;           ,_____,
                ;           |     |
                ;           |     |
                ;        ,__|     |__,
                ;         \         /
                ;           \     /
                ;             \,/
                ENDP

                ; INCLUDE   "lib/tracker.asm"

;; ======================================================================== ;;
;;  End of File:  bas-callapi.asm                                           ;;
;; ======================================================================== ;;
