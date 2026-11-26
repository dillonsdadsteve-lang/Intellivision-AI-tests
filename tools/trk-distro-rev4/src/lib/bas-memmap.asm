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

_trk.idx    QSET    0

;; ======================================================================== ;;
MACRO   _resetidx
;
_trk.idx    QSET 0
ENDM

;; ======================================================================== ;;
MACRO   _nextidx
    _trk.idx
_trk.idx    QSET (_trk.idx + 1)
ENDM

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
;;      The variables are defined in IntyBASIC as arrays, and the macros    ;;
;;      below serve to map their addresses to the symbolic labels utilized  ;;
;;      by the tracker routines.                                            ;;
;;                                                                          ;;
;;      The reason this is necessary is because IntyBASIC defines all its   ;;
;;      variable symbols at the end of the program, and so they are not     ;;
;;      available to the assembler pre-processor.  Wrapping them in macros  ;;
;;      allows the assembler to resolve them on its second pass.            ;;
;; ======================================================================== ;;


                _resetidx
CHN_STATE       EQU     _nextidx       ; Channel active state
MASTER_FADER    EQU     _nextidx

TRK_BYTEVAR.START EQU   _trk.idx

REF_M           EQU     _nextidx       ; Global song refresh counter (counts down to next row)
COUNT_M         EQU     _nextidx       ; Global music counter
COUNT_P         EQU     _nextidx       ; Pattern counter (counts down pattern length)
PAT             EQU     _nextidx       ; Index of current pattern in patterns table

; CHANNEL NOTES:
; ------------------------------
NOTE_A          EQU     _nextidx       ; Current Channel A note
NOTE_B          EQU     _nextidx       ; Current Channel B note
NOTE_C          EQU     _nextidx       ; Current Channel C note

    IF (TRK_ENABLED_6_CHN)
NOTE_D          EQU     _nextidx       ; Current Channel D note
NOTE_E          EQU     _nextidx       ; Current Channel E note
NOTE_F          EQU     _nextidx       ; Current Channel F note
    ENDI

; CHANNEL NOTE COUNTERS
; ------------------------------
REF_A           EQU     _nextidx       ; Channel A note refresh counter (<< 4: counts down to next note event)
REF_B           EQU     _nextidx       ; Channel B note refresh counter (<< 4: counts down to next note event)
REF_C           EQU     _nextidx       ; Channel C note refresh counter (<< 4: counts down to next note event)

    IF (TRK_ENABLED_6_CHN)
REF_D           EQU     _nextidx       ; Channel D note refresh counter (<< 4: counts down to next note event)
REF_E           EQU     _nextidx       ; Channel E note refresh counter (<< 4: counts down to next note event)
REF_F           EQU     _nextidx       ; Channel F note refresh counter (<< 4: counts down to next note event)
    ENDI

; CHANNEL VOLUME:
; ------------------------------
VOL_A           EQU     _nextidx       ; Channel A volume (complemented: ~(Volume))
VOL_B           EQU     _nextidx       ; Channel B volume (complemented: ~(Volume))
VOL_C           EQU     _nextidx       ; Channel C volume (complemented: ~(Volume))

    IF (TRK_ENABLED_6_CHN)
VOL_D           EQU     _nextidx       ; Channel D volume (complemented: ~(Volume))
VOL_E           EQU     _nextidx       ; Channel E volume (complemented: ~(Volume))
VOL_F           EQU     _nextidx       ; Channel F volume (complemented: ~(Volume))
    ENDI

; CHANNEL INSTRUMENTS:
; ------------------------------
INSTR_A         EQU     _nextidx       ; Current Channel A instrument
INSTR_B         EQU     _nextidx       ; Current Channel B instrument
INSTR_C         EQU     _nextidx       ; Current Channel C instrument

    IF (TRK_ENABLED_6_CHN)
INSTR_D         EQU     _nextidx       ; Current Channel D instrument
INSTR_E         EQU     _nextidx       ; Current Channel E instrument
INSTR_F         EQU     _nextidx       ; Current Channel F instrument
    ENDI

; CHANNEL LOCAL COUNTER
; ------------------------------
COUNT_A         EQU     _nextidx       ; Channel A counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)
COUNT_B         EQU     _nextidx       ; Channel B counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)
COUNT_C         EQU     _nextidx       ; Channel C counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)

    IF (TRK_ENABLED_6_CHN)
COUNT_D         EQU     _nextidx       ; Channel E counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)
COUNT_E         EQU     _nextidx       ; Channel E counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)
COUNT_F         EQU     _nextidx       ; Channel F counter local counter (counts $00..$FF, or until note duration, for use by pitch effects)
    ENDI

TRK_BYTEVAR.SIZE EQU    (_trk.idx - TRK_BYTEVAR.START)

; GLOBAL TRACKER CONFIGURATION:
; ------------------------------
                _resetidx
SONG            EQU     _nextidx       ; Pointer to song
INS_PTR         EQU     _nextidx       ; Pointer to instruments table

; CHANNEL PATTERN POSITIONS:
; ------------------------------
POS_A           EQU     _nextidx       ; Current pattern position of Channel A
POS_B           EQU     _nextidx       ; Current pattern position of Channel B
POS_C           EQU     _nextidx       ; Current pattern position of Channel C

    IF (TRK_ENABLED_6_CHN)
POS_D           EQU     _nextidx       ; Current pattern position of Channel D
POS_E           EQU     _nextidx       ; Current pattern position of Channel E
POS_F           EQU     _nextidx       ; Current pattern position of Channel F
    ENDI

;; ======================================================================== ;;
;; Primary PSG in the main console.                                         ;;
;; ======================================================================== ;;
PSG0            STRUCT  $01F0

                ;;----------------------------------------------------------;;
                ;; Register address definitions                             ;;
                ;;----------------------------------------------------------;;
@@chn_a_lo      QEQU    $ + 0   ; Channel A period, lower 8 bits of 12
@@chn_b_lo      QEQU    $ + 1   ; Channel B period, lower 8 bits of 12
@@chn_c_lo      QEQU    $ + 2   ; Channel C period, lower 8 bits of 12

@@chan_enable   QEQU    $ + 8   ; Channel enables (bits 3-5 noise, 0-2 tone)
                ENDS

;; ======================================================================== ;;
;; Secondary PSG in the expansion unit.                                     ;;
;; ======================================================================== ;;
PSG1            STRUCT  $00F0

                ;;----------------------------------------------------------;;
                ;; Register address definitions                             ;;
                ;;----------------------------------------------------------;;
@@chn_a_lo      QEQU    $ + 0   ; Channel A period, lower 8 bits of 12
@@chn_b_lo      QEQU    $ + 1   ; Channel B period, lower 8 bits of 12
@@chn_c_lo      QEQU    $ + 2   ; Channel C period, lower 8 bits of 12

@@chan_enable   QEQU    $ + 8   ; Channel enables (bits 3-5 noise, 0-2 tone)
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
    (array_TRK_BYTEVAR + %name%)
ENDM

;; ======================================================================== ;;
;;  _w_var(name)                                                            ;;
;;  Returns the address of a word variable in 16-bit RAM.                   ;;
;;                                                                          ;;
;;  ARGUMENTS                                                               ;;
;;      name        The name of the variable field in the RAM block.        ;;
;; ======================================================================== ;;
MACRO   _w_var(name)
    (array_&TRK_WORDVAR + %name%)
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
;;  End of File:  bas-memmap.asm                                            ;;
;; ======================================================================== ;;
