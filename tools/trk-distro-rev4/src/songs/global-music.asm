;* ======================================================================== *;
;*  This code is placed into the public domain by its collective authors.   *;
;*  All copyright rights are hereby relinquished on the code and data in    *;
;*  this file.                                                              *;
;*      -- Arnauld Chevallier, 2018                                         *;
;*      -- James Pujals, 2020                                               *;
;*      -- Anders Carlsson, 2020                                            *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  GLOBAL MUSIC DEFINITIONS                                                ;;
;;      These elements are defined separately and made available to all     ;;
;;      songs in the program.                                               ;;
;;                                                                          ;;
;;  Effects, arpeggios, & envelopes designed by:                            ;;
;;      Arnauld Chevallier, James Pujals, & Anders Carlsson                 ;;
;;                                                                          ;;
;;  Drum sounds synthesized by:                                             ;;
;;      James Pujals, based on work by Arnauld Chevallier                   ;;
;; ======================================================================== ;;
MUSIC           PROC

;; ------------------------------------------------------------------------ ;;
;;  Pitch effects                                                           ;;
;; ------------------------------------------------------------------------ ;;
@@pitch01:      DECLE   0,  0,  0,  0               ; No effect
@@pitch02:      DECLE   0,  0, 12, 12               ; Alternate octaves every 2 ticks
@@pitch03:      DECLE   0,  5,  9, 12

@@pitch04:      DECLE   0,  3,  7, 12               ; fade + immediate
@@pitch05:      DECLE   0,  4,  7, 12               ; fade + immediate
@@pitch06:      DECLE   0,  4, 10, 12               ; fade
@@pitch07:      DECLE   0,  3,  6,  8               ; immediate
@@pitch08:      DECLE   0,  2,  5, 10               ; immediate
@@pitch09:      DECLE   0,  3,  5,  8               ; immediate
@@pitch10:      DECLE   0,  2,  6,  9               ; immediate
@@pitch11:      DECLE   0,  3,  5,  9               ; immediate
@@pitch12:      DECLE   0,  4,  7,  9               ; immediate
@@pitch13:      DECLE   0,  3,  6,  9               ; immediate

@@pitch14:      DECLE   0,  4,  6, 12
@@pitch15:      DECLE   0,  3,  8, 12
@@pitch16:      DECLE   0,  5,  8, 12
@@pitch17:      DECLE   0,  2,  8, 12
@@pitch18:      DECLE   0,  4,  9, 12

@@pitch19:      DECLE   0,  0,  0,  1

;; ------------------------------------------------------------------------ ;;
;;  Envelopes                                                               ;;
;; ------------------------------------------------------------------------ ;;
                ; Sharp attack, slow decay
@@env01:        DECLE   1
                DECLE   $FFFF, $EEEE, $DDDD, $CCCC
                DECLE   $BBBB, $AAAA, $9999, $8888
                DECLE   $7777, $6666, $5555, $4444
                DECLE   $3333, $2222, $1111, $0000

                ; Sharp attack, fast decay
@@env02:        DECLE   3
                DECLE   $FEDC, $BA98, $7654, $3210
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Short-ish bass
@@env03:        DECLE   2
                DECLE   $FEDC, $BA98, $7654, $3210  ; This is the same as @@env02,
                DECLE   $0000, $0000, $0000, $0000  ; but runs at half the speed.
                DECLE   $0000, $0000, $0000, $0000  ; So it takes 32 ticks to decay.
                DECLE   $0000, $0000, $0000, $0000

                ; Long fade arpeggio
@@env04:        DECLE   3
                DECLE   $7799, $BBCC, $DDEE, $FFFF
                DECLE   $FFFF, $FFFF, $FFFF, $FFFF
                DECLE   $FFEE, $DDBB, $9977, $5533
                DECLE   $1100, $0000, $0000, $0000

                ; Short fade arpeggio
@@env05:        DECLE   3
                DECLE   $DDFF, $FFFF, $FFFF, $FFEE
                DECLE   $DDBB, $9977, $5533, $1100
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Long bass, Melody
@@env06:        DECLE   2
                DECLE   $FFFF, $FFFF, $FFFF, $FFFF
                DECLE   $EEEE, $DDDD, $CCCC, $BBBB
                DECLE   $9999, $7777, $5555, $3333
                DECLE   $1111, $0000, $0000, $0000

                ; Sequencer - very short with some sustain
@@env07:        DECLE   3
                DECLE   $FCCC, $8888, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Sequencer 2
@@env08:        DECLE   3
                DECLE   $FCCC, $C888, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Melody 1
@@env09:        DECLE   2
                DECLE   $FFFF, $FFFF, $DDBB, $9977
                DECLE   $5533, $1100, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Melody 2
@@env10:        DECLE   2
                DECLE   $FFFF, $FFFF, $FFFF, $EEEE
                DECLE   $DDDD, $BBBB, $9999, $6666
                DECLE   $3333, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000

                ; Melody 3
@@env11:        DECLE   2
                DECLE   $DEFF, $EEDD, $CCCC, $BBBB
                DECLE   $AAAA, $9988, $6655, $3322
                DECLE   $2211, $0000, $0000, $0000
                DECLE   $0000, $0000, $0000, $0000


; ------------------------------------------------------------------------- ;
;  Drums Definition                                                         ;
; ------------------------------------------------------------------------- ;

                ; --------------------------
                ; Basic Drums
                ;   Synthesized by: DZ-Jay
                ; --------------------------
@@bassdrum:     DRUM($000, $10, 0, 1, $F)
                DRUM($380, $00, 1, 0, $F)
                DRUM($380, $00, 1, 0, $F)
                DRUM($480, $00, 1, 0, $E)
                DRUM($480, $00, 1, 0, $D)
                DRUM($580, $00, 1, 0, $C)
                DRUM($580, $00, 1, 0, $A)
                DRUM($580, $00, 1, 0, $8)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@snare:        DRUM($000, $08, 0, 1, $F)
                DRUM($280, $08, 1, 1, $F)
                DRUM($280, $08, 1, 1, $F)
                DRUM($480, $04, 1, 1, $E)
                DRUM($480, $00, 1, 0, $E)
                DRUM($480, $00, 1, 0, $D)
                DRUM($000, $00, 0, 0, $C)
                DRUM($480, $04, 1, 1, $B)
                DRUM($000, $04, 0, 1, $A)
                DRUM($000, $08, 0, 1, $8)
                DRUM($000, $00, 0, 0, $6)
                DRUM($000, $00, 0, 0, $2)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@hh_closed:    DRUM($000, $04, 0, 1, $F)
                DRUM($000, $04, 0, 1, $D)
                DRUM($000, $04, 0, 1, $8)
                DRUM($000, $04, 0, 1, $6)
                DRUM($000, $04, 0, 1, $4)
                DRUM($000, $04, 0, 1, $3)
                DRUM($000, $04, 0, 1, $2)
                DRUM($000, $04, 0, 1, $1)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@hh_half:      DRUM($000, $04, 0, 1, $D)
                DRUM($000, $04, 0, 1, $B)
                DRUM($000, $04, 0, 1, $C)
                DRUM($000, $04, 0, 1, $9)
                DRUM($000, $04, 0, 1, $7)
                DRUM($000, $04, 0, 1, $5)
                DRUM($000, $04, 0, 1, $3)
                DRUM($000, $04, 0, 1, $2)
                DRUM($000, $04, 0, 1, $2)
                DRUM($000, $04, 0, 1, $1)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@hh_open:      DRUM($000, $04, 0, 1, $E)
                DRUM($000, $04, 0, 1, $E)
                DRUM($000, $04, 0, 1, $C)
                DRUM($000, $04, 0, 1, $D)
                DRUM($000, $03, 0, 1, $C)
                DRUM($000, $03, 0, 1, $C)
                DRUM($000, $03, 0, 1, $B)
                DRUM($000, $03, 0, 1, $C)
                DRUM($000, $03, 0, 1, $B)
                DRUM($000, $03, 0, 1, $B)
                DRUM($000, $02, 0, 1, $A)
                DRUM($000, $02, 0, 1, $A)
                DRUM($000, $02, 0, 1, $9)
                DRUM($000, $02, 0, 1, $8)
                DRUM($000, $02, 0, 1, $7)
                DRUM($000, $02, 0, 1, $6)

@@hh_dbl_tap:   DRUM($000, $04, 0, 1, $D)   ; Double-hit hi-hat tap
                DRUM($000, $04, 0, 1, $B)
                DRUM($000, $04, 0, 1, $8)
                DRUM($000, $01, 0, 1, $6)
                DRUM($000, $01, 0, 1, $4)
                DRUM($000, $01, 0, 1, $3)
                DRUM($000, $04, 0, 1, $B)
                DRUM($000, $04, 0, 1, $8)
                DRUM($000, $04, 0, 1, $6)
                DRUM($000, $01, 0, 1, $4)
                DRUM($000, $01, 0, 1, $3)
                DRUM($000, $01, 0, 1, $2)
                DRUM($000, $01, 0, 1, $1)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@clave:        DRUM($090, $0F, 1, 1, $F)
                DRUM($090, $04, 1, 1, $F)
                DRUM($090, $0F, 1, 1, $B)
                DRUM($090, $04, 1, 1, $A)
                DRUM($090, $0F, 1, 1, $9)
                DRUM($090, $04, 1, 1, $8)
                DRUM($091, $0F, 1, 1, $7)
                DRUM($092, $00, 1, 0, $6)
                DRUM($093, $00, 1, 0, $5)
                DRUM($094, $00, 1, 0, $4)
                DRUM($095, $00, 1, 0, $3)
                DRUM($096, $00, 1, 0, $2)
                DRUM($097, $00, 1, 0, $1)
                DRUM($097, $00, 0, 0, $0)
                DRUM($097, $00, 0, 0, $0)
                DRUM($097, $00, 0, 0, $0)

@@cowbell:      DRUM($100, $0F, 1, 1, $F)
                DRUM($105, $04, 1, 1, $F)
                DRUM($110, $00, 1, 0, $B)
                DRUM($110, $00, 1, 0, $A)
                DRUM($110, $00, 1, 0, $9)
                DRUM($112, $00, 1, 0, $8)
                DRUM($114, $00, 1, 0, $7)
                DRUM($115, $00, 1, 0, $6)
                DRUM($116, $00, 1, 0, $5)
                DRUM($117, $00, 1, 0, $4)
                DRUM($118, $00, 1, 0, $3)
                DRUM($119, $00, 1, 0, $2)
                DRUM($120, $00, 1, 0, $1)
                DRUM($120, $00, 0, 0, $0)
                DRUM($120, $00, 0, 0, $0)
                DRUM($120, $00, 0, 0, $0)

                ; --------------------------
                ; TR-808(ish) Drums
                ;   Synthesized by: DZ-Jay
                ; --------------------------
@@808_kick_sh:  DRUM($45E, $1A, 1, 1, $F)   ; ~100 Hz
                DRUM($45E, $00, 1, 0, $F)   ;   |   Basic TR-808 Kick, detuned by ~3 Hz
                DRUM($47B, $00, 1, 0, $E)   ;   |
                DRUM($47B, $00, 1, 0, $C)   ;   |
                DRUM($47B, $00, 1, 0, $9)   ;   |
                DRUM($499, $00, 1, 0, $7)   ;   |
                DRUM($499, $00, 1, 0, $5)   ;   |
                DRUM($499, $00, 1, 0, $3)   ;   |
                DRUM($499, $00, 1, 0, $2)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   |
                DRUM($499, $00, 0, 0, $0)   ;   v
                DRUM($499, $00, 0, 0, $0)   ; ~48 Hz

@@808_kick:     DRUM($88D, $1A, 1, 1, $F)   ; ~51 Hz
                DRUM($88D, $00, 1, 0, $F)   ;   |   Basic TR-808 Kick, detuned by ~3 Hz
                DRUM($8AD, $00, 1, 0, $F)   ;   |
                DRUM($8AD, $00, 1, 0, $E)   ;   |
                DRUM($8BD, $00, 1, 0, $D)   ;   |
                DRUM($8BD, $00, 1, 0, $C)   ;   |
                DRUM($8CD, $00, 1, 0, $A)   ;   |
                DRUM($8CD, $00, 1, 0, $9)   ;   |
                DRUM($8DD, $00, 1, 0, $8)   ;   |
                DRUM($8DD, $00, 1, 0, $7)   ;   |
                DRUM($8ED, $00, 1, 0, $6)   ;   |
                DRUM($8ED, $00, 1, 0, $5)   ;   |
                DRUM($8F0, $00, 1, 0, $4)   ;   |
                DRUM($8FC, $00, 1, 0, $3)   ;   |
                DRUM($8FC, $00, 1, 0, $2)   ;   v
                DRUM($8FC, $00, 1, 0, $1)   ; ~48 Hz

@@808_kick_low: DRUM($88D, $1A, 1, 1, $F)   ; ~51 Hz
                DRUM($88D, $00, 1, 0, $F)   ;   |   Same TR-808 Kick, but detuned by ~10 Hz
                DRUM($8D8, $00, 1, 0, $F)   ;   |     This sound plays nicely along a C-1
                DRUM($924, $00, 1, 0, $E)   ;   |     tone with a long decay (env02), to mimic
                DRUM($924, $00, 1, 0, $D)   ;   |     the classic TR-808 deep kick drum.
                DRUM($96F, $00, 1, 0, $C)   ;   |
                DRUM($96F, $00, 1, 0, $A)   ;   v
                DRUM($9BC, $00, 1, 0, $9)   ; ~44 Hz
                DRUM($9BC, $00, 1, 0, $8)   ;   |
                DRUM($A07, $00, 1, 0, $7)   ;   |
                DRUM($A07, $00, 1, 0, $6)   ;   |
                DRUM($AEB, $00, 1, 0, $5)   ;   |
                DRUM($AEB, $00, 1, 0, $4)   ;   |
                DRUM($AEC, $00, 1, 0, $3)   ;   |
                DRUM($AEC, $00, 1, 0, $2)   ;   v
                DRUM($AEC, $00, 1, 0, $1)   ; ~40 Hz

@@808_snare:    DRUM($500, $08, 1, 1, $F)
                DRUM($000, $08, 0, 1, $F)
                DRUM($000, $08, 0, 1, $E)
                DRUM($000, $07, 0, 1, $D)
                DRUM($000, $07, 0, 1, $C)
                DRUM($000, $07, 0, 1, $B)
                DRUM($000, $06, 0, 1, $A)
                DRUM($000, $06, 0, 1, $9)
                DRUM($000, $06, 0, 1, $8)
                DRUM($000, $08, 0, 1, $7)
                DRUM($000, $08, 0, 1, $6)
                DRUM($000, $08, 0, 1, $4)
                DRUM($000, $08, 0, 1, $2)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@808_snare_sh: DRUM($500, $08, 1, 1, $F)
                DRUM($000, $08, 0, 1, $F)
                DRUM($000, $08, 0, 1, $E)
                DRUM($000, $07, 0, 1, $B)
                DRUM($000, $07, 0, 1, $8)
                DRUM($000, $07, 0, 1, $6)
                DRUM($000, $06, 0, 1, $6)
                DRUM($000, $06, 0, 1, $6)
                DRUM($000, $06, 0, 1, $5)
                DRUM($000, $08, 0, 1, $4)
                DRUM($000, $08, 0, 1, $2)
                DRUM($000, $08, 0, 1, $2)
                DRUM($000, $08, 0, 1, $1)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@808_hh_c:     DRUM($015, $04, 1, 1, $F)
                DRUM($015, $04, 1, 1, $D)
                DRUM($015, $03, 1, 1, $A)
                DRUM($015, $03, 1, 1, $8)
                DRUM($015, $03, 1, 1, $6)
                DRUM($000, $03, 0, 1, $6)
                DRUM($015, $03, 1, 1, $4)
                DRUM($015, $03, 0, 1, $2)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)
                DRUM($000, $00, 0, 0, $0)

@@808_hh_o:     DRUM($015, $04, 1, 1, $D)
                DRUM($015, $04, 1, 1, $D)
                DRUM($015, $03, 1, 1, $D)
                DRUM($015, $03, 1, 1, $E)
                DRUM($015, $03, 1, 1, $D)
                DRUM($015, $03, 1, 1, $E)
                DRUM($000, $03, 0, 1, $B)
                DRUM($015, $03, 1, 1, $D)
                DRUM($000, $03, 0, 1, $B)
                DRUM($015, $03, 1, 1, $A)
                DRUM($000, $03, 0, 1, $A)
                DRUM($015, $02, 1, 1, $9)
                DRUM($000, $02, 0, 1, $8)
                DRUM($000, $02, 0, 1, $7)
                DRUM($000, $02, 0, 1, $6)
                DRUM($000, $02, 0, 1, $4)

@@808_clave:    DRUM($02E, $00, 1, 0, $F)   ; Classic TR-808 Clave:
                DRUM($02E, $00, 1, 0, $B)   ;   It should really be a sine or triangle wave,
                DRUM($02E, $00, 1, 0, $8)   ;   but beggars can't be choosers ...
                DRUM($02E, $00, 1, 0, $7)   ;
                DRUM($02E, $00, 1, 0, $6)   ;   Played on a square wave on something in
                DRUM($02E, $00, 1, 0, $5)   ;   between a D-7 and a D#7 (~2.43 KHz), with an
                DRUM($02E, $00, 1, 0, $4)   ;   ultra-fast decay.
                DRUM($02E, $00, 1, 0, $4)   ;
                DRUM($02E, $00, 1, 0, $4)   ;
                DRUM($02E, $00, 1, 0, $3)   ;
                DRUM($02E, $00, 1, 0, $3)   ;
                DRUM($02E, $00, 1, 0, $3)   ;
                DRUM($02E, $00, 1, 0, $2)   ;
                DRUM($02E, $00, 1, 0, $2)   ;
                DRUM($02E, $00, 1, 0, $1)   ;
                DRUM($02E, $00, 1, 0, $1)   ;

@@808_cowb_hi:  DRUM($08C, $00, 1, 0, $F)   ; Classic TR-808 Cowbell:
                DRUM($08C, $00, 1, 0, $D)   ;   It requires two tones simultaneously, and
                DRUM($08C, $00, 1, 0, $B)   ;   multiplexing them did not produce the desired
                DRUM($08C, $00, 1, 0, $A)   ;   effect.  Therefore, I broke it down into
                DRUM($08C, $00, 1, 0, $9)   ;   two "instruments," each one producing one
                DRUM($08C, $00, 1, 0, $8)   ;   tone.  They could be played simultaneously
                DRUM($08C, $00, 1, 0, $7)   ;   on the A and D drum channels.
                DRUM($08C, $00, 1, 0, $6)   ;
                DRUM($08C, $00, 1, 0, $6)   ;   High tone:  ~800 Hz
                DRUM($08C, $00, 1, 0, $5)   ;   |
                DRUM($08C, $00, 1, 0, $5)   ;   |
                DRUM($08C, $00, 1, 0, $5)   ;   |
                DRUM($08C, $00, 1, 0, $4)   ;   |
                DRUM($08C, $00, 1, 0, $4)   ;   |
                DRUM($08C, $00, 1, 0, $4)   ;   |
                DRUM($08C, $00, 1, 0, $3)   ;   v

@@808_cowb_lo:  DRUM($0CF, $00, 1, 0, $F)   ;   Low tone:  ~540 Hz
                DRUM($0CF, $00, 1, 0, $D)
                DRUM($0CF, $00, 1, 0, $B)
                DRUM($0CF, $00, 1, 0, $A)
                DRUM($0CF, $00, 1, 0, $9)
                DRUM($0CF, $00, 1, 0, $8)
                DRUM($0CF, $00, 1, 0, $7)
                DRUM($0CF, $00, 1, 0, $6)
                DRUM($0CF, $00, 1, 0, $6)
                DRUM($0CF, $00, 1, 0, $5)
                DRUM($0CF, $00, 1, 0, $5)
                DRUM($0CF, $00, 1, 0, $5)
                DRUM($0CF, $00, 1, 0, $4)
                DRUM($0CF, $00, 1, 0, $4)
                DRUM($0CF, $00, 1, 0, $4)
                DRUM($0CF, $00, 1, 0, $3)

@@808_clap_lo:  DRUM($000, $10, 0, 1, $C)
                DRUM($000, $10, 0, 1, $E)
                DRUM($000, $10, 0, 1, $D)
                DRUM($000, $10, 0, 1, $F)
                DRUM($000, $1F, 0, 1, $D)
                DRUM($000, $1F, 0, 1, $C)
                DRUM($000, $1F, 0, 1, $B)
                DRUM($000, $1F, 0, 1, $A)
                DRUM($000, $1F, 0, 1, $9)
                DRUM($000, $1F, 0, 1, $8)
                DRUM($000, $1F, 0, 1, $7)
                DRUM($000, $1F, 0, 1, $6)
                DRUM($000, $1F, 0, 1, $5)
                DRUM($000, $1F, 0, 1, $4)
                DRUM($000, $1F, 0, 1, $2)
                DRUM($000, $1F, 0, 1, $1)

;; ----------------------------------------------------------------------—- ;;
                ENDP
;; ----------------------------------------------------------------------—- ;;
