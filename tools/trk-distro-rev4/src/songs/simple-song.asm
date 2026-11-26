;; ======================================================================== ;;
;;  SONG: Simple Song                                                       ;;
;;      Typically these elements are defined globally and made available to ;;
;;      all songs, but for this example we include it here to illustrate a  ;;
;;      complete an self-contained song.                                    ;;
;; ======================================================================== ;;
SIMPLEMUSIC PROC

;; ------------------------------------------------------------------------ ;;
;;  Pitch effects                                                           ;;
;; ------------------------------------------------------------------------ ;;
@@pitch01:  DECLE   0, 0, 0, 0      ; No effect
@@pitch02:  DECLE   0, 0, 12, 12    ; Alternate octaves every 2 ticks

;; ------------------------------------------------------------------------ ;;
;;  Envelopes                                                               ;;
;; ------------------------------------------------------------------------ ;;
@@env01:    DECLE   1   ; Speed #1: 4 ticks per sample
            DECLE   $FFFF, $EEEE, $DDDD, $CCCC  ; Sharp attack, long decay
            DECLE   $BBBB, $AAAA, $9999, $8888
            DECLE   $7777, $6666, $5555, $4444
            DECLE   $3333, $2222, $1111, $0000

@@env02:    DECLE   2   ; Speed #2: 8 ticks per sample
            DECLE   $FEDC, $BA98, $7654, $3210  ; Sharp attack, short decay
            DECLE   $0000, $0000, $0000, $0000
            DECLE   $0000, $0000, $0000, $0000
            DECLE   $0000, $0000, $0000, $0000

;; ------------------------------------------------------------------------ ;;
;;  Drums                                                                   ;;
;; ----------------------------------------------------------------------—- ;;
@@bassdrum: DRUM($000, $10, 0, 1, $F)	; Step #1: Start with noise
            DRUM($380, $00, 1, 0, $F)	; Step #2: Settle on tone
            DRUM($380, $00, 1, 0, $F)	;
            DRUM($480, $00, 1, 0, $E)	; Step #4: Start decaying ...
            DRUM($480, $00, 1, 0, $D)	;          and detuning
            DRUM($580, $00, 1, 0, $C)	;
            DRUM($580, $00, 1, 0, $A)	;
            DRUM($580, $00, 1, 0, $8)	;
            DRUM($000, $00, 0, 0, $0)	; Step #9: End instrument sound
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	;
            DRUM($000, $00, 0, 0, $0)	; Step #16: End definition

;; ----------------------------------------------------------------------—- ;;
            ENDP
;; ----------------------------------------------------------------------—- ;;

;; ======================================================================== ;;
;;  SONG: Simple Song                                                       ;;
;;      These are the elements used in “Simple Song,” which includes        ;;
;;      references to the global elements defined in the “SIMPLEMUSIC”      ;;
;;      data structure.                                                     ;;
;; ======================================================================== ;;
SIMPLESONG      PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;
                DECLE   6, @@patterns, @@instr, @@drums ; Speed: 6 ticks per row

; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
@@sequence:     DECLE   0, 1, 1, 2, 3, 2, 3, 0, -8   ; Play patterns, repeat

; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;
                ;       Len    A       B       C       D       E      F
                ;       --- ------- ------- ------- ------- ------- ------ 
@@patterns:     DECLE   32, @@p000, @@pXXX, @@pXXX, @@pXXX, @@pXXX, @@pXXX ; #0
                DECLE   32, @@p000, @@p002, @@pXXX, @@pXXX, @@pXXX, @@pXXX ; #1
                DECLE   32, @@p000, @@pXXX, @@pXXX, @@p001, @@pXXX, @@pXXX ; #2
                DECLE   32, @@p000, @@p002, @@pXXX, @@p001, @@pXXX, @@pXXX ; #3

; ------------------------------------------------------------------------- ;
;  Instruments & Drum Kit                                                   ;
; ------------------------------------------------------------------------- ;
                ;       Pitch Effect         Vibr  Envelope
                ;       -------------------  ----  -----------------
@@instr:        DECLE   SIMPLEMUSIC.pitch01,  2,   SIMPLEMUSIC.env01    ; #1
                DECLE   SIMPLEMUSIC.pitch02,  2,   SIMPLEMUSIC.env02    ; #2

@@drums:        DECLE   SIMPLEMUSIC.bassdrum                            ; #1

; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
                ; Drums pattern (we only defined one drum in our kit)
@@p000:         NOTES("DRM 1F7", "DRM 1F1", "DRM 1F5", "DRM 1F7")
                NOTES("DRM 1F1", "DRM 1F5", "", "")

                ; Melody #1
@@p001:         NOTES("A-3 1E3", "C-4 1E2", "E-4 1E0", "F-4 1E1")
                NOTES("E-4 1E1", "C-4 1E3", "A-3 1E3", "C-4 1E2")
                NOTES("E-4 1E0", "F-4 1E1", "A-4 1E1", "G-4 1E3")

                ; Melody #2
@@p002:         NOTES("A-5 2F7", "G-5 2F7", "E-5 2F7", "D-5 2F1")
                NOTES("E-5 2F5", "", "", "")

                ; Silence channel throughout entire pattern
@@pXXX:         NOTES("NUL 10F", "NUL 10F", "", "")

;; ----------------------------------------------------------------------—- ;;
                ENDP
;; ----------------------------------------------------------------------—- ;;
