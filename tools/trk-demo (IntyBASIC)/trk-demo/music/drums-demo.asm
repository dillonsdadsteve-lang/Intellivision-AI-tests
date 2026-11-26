;* ======================================================================== *;
;*  This code is placed into the public domain by its collective authors.   *;
;*  All copyright rights are hereby relinquished on the code and data in    *;
;*  this file.                                                              *;
;*      -- James Pujals, 2020                                               *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  SONG: Drums Demo (Funk My Drum Machine)                                 ;;
;;      This is an illustration of the Intellivision Music Tracker's        ;;
;;      capabilities for synthesizing and playing drum sounds.  It is also  ;;
;;      an excuse to showcase the TR-808(ish) sounds in a badass drum track.;;
;;                                                                          ;;
;;      Composed By:    James Pujals (DZ-Jay)                               ;;
;;      Tracked By:     James Pujals (DZ-Jay)                               ;;
;; ======================================================================== ;;
DRUMS_DEMO  PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;
            ; You can play this song with one of two drumkits:
            ;   @@tr808     - TR-808(ish) electronic drum kit
            ;   @@drumkit   - Standard drum kit
            ;
            ;   The standard drum kit sounds good, but this track
            ;   was designed for the TR-808(ish). ;)
            DECLE   3, @@patterns, @@instr, @@tr808

            ;   (If you switch drum kits, remember to silence the
            ;   "B" channel, which plays a deep bass to accompany
            ;   the TR-808(ish) kick drum.)

; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
            DECLE    0,  1,  0,  1,  2,  3,  4,  5      ; Intro
            DECLE    6,  7,  6,  7,  8,  7,  8,  9      ; Main beat  <--------------,
            DECLE   10, 11, 10, 11, 12, 11, 12, 13      ; Funky beat with clave     |
            DECLE   14, 15,  4, 16, 14, 15,  4,  5      ; Break                     |
            DECLE   17, 11, 17, 21, 17, 11, 19, 21      ; Funky beat with cowbell   |
            DECLE   17, 18, 19, 20, 17, 18, 19, 22      ; Funky beat reprise        |
            DECLE   -40                                 ; Rinse, repeat ------------'

; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;

            ; NOTE:
            ;   Although only three tracks are used, this demo requires
            ;   the ECS in order to play drums on the "A" channel of
            ;   each PSG.
            ;
            ;   The main kick & snare beat is on track "A," accompanied
            ;   by a deep bass tone on track "B" to give the TR-808(ish)
            ;   its characteristic low edge.  Track "D" plays the filler
            ;   sounds of hi-hats and other effects.

            ;              A       B       C       D       E       F
            ;           Drums1   Bass   Unused  Drums2  Unused  Unused
            ;           ------  ------  ------  ------  ------  ------
@@patterns: DECLE   48, @@pk01, @@pd01, @@pXXX, @@pXXX, @@pXXX, @@pXXX  ; #0
            DECLE   48, @@pk02, @@pd12, @@pXXX, @@pXXX, @@pXXX, @@pXXX  ; #1
            DECLE   48, @@pk03, @@pd03, @@pXXX, @@ph00, @@pXXX, @@pXXX  ; #2

            DECLE   48, @@pk01, @@pd01, @@pXXX, @@ph11, @@pXXX, @@pXXX  ; #3
            DECLE   48, @@pk03, @@pd03, @@pXXX, @@ph13, @@pXXX, @@pXXX  ; #4
            DECLE   48, @@pk04, @@pd04, @@pXXX, @@ph14, @@pXXX, @@pXXX  ; #5

            DECLE   48, @@pb01, @@pd01, @@pXXX, @@ph01, @@pXXX, @@pXXX  ; #6
            DECLE   48, @@pb02, @@pd02, @@pXXX, @@ph02, @@pXXX, @@pXXX  ; #7
            DECLE   48, @@pb03, @@pd03, @@pXXX, @@ph03, @@pXXX, @@pXXX  ; #8
            DECLE   48, @@pb04, @@pd04, @@pXXX, @@ph04, @@pXXX, @@pXXX  ; #9

            DECLE   48, @@pf01, @@pd01, @@pXXX, @@ph01, @@pXXX, @@pXXX  ; #10
            DECLE   48, @@pf02, @@pd02, @@pXXX, @@ph02, @@pXXX, @@pXXX  ; #11
            DECLE   48, @@pf03, @@pd03, @@pXXX, @@ph03, @@pXXX, @@pXXX  ; #12
            DECLE   48, @@pf04, @@pd04, @@pXXX, @@ph04, @@pXXX, @@pXXX  ; #13

            DECLE   48, @@pk01, @@pd01, @@pXXX, @@ph10, @@pXXX, @@pXXX  ; #14
            DECLE   48, @@pk02, @@pd12, @@pXXX, @@ph12, @@pXXX, @@pXXX  ; #15
            DECLE   48, @@pk14, @@pd14, @@pXXX, @@ph14, @@pXXX, @@pXXX  ; #16

            DECLE   48, @@pf21, @@pd01, @@pXXX, @@ph21, @@pXXX, @@pXXX  ; #17
            DECLE   48, @@pf22, @@pd22, @@pXXX, @@ph22, @@pXXX, @@pXXX  ; #18
            DECLE   48, @@pf23, @@pd03, @@pXXX, @@ph23, @@pXXX, @@pXXX  ; #19
            DECLE   48, @@pf24, @@pd24, @@pXXX, @@ph24, @@pXXX, @@pXXX  ; #20

            DECLE   48, @@pf32, @@pd32, @@pXXX, @@ph22, @@pXXX, @@pXXX  ; #21
            DECLE   48, @@pf34, @@pd34, @@pXXX, @@ph24, @@pXXX, @@pXXX  ; #22

; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
@@instr:    DECLE   MUSIC.pitch01, 0, MUSIC.env02   ; #1

; ------------------------------------------------------------------------- ;
;  Drum Kit                                                                 ;
; ------------------------------------------------------------------------- ;
            ; Standard Drum Kit
            ; --------------------------------------
@@drumkit:  DECLE   MUSIC.bassdrum                  ; #1
            DECLE   MUSIC.snare                     ; #2
            DECLE   MUSIC.hh_closed                 ; #3
            DECLE   MUSIC.hh_open                   ; #4
            DECLE   MUSIC.cowbell                   ; #5
            DECLE   MUSIC.clave                     ; #6
            DECLE   MUSIC.cowbell                   ; #7

            ; TR-808(ish) Electronic Drum Kit
            ; --------------------------------------
@@tr808:    DECLE   MUSIC.808_kick_low              ; #1
            DECLE   MUSIC.808_snare                 ; #2
            DECLE   MUSIC.808_hh_c                  ; #3
            DECLE   MUSIC.808_hh_o                  ; #4
            DECLE   MUSIC.808_clave                 ; #5
            DECLE   MUSIC.808_cowb_hi               ; #6
            DECLE   MUSIC.808_cowb_lo               ; #7

; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
            ; Full pattern silence
            ; -----------------------------------------------
@@pXXX:     NOTES("NUL 10F", "NUL 00F", "NUL 00F", "NUL 00F")

            ; NOTE:
            ;   Although the following patterns could be
            ;   compressed using RLE by only including the
            ;   relevant event rows, it turns out that
            ;   unrolling the entire pattern and including
            ;   every row makes composing and editing drums
            ;   a lot easier.
            ;
            ;   This way, I can place an individual sound on
            ;   the appropriate row, quantizing the beat by
            ;   hand, without having to think about it.
            ;
            ;   Pattern:
            ;       64 rows
            ;       16 beats
            ;       4 rows per beat

            ; pb##: Basic beat (kick/snare)
            ; -----------------------------------------------
@@pb01: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("NUL 000") ; #09 - 4
            NPK.Note("NUL 000") ; #10
            NPK.Note("NUL 000") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@pb02: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("DRM 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pb03: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("NUL 000") ; #09 - 4
            NPK.Note("NUL 000") ; #10
            NPK.Note("NUL 000") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 1E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pb04: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 2F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

            ; pk##: Kick only
            ; -----------------------------------------------
@@pk01: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("NUL 000") ; #09 - 4
            NPK.Note("NUL 000") ; #10
            NPK.Note("NUL 000") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 000") ; #36 - 1
            NPK.Note("NUL 000") ; #37
            NPK.Note("NUL 000") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@pk02: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pk03: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("NUL 000") ; #09 - 4
            NPK.Note("NUL 000") ; #10
            NPK.Note("NUL 000") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 000") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 1E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pk04: NPK.Begin(48)   
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("DRM 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 2F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pk14: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 5F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 5F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 5F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

            ; ph## Hi-hat rhythm
            ; -----------------------------------------------
@@ph00: NPK.Begin(48)
            NPK.Note("DRM 4F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 4A0") ; #03 - 2
            NPK.Note("NUL 0A0") ; #04
            NPK.Note("NUL 0A0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("NUL 0E0") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@ph01: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("NUL 0E0") ; #43
            NPK.Note("NUL 0E0") ; #44
            NPK.Note("DRM 3B0") ; #45 - 4
            NPK.Note("NUL 0B0") ; #46
            NPK.Note("NUL 0B0") ; #47
        NPK.End

@@ph02: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3C0") ; #15 - 2
            NPK.Note("DRM 3B0") ; #16
            NPK.Note("DRM 3B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3B0") ; #21 - 4
            NPK.Note("NUL 0B0") ; #22
            NPK.Note("NUL 0B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("DRM 3C0") ; #43
            NPK.Note("DRM 3C0") ; #44
            NPK.Note("DRM 4F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@ph03: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("NUL 0E0") ; #43
            NPK.Note("NUL 0E0") ; #44
            NPK.Note("DRM 3B0") ; #45 - 4
            NPK.Note("NUL 0B0") ; #46
            NPK.Note("NUL 0B0") ; #47
        NPK.End

@@ph04: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3C0") ; #03 - 2
            NPK.Note("DRM 3B0") ; #04
            NPK.Note("DRM 3B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3B0") ; #21 - 4
            NPK.Note("NUL 0B0") ; #22
            NPK.Note("NUL 0B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("DRM 3C0") ; #25
            NPK.Note("DRM 3C0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("DRM 3C0") ; #31
            NPK.Note("DRM 3C0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("NUL 0E0") ; #43
            NPK.Note("NUL 0E0") ; #44
            NPK.Note("DRM 3B0") ; #45 - 4
            NPK.Note("NUL 0B0") ; #46
            NPK.Note("NUL 0B0") ; #47
        NPK.End

@@ph10: NPK.Begin(48)
            NPK.Note("DRM 4F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 4A0") ; #03 - 2
            NPK.Note("NUL 0A0") ; #04
            NPK.Note("NUL 0A0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("NUL 0E0") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@ph11: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("NUL 0E0") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@ph12: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3C0") ; #15 - 2
            NPK.Note("DRM 3B0") ; #16
            NPK.Note("DRM 3B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3B0") ; #21 - 4
            NPK.Note("NUL 0B0") ; #22
            NPK.Note("NUL 0B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("NUL 0E0") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@ph13: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("NUL 0E0") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@ph14: NPK.Begin(48)
            NPK.Note("DRM 4F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 4A0") ; #03 - 2
            NPK.Note("NUL 0A0") ; #04
            NPK.Note("NUL 0A0") ; #05
            NPK.Note("DRM 460") ; #06 - 3
            NPK.Note("NUL 060") ; #07
            NPK.Note("NUL 060") ; #08
            NPK.Note("NUL 060") ; #09 - 4
            NPK.Note("NUL 060") ; #10
            NPK.Note("NUL 060") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("NUL 000") ; #30 - 3
            NPK.Note("NUL 000") ; #31
            NPK.Note("NUL 000") ; #32
            NPK.Note("NUL 000") ; #33 - 4
            NPK.Note("NUL 000") ; #34
            NPK.Note("NUL 000") ; #35

            NPK.Note("NUL 000") ; #36 - 1
            NPK.Note("NUL 000") ; #37
            NPK.Note("NUL 000") ; #38
            NPK.Note("NUL 000") ; #39 - 2
            NPK.Note("NUL 000") ; #40
            NPK.Note("NUL 000") ; #41
            NPK.Note("NUL 000") ; #42 - 3
            NPK.Note("NUL 000") ; #43
            NPK.Note("NUL 000") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

            ; ph2# Hi-hat rhythm #2 (plus cowbell)
            ; -----------------------------------------------
@@ph21: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 3B0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 4F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 3C0") ; #45 - 4
            NPK.Note("DRM 3B0") ; #46
            NPK.Note("DRM 3B0") ; #47
        NPK.End

@@ph22: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 4F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 7E0") ; #15 - 2
            NPK.Note("NUL 0E0") ; #16
            NPK.Note("NUL 0E0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("DRM 3E0") ; #19
            NPK.Note("DRM 3B0") ; #20
            NPK.Note("DRM 7E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("DRM 3E0") ; #25
            NPK.Note("DRM 3B0") ; #26
            NPK.Note("DRM 7E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 3B0") ; #33 - 4
            NPK.Note("NUL 0B0") ; #34
            NPK.Note("NUL 0B0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 4F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 4A0") ; #45 - 4
            NPK.Note("NUL 0A0") ; #46
            NPK.Note("NUL 0A0") ; #47
        NPK.End

@@ph23: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3B0") ; #03 - 2
            NPK.Note("NUL 0B0") ; #04
            NPK.Note("NUL 0B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3B0") ; #15 - 2
            NPK.Note("NUL 0B0") ; #16
            NPK.Note("NUL 0B0") ; #17
            NPK.Note("DRM 3E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 3C0") ; #21 - 4
            NPK.Note("DRM 3B0") ; #22
            NPK.Note("DRM 3B0") ; #23

            NPK.Note("DRM 3E0") ; #24 - 1
            NPK.Note("DRM 3B0") ; #25
            NPK.Note("DRM 3B0") ; #26
            NPK.Note("DRM 3C0") ; #27 - 2
            NPK.Note("NUL 0B0") ; #28
            NPK.Note("NUL 0B0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 4F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3B0") ; #39 - 2
            NPK.Note("NUL 0B0") ; #40
            NPK.Note("NUL 0B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("NUL 0E0") ; #43
            NPK.Note("NUL 0E0") ; #44
            NPK.Note("DRM 3C0") ; #45 - 4
            NPK.Note("DRM 3B0") ; #46
            NPK.Note("DRM 3B0") ; #47
        NPK.End

@@ph24: NPK.Begin(48)
            NPK.Note("DRM 3E0") ; #00 - 1
            NPK.Note("NUL 0E0") ; #01
            NPK.Note("NUL 0E0") ; #02
            NPK.Note("DRM 3C0") ; #03 - 2
            NPK.Note("DRM 3B0") ; #04
            NPK.Note("DRM 3B0") ; #05
            NPK.Note("DRM 3E0") ; #06 - 3
            NPK.Note("NUL 0E0") ; #07
            NPK.Note("NUL 0E0") ; #08
            NPK.Note("DRM 3B0") ; #09 - 4
            NPK.Note("NUL 0B0") ; #10
            NPK.Note("NUL 0B0") ; #11

            NPK.Note("DRM 3E0") ; #12 - 1
            NPK.Note("NUL 0E0") ; #13
            NPK.Note("NUL 0E0") ; #14
            NPK.Note("DRM 3C0") ; #15 - 2
            NPK.Note("DRM 3A0") ; #16
            NPK.Note("DRM 3A0") ; #17
            NPK.Note("DRM 4F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 7E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 7E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 7E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 3E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("DRM 7E0") ; #33 - 4
            NPK.Note("NUL 0E0") ; #34
            NPK.Note("NUL 0E0") ; #35

            NPK.Note("DRM 3E0") ; #36 - 1
            NPK.Note("NUL 0E0") ; #37
            NPK.Note("NUL 0E0") ; #38
            NPK.Note("DRM 3C0") ; #39 - 2
            NPK.Note("DRM 3B0") ; #40
            NPK.Note("DRM 3B0") ; #41
            NPK.Note("DRM 3E0") ; #42 - 3
            NPK.Note("NUL 0E0") ; #43
            NPK.Note("NUL 0E0") ; #44
            NPK.Note("DRM 4F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

            ; pf## Full beat (kick/snare/clave)
            ; -----------------------------------------------
@@pf01: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 5F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 5F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("NUL 0F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 5F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 5F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 5F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pf02: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 5F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("DRM 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 5F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 5F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 5F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pf03: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 5F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("DRM 5F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 5F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 5F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 5F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 5F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 1E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pf04: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 5F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("DRM 5F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("DRM 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 2F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

            ; pf2# Full beat #2 (kick/snare/clave/cowbell)
            ; -----------------------------------------------
@@pf21: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 5F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 5F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("NUL 0F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 5F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@pf22: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 000") ; #06 - 3
            NPK.Note("NUL 000") ; #07
            NPK.Note("NUL 000") ; #08
            NPK.Note("DRM 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 6E0") ; #15 - 2
            NPK.Note("NUL 0E0") ; #16
            NPK.Note("NUL 0E0") ; #17
            NPK.Note("DRM 6A0") ; #18 - 3
            NPK.Note("NUL 0A0") ; #19
            NPK.Note("NUL 0A0") ; #20
            NPK.Note("DRM 6E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 6A0") ; #24 - 1
            NPK.Note("NUL 0A0") ; #25
            NPK.Note("NUL 0A0") ; #26
            NPK.Note("DRM 6E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 2F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 1F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pf23: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 5F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("DRM 5F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 5F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 5F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 5F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("DRM 5F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 1E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pf24: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("DRM 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("DRM 2F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 2F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("DRM 1F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("DRM 6E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 6E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 6E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 6E0") ; #33 - 4
            NPK.Note("NUL 0E0") ; #34
            NPK.Note("NUL 0E0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pf32: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 1F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 000") ; #09 - 4
            NPK.Note("NUL 000") ; #10
            NPK.Note("NUL 000") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("DRM 6E0") ; #15 - 2
            NPK.Note("NUL 0E0") ; #16
            NPK.Note("NUL 0E0") ; #17
            NPK.Note("DRM 6A0") ; #18 - 3
            NPK.Note("NUL 0A0") ; #19
            NPK.Note("NUL 0A0") ; #20
            NPK.Note("DRM 6E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 6A0") ; #24 - 1
            NPK.Note("NUL 0A0") ; #25
            NPK.Note("NUL 0A0") ; #26
            NPK.Note("DRM 6E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 2F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pf34: NPK.Begin(48)
            NPK.Note("DRM 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("DRM 1F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("DRM 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("DRM 6E0") ; #21 - 4
            NPK.Note("NUL 0E0") ; #22
            NPK.Note("NUL 0E0") ; #23

            NPK.Note("DRM 6E0") ; #24 - 1
            NPK.Note("NUL 0E0") ; #25
            NPK.Note("NUL 0E0") ; #26
            NPK.Note("DRM 6E0") ; #27 - 2
            NPK.Note("NUL 0E0") ; #28
            NPK.Note("NUL 0E0") ; #29
            NPK.Note("DRM 2F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("DRM 6E0") ; #33 - 4
            NPK.Note("NUL 0E0") ; #34
            NPK.Note("NUL 0E0") ; #35

            NPK.Note("DRM 2F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("DRM 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("DRM 2F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("DRM 2F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

            ; pd##: Deep bass for kick drum undertone
            ; -----------------------------------------------
@@pd01: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("C-1 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd02: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("C-1 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("C-1 1E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd03: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 000") ; #12 - 1
            NPK.Note("NUL 000") ; #13
            NPK.Note("NUL 000") ; #14
            NPK.Note("NUL 000") ; #15 - 2
            NPK.Note("NUL 000") ; #16
            NPK.Note("NUL 000") ; #17
            NPK.Note("NUL 000") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("C-1 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("C-1 1E0") ; #45 - 4
            NPK.Note("NUL 0E0") ; #46
            NPK.Note("NUL 0E0") ; #47
        NPK.End

@@pd04: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("C-1 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("C-1 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("C-1 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("C-1 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("NUL 0F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@pd12: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("C-1 1E0") ; #30 - 3
            NPK.Note("NUL 0E0") ; #31
            NPK.Note("NUL 0E0") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd14: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("C-1 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("C-1 1E0") ; #18 - 3
            NPK.Note("NUL 0E0") ; #19
            NPK.Note("NUL 0E0") ; #20
            NPK.Note("C-1 1F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("C-1 1F0") ; #27 - 2
            NPK.Note("NUL 0F0") ; #28
            NPK.Note("NUL 0F0") ; #29
            NPK.Note("NUL 0F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("NUL 0F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 000") ; #45 - 4
            NPK.Note("NUL 000") ; #46
            NPK.Note("NUL 000") ; #47
        NPK.End

@@pd22: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("C-1 1F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("NUL 000") ; #30 - 3
            NPK.Note("NUL 000") ; #31
            NPK.Note("NUL 000") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("C-1 1F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd24: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("NUL 0F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("C-1 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("C-1 1E0") ; #09 - 4
            NPK.Note("NUL 0E0") ; #10
            NPK.Note("NUL 0E0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("C-1 1F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("NUL 0F0") ; #21 - 4
            NPK.Note("NUL 0F0") ; #22
            NPK.Note("NUL 0F0") ; #23

            NPK.Note("NUL 0F0") ; #24 - 1
            NPK.Note("NUL 0F0") ; #25
            NPK.Note("NUL 0F0") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("C-1 1F0") ; #30 - 3
            NPK.Note("NUL 0F0") ; #31
            NPK.Note("NUL 0F0") ; #32
            NPK.Note("NUL 0F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd32: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("C-1 1F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("NUL 0F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 000") ; #19
            NPK.Note("NUL 000") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("NUL 000") ; #30 - 3
            NPK.Note("NUL 000") ; #31
            NPK.Note("NUL 000") ; #32
            NPK.Note("C-1 1F0") ; #33 - 4
            NPK.Note("NUL 0F0") ; #34
            NPK.Note("NUL 0F0") ; #35

            NPK.Note("NUL 0F0") ; #36 - 1
            NPK.Note("NUL 0F0") ; #37
            NPK.Note("NUL 0F0") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End

@@pd34: NPK.Begin(48)
            NPK.Note("C-1 1F0") ; #00 - 1
            NPK.Note("NUL 0F0") ; #01
            NPK.Note("NUL 0F0") ; #02
            NPK.Note("C-1 1F0") ; #03 - 2
            NPK.Note("NUL 0F0") ; #04
            NPK.Note("NUL 0F0") ; #05
            NPK.Note("C-1 1F0") ; #06 - 3
            NPK.Note("NUL 0F0") ; #07
            NPK.Note("NUL 0F0") ; #08
            NPK.Note("NUL 0F0") ; #09 - 4
            NPK.Note("NUL 0F0") ; #10
            NPK.Note("NUL 0F0") ; #11

            NPK.Note("NUL 0F0") ; #12 - 1
            NPK.Note("NUL 0F0") ; #13
            NPK.Note("NUL 0F0") ; #14
            NPK.Note("NUL 0F0") ; #15 - 2
            NPK.Note("NUL 0F0") ; #16
            NPK.Note("NUL 0F0") ; #17
            NPK.Note("NUL 0F0") ; #18 - 3
            NPK.Note("NUL 0F0") ; #19
            NPK.Note("NUL 0F0") ; #20
            NPK.Note("NUL 000") ; #21 - 4
            NPK.Note("NUL 000") ; #22
            NPK.Note("NUL 000") ; #23

            NPK.Note("NUL 000") ; #24 - 1
            NPK.Note("NUL 000") ; #25
            NPK.Note("NUL 000") ; #26
            NPK.Note("NUL 000") ; #27 - 2
            NPK.Note("NUL 000") ; #28
            NPK.Note("NUL 000") ; #29
            NPK.Note("NUL 000") ; #30 - 3
            NPK.Note("NUL 000") ; #31
            NPK.Note("NUL 000") ; #32
            NPK.Note("NUL 000") ; #33 - 4
            NPK.Note("NUL 000") ; #34
            NPK.Note("NUL 000") ; #35

            NPK.Note("NUL 000") ; #36 - 1
            NPK.Note("NUL 000") ; #37
            NPK.Note("NUL 000") ; #38
            NPK.Note("C-1 1F0") ; #39 - 2
            NPK.Note("NUL 0F0") ; #40
            NPK.Note("NUL 0F0") ; #41
            NPK.Note("NUL 0F0") ; #42 - 3
            NPK.Note("NUL 0F0") ; #43
            NPK.Note("NUL 0F0") ; #44
            NPK.Note("NUL 0F0") ; #45 - 4
            NPK.Note("NUL 0F0") ; #46
            NPK.Note("NUL 0F0") ; #47
        NPK.End
            ENDP

;; ======================================================================== ;;
;;  End of File:  drums-demo.asm                                            ;;
;; ======================================================================== ;;
