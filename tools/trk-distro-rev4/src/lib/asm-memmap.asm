;* ======================================================================== *;
;*  These routines are placed into the public domain by their authors.  All *;
;*  copyright rights are hereby relinquished on the routines and data in    *;
;*  this file.  -- James Pujals, 2020                                       *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  MEMORY ALLOCATION FOR TRACKER                                           ;;
;;                                                                          ;;
;;  WARNING:                                                                ;;
;;      Do not change the order of these variables!  The tracker computes   ;;
;;      offsets between them to optimize memory access.  The sign of these  ;;
;;      offsets depends on the relative position of the addresses, and will ;;
;;      break the tracker if wrong.                                         ;;
;;                                                                          ;;
;;      YOU HAVE BEEN WARNED.                                               ;;
;; ======================================================================== ;;

;; ======================================================================== ;;
;;  RAM REQUIREMENTS                                                        ;;
;;      The tracker library relies on a number of internal data structures  ;;
;;      to synthesize instrument sounds and to keep track of music patterns ;;
;;      and note placements as it plays.  The number of variables depends   ;;
;;      on the channel configuration. Note that the 6-channel configuration ;;
;;      requires more memory.                                               ;;
;;                                                                          ;;
;;      3 Channels:                                                         ;;
;;           5  16-bit (System) RAM                                         ;;
;;          20  8-bit (Scratch) RAM                                         ;;
;;                                                                          ;;
;;      6 Channels:                                                         ;;
;;           8  16-bit (System) RAM                                         ;;
;;          35  8-bit (Scratch) RAM                                         ;;
;;                                                                          ;;
;;      The variable allocations below use the macros SYSTEM and SCRATCH    ;;
;;      from the "Cart.mac" macro library, for 16-bit and 8-bit variables,  ;;
;;      respectively.  If you do not use "Cart.mac," you'll need to replace ;;
;;      them with appropriate addresses in the corresponding memory space.  ;;
;; ======================================================================== ;;

TRK_BYTEVAR     STRUCT  0

; GLOBAL TRACKER STATE:
; ------------------------------
@@CHN_STATE     SCRATCH 1       ; Channel active state
@@MASTER_FADER  SCRATCH 1       ; Master volume fader control (program volume control)

@@START         EQU     .SCRMEM

@@REF_M         SCRATCH 1       ; Global song refresh counter (counts down to next row)
@@COUNT_M       SCRATCH 1       ; Global music counter
@@COUNT_P       SCRATCH 1       ; Pattern counter (counts down pattern length)
@@PAT           SCRATCH 1       ; Index of current pattern in patterns table

; CHANNEL NOTES:
; ------------------------------
@@NOTE_A        SCRATCH 1       ; Current Channel A note
@@NOTE_B        SCRATCH 1       ; Current Channel B note
@@NOTE_C        SCRATCH 1       ; Current Channel C note

    IF (TRK_ENABLED_6_CHN)
@@NOTE_D        SCRATCH 1       ; Current Channel D note
@@NOTE_E        SCRATCH 1       ; Current Channel E note
@@NOTE_F        SCRATCH 1       ; Current Channel F note
    ENDI

; CHANNEL NOTE COUNTERS
; ------------------------------
@@REF_A         SCRATCH 1       ; Channel A note refresh counter (<< 4: counts down to next note event)
@@REF_B         SCRATCH 1       ; Channel B note refresh counter (<< 4: counts down to next note event)
@@REF_C         SCRATCH 1       ; Channel C note refresh counter (<< 4: counts down to next note event)

    IF (TRK_ENABLED_6_CHN)
@@REF_D         SCRATCH 1       ; Channel D note refresh counter (<< 4: counts down to next note event)
@@REF_E         SCRATCH 1       ; Channel E note refresh counter (<< 4: counts down to next note event)
@@REF_F         SCRATCH 1       ; Channel F note refresh counter (<< 4: counts down to next note event)
    ENDI

; CHANNEL VOLUME:
; ------------------------------
@@VOL_A         SCRATCH 1       ; Channel A volume (complemented: ~(Volume))
@@VOL_B         SCRATCH 1       ; Channel B volume (complemented: ~(Volume))
@@VOL_C         SCRATCH 1       ; Channel C volume (complemented: ~(Volume))

    IF (TRK_ENABLED_6_CHN)
@@VOL_D         SCRATCH 1       ; Channel D volume (complemented: ~(Volume))
@@VOL_E         SCRATCH 1       ; Channel E volume (complemented: ~(Volume))
@@VOL_F         SCRATCH 1       ; Channel F volume (complemented: ~(Volume))
    ENDI

; CHANNEL INSTRUMENTS:
; ------------------------------
@@INSTR_A       SCRATCH 1       ; Current Channel A instrument
@@INSTR_B       SCRATCH 1       ; Current Channel B instrument
@@INSTR_C       SCRATCH 1       ; Current Channel C instrument

    IF (TRK_ENABLED_6_CHN)
@@INSTR_D       SCRATCH 1       ; Current Channel D instrument
@@INSTR_E       SCRATCH 1       ; Current Channel E instrument
@@INSTR_F       SCRATCH 1       ; Current Channel F instrument
    ENDI

; CHANNEL LOCAL COUNTER
; ------------------------------
@@COUNT_A       SCRATCH 1       ; Channel A local counter (counts $00..$FF, or until note duration, for use by pitch effects)
@@COUNT_B       SCRATCH 1       ; Channel B local counter (counts $00..$FF, or until note duration, for use by pitch effects)
@@COUNT_C       SCRATCH 1       ; Channel C local counter (counts $00..$FF, or until note duration, for use by pitch effects)

    IF (TRK_ENABLED_6_CHN)
@@COUNT_D       SCRATCH 1       ; Channel E local counter (counts $00..$FF, or until note duration, for use by pitch effects)
@@COUNT_E       SCRATCH 1       ; Channel E local counter (counts $00..$FF, or until note duration, for use by pitch effects)
@@COUNT_F       SCRATCH 1       ; Channel F local counter (counts $00..$FF, or until note duration, for use by pitch effects)
    ENDI

@@SIZE          EQU     (.SCRMEM - @@START)
                ENDS


TRK_WORDVAR     STRUCT  0
@@SONG          SYSTEM  1       ; Pointer to song
@@INS_PTR       SYSTEM  1       ; Pointer to instruments table

; CHANNEL PATTERN POSITIONS:
; ------------------------------
@@POS_A         SYSTEM  1       ; Current sub-pattern position of Channel A
@@POS_B         SYSTEM  1       ; Current sub-pattern position of Channel B
@@POS_C         SYSTEM  1       ; Current sub-pattern position of Channel C

    IF (TRK_ENABLED_6_CHN)
@@POS_D         SYSTEM  1       ; Current sub-pattern position of Channel D
@@POS_E         SYSTEM  1       ; Current sub-pattern position of Channel E
@@POS_F         SYSTEM  1       ; Current sub-pattern position of Channel F
    ENDI
                ENDS

    LISTING "off"

;; ======================================================================== ;;
;;  _b_var(name)                                                            ;;
;;  Returns the address of a byte variable in 8-bit RAM.                    ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      name        The name of the variable field in the RAM block.        ;;
;; ======================================================================== ;;
MACRO   _b_var(name)
    TRK_BYTEVAR.%name%
ENDM

;; ======================================================================== ;;
;;  _w_var(name)                                                            ;;
;;  Returns the address of a word variable in 16-bit RAM.                   ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      name        The name of the variable field in the RAM block.        ;;
;; ======================================================================== ;;
MACRO   _w_var(name)
    TRK_WORDVAR.%name%
ENDM

;; ======================================================================== ;;
;;  _b_vardlt(bvar1, bvar2)                                                 ;;
;;  Returns an offset representing the distance between two byte variables  ;;
;;  in the 8-bit RAM block.                                                 ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      bvar1       The name of the source byte variable.                   ;;
;;      bvar2       The name of the target byte variable.                   ;;
;; ======================================================================== ;;
MACRO   _b_vardlt(bvar1, bvar2)
    ((_b_var(%bvar2%) - _b_var(%bvar1%)) AND $FFFF)
ENDM

;; ======================================================================== ;;
;;  _bw_vardlt(bvar, wvar)                                                  ;;
;;  Returns an offset representing the distance between a byte and a word   ;;
;;  variable.                                                               ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      bvar         The name of the source byte variable.                  ;;
;;      wvar         The name of the target word variable.                  ;;
;; ======================================================================== ;;
MACRO   _bw_vardlt(bvar, wvar)
    ((_w_var(%wvar%) - _b_var(%bvar%)) AND $FFFF)
ENDM

;; ======================================================================== ;;
;;  _wb_vardlt(wvar, bvar)                                                  ;;
;;  Returns an offset representing the distance between a word and a byte   ;;
;;  variable.                                                               ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      wvar         The name of the source word variable.                  ;;
;;      bvar         The name of the target byte variable.                  ;;
;; ======================================================================== ;;
MACRO   _wb_vardlt(wvar, bvar)
    ((_b_var(%bvar%) - _w_var(%wvar%)) AND $FFFF)
ENDM

    LISTING "prev"

;; ======================================================================== ;;
;;  End of File:  asm-memmap.asm                                            ;;
;; ======================================================================== ;;
