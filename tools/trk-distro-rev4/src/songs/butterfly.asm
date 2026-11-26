;* ======================================================================== *;
;*  This code is placed into the public domain by its collective authors.   *;
;*  All copyright rights are hereby relinquished on the code and data in    *;
;*  this file.                                                              *;
;*      -- James Pujals, 2020                                               *;
;*      -- Anders Carlsson, 2020                                            *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  SONG: Flight Of The Butterfly                                           ;;
;;      This song was composed for the "Voyage: An Intv Journey" demo for   ;;
;;      the @Party in Boston, MA, 2017.  It was donated by its author to    ;;
;;      serve as an example of a 6-channel track, so that others may learn  ;;
;;      from it.                                                            ;;
;;                                                                          ;;
;;      Composed By:    Anders Carlsson (Zapac)                             ;;
;;      Tracked By:     Anders Carlsson (Zapac)                             ;;
;;      Remixed By:     James Pujals (DZ-Jay)                               ;;
;; ======================================================================== ;;
BUTTERFLY   PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;
            DECLE   6, @@patterns, @@instr, @@drums

; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
            DECLE    0,  1                  ; Intro

                                            ; Part I:
            DECLE    2,  3                  ;   First Verse
            DECLE    4,  5,  6,  7          ;   Second Verse
            DECLE    8,  9, 10, 11          ;   Bridge

            DECLE   12, 13, 14, 15          ; Bass break

                                            ; Part II:
            DECLE    2,  3                  ;   First Verse
            DECLE    4,  5,  6,  7          ;   Second Verse
            DECLE    8,  9, 10, 11          ;   Bridge

            DECLE   16, 17, 18, 19          ;   Fade out ...

            DECLE   20, TRK_END_SONG        ; The End.

; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;
@@patterns: DECLE   64, @@p0_00, @@p1_00, @@p2_00, @@p3_00, @@p0_00, @@p0_00    ; #0
            DECLE   64, @@p0_01, @@p1_01, @@p2_00, @@p3_01, @@p0_00, @@p0_00    ; #1

            DECLE   64, @@p0_02, @@p1_02, @@p2_00, @@p3_00, @@p4_02, @@p0_00    ; #2
            DECLE   64, @@p0_02, @@p1_03, @@p2_00, @@p3_00, @@p4_03, @@p0_00    ; #3

            DECLE   64, @@p0_02, @@p1_02, @@p2_00, @@p3_00, @@p4_02, @@p5_04    ; #4
            DECLE   64, @@p0_02, @@p1_03, @@p2_00, @@p3_00, @@p4_03, @@p5_05    ; #5
            DECLE   64, @@p0_02, @@p1_02, @@p2_00, @@p3_00, @@p4_06, @@p5_06    ; #6
            DECLE   64, @@p0_02, @@p1_07, @@p2_00, @@p3_00, @@p4_07, @@p5_07    ; #7

            DECLE   64, @@p0_02, @@p1_08, @@p2_08, @@p3_08, @@p4_08, @@p5_08    ; #8
            DECLE   64, @@p0_02, @@p1_09, @@p2_08, @@p3_08, @@p4_09, @@p5_09    ; #9
            DECLE   64, @@p0_02, @@p1_08, @@p2_08, @@p3_08, @@p4_10, @@p5_10    ; #10
            DECLE   64, @@p0_03, @@p1_11, @@p2_08, @@p3_08, @@p4_11, @@p5_11    ; #11

            ; Bass break patterns
            DECLE   64, @@p0_02, @@p1_08, @@p2_00, @@p0_00, @@p4_12, @@p4_12    ; #12
            DECLE   64, @@p0_02, @@p1_09, @@p2_00, @@p0_00, @@p0_00, @@p0_00    ; #13
            DECLE   64, @@p0_02, @@p1_08, @@p2_00, @@p3_00, @@p0_00, @@p0_00    ; #14
            DECLE   64, @@p0_03, @@p1_11, @@p2_00, @@p3_00, @@p0_00, @@p0_00    ; #15

            DECLE   64, @@p0_02, @@pf_08, @@pf_01, @@pf_15, @@p4_12, @@p4_12    ; #16
            DECLE   64, @@p0_03, @@pf_09, @@pf_02, @@pf_16, @@p0_00, @@p0_00    ; #17
            DECLE   64, @@p0_02, @@pf_10, @@pf_03, @@pf_17, @@p0_00, @@p0_00    ; #18
            DECLE   64, @@p0_03, @@pf_11, @@pf_04, @@pf_18, @@p0_00, @@p0_00    ; #19

            DECLE   16, @@p0_04, @@p0_00, @@p0_00, @@p0_05, @@p0_00, @@p0_00    ; #20

            ; Transposed melody, not used in song
            ; DECLE   64, @@p0_02, @@p1_08, @@p2_08, @@p3_08, @@p0_00, @@p0_00    ; #16
            ; DECLE   64, @@p0_02, @@p1_09, @@p2_08, @@p3_08, @@p0_00, @@p0_00    ; #17
            ; DECLE   64, @@p0_02, @@p1_08, @@p2_08, @@p3_08, @@p0_00, @@p0_00    ; #18
            ; DECLE   64, @@p0_02, @@p1_11, @@p2_08, @@p3_08, @@p0_00, @@p0_00    ; #19

; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
@@instr:    DECLE   MUSIC.pitch01, 0, MUSIC.env02   ; #1: Short Bass
            DECLE   MUSIC.pitch04, 0, MUSIC.env04   ; #2: Arpeggio 47
            DECLE   MUSIC.pitch03, 0, MUSIC.env04   ; #3: Arpeggio 59
            DECLE   MUSIC.pitch01, 2, MUSIC.env06   ; #4: Long Bass
            DECLE   MUSIC.pitch01, 3, MUSIC.env06   ; #5: Melody
            DECLE   MUSIC.pitch01, 1, MUSIC.env07   ; #6: Sequencer

; ------------------------------------------------------------------------- ;
;  Drum Kit                                                                 ;
; ------------------------------------------------------------------------- ;
@@drums:    DECLE   MUSIC.bassdrum                  ; #1
            DECLE   MUSIC.snare                     ; #2
            DECLE   MUSIC.hh_closed                 ; #3
            DECLE   MUSIC.hh_half                   ; #4
            DECLE   MUSIC.hh_open                   ; #5

; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
@@p0_00:    NOTES("NUL 10F", "NUL 00F", "NUL 00F", "NUL 00F")

@@p1_00:    NOTES("G-1 4FB", "A-1 0F3", "B-1 0FF", "C-2 0FB")
            NOTES("D-2 0F3", "G-1 0FF", "", "")

@@p2_00:    NOTES("G-4 6F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")

@@p3_00:    NOTES("NUL 10F", "NUL 103", "G-5 2FB", "NUL 00F")
            NOTES("NUL 003", "G-5 2FB", "", "")

@@p0_01:    NOTES("NUL 10F", "NUL 10F", "NUL 10F", "NUL 101")
            NOTES("DRM 4F1", "NUL 001", "DRM 4F1", "NUL 001")
            NOTES("DRM 4F1", "NUL 001", "DRM 4F1", "")

@@p1_01:    NOTES("G-2 4FB", "F-2 0F3", "E-2 0FF", "F-2 0FB")
            NOTES("G-2 0F3", "G-1 1F1", "NUL 001", "G-1 0F1")
            NOTES("NUL 001", "G-1 0F1", "NUL 001", "G-1 0F1")
            NOTES("NUL 001", "", "", "")

@@p3_01:    NOTES("NUL 10F", "NUL 103", "G-5 2FB", "NUL 00F")
            NOTES("NUL 00F", "", "", "")

@@p0_02:    NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F1", "DRM 1F0")
            NOTES("DRM 2F1", "DRM 4F0", "DRM 3F0", "")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F0", "DRM 3E0")
            NOTES("DRM 1F0", "DRM 2F0", "DRM 3F0", "DRM 3F0")
            NOTES("DRM 3E0", "", "", "")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F1", "DRM 1F0")
            NOTES("DRM 2F1", "DRM 3F0", "DRM 3E0", "")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F0", "DRM 3E0")
            NOTES("DRM 1F0", "DRM 2F1", "DRM 5F1", "")

@@p0_03:    NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F0", "DRM 3F0")
            NOTES("DRM 1F0", "DRM 2F1", "DRM 3F0", "DRM 3E0")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 1F0", "DRM 2F1")
            NOTES("DRM 1F0", "DRM 3F0", "DRM 3E0", "DRM 1F0")
            NOTES("DRM 3F0", "DRM 3E0", "DRM 2F1", "DRM 5F1")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 3E0", "DRM 2F1")
            NOTES("DRM 3F0", "DRM 1F1", "DRM 3F0", "DRM 3E0")
            NOTES("DRM 1F0", "DRM 2F1", "DRM 3F0", "DRM 3E0")

            NOTES("DRM 1F1", "DRM 3F0", "DRM 3F0", "DRM 2F1")
            NOTES("DRM 4F0", "DRM 2F0", "DRM 4F0", "DRM 1F0")
            NOTES("DRM 2F0", "DRM 5F0", "DRM 2F1", "DRM 2F0")
            NOTES("DRM 2F0", "", "", "")

@@p1_02:    NOTES("G-1 1F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("B-1 0F1", "B-2 0F1", "B-1 0F1", "B-2 0F1")
            NOTES("B-1 0F1", "B-2 0F1", "B-1 0F1", "B-2 0F1")
            NOTES("C-2 0F1", "C-3 0F1", "C-2 0F1", "C-3 0F1")
            NOTES("C-2 0F1", "C-3 0F1", "D-2 0F1", "D-3 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")

@@p4_02:    NOTES("B-4 5FB", "C-5 0F3", "D-5 0FF", "E-5 0FB")
            NOTES("G-5 0F2", "E-5 0F0", "D-5 0F2", "C-5 0F0")
            NOTES("B-4 0FB", "", "", "")

@@p1_03:    NOTES("G-1 1F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")

@@p4_03:    NOTES("B-5 5FB", "A-5 0F3", "G-5 0FF", "A-5 0FB")
            NOTES("G-5 0F3", "B-5 0F2", "A-5 0F0", "G-5 0FB")

@@p5_04:    NOTES("G-4 5FB", "A-4 0F3", "B-4 0FF", "C-5 0FB")
            NOTES("E-5 0F2", "C-5 0F0", "B-4 0F2", "A-4 0F0")
            NOTES("G-4 0FB", "", "", "")

@@p5_05:    NOTES("D-5 5FB", "C-5 0F3", "B-4 0FF", "C-5 0FB")
            NOTES("B-4 0F3", "D-5 0F2", "C-5 0F0", "B-4 0FB")

@@p4_06:    NOTES("D-5 5FB", "C-5 0F3", "B-4 0F2", "C-5 0F0")
            NOTES("D-5 0FB", "E-5 0FB", "C-5 0F2", "A-4 0F0")
            NOTES("B-4 0F2", "C-5 0F0", "D-5 0FB", "")

@@p5_06:    NOTES("B-4 5FB", "A-4 0F3", "G-4 0F2", "A-4 0F0")
            NOTES("B-4 0FB", "C-5 0FB", "A-4 0F2", "F#4 0F0")
            NOTES("G-4 0F2", "A-4 0F0", "B-4 0FB", "")

@@p1_07:    NOTES("G-1 1F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("G-1 0F1", "F-1 0F1", "E-1 0F1", "D-1 0F1")

@@p4_07:    NOTES("D-5 5FB", "C-6 0F3", "B-5 0F2", "G-5 0F0")
            NOTES("E-5 0FB", "A-5 0F7", "B-5 0F2", "F#5 0F2")
            NOTES("A-5 0F1", "G-5 0FF", "", "")

@@p5_07:    NOTES("B-4 5FB", "A-4 0F3", "G-4 0F2", "B-4 0F0")
            NOTES("G-4 0FB", "F-5 0F7", "G-4 0F2", "A-4 0F2")
            NOTES("C-5 0F1", "B-4 0FF", "", "")

@@p1_08:    NOTES("C-1 1F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")

@@p2_08:    NOTES("G-4 6F0", "C-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("C-5 0F0", "G-5 0F0", "G-4 0F0", "C-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "C-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "C-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("C-5 0F0", "G-5 0F0", "G-4 0F0", "C-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "C-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "C-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("C-5 0F0", "G-5 0F0", "G-4 0F0", "C-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "C-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "C-5 0F0")
            NOTES("G-5 0F0", "C-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("C-5 0F0", "G-5 0F0", "G-4 0F0", "C-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "C-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "C-5 0F0", "G-5 0F0", "C-5 0F0")

@@p3_08:    NOTES("NUL 10F", "NUL 103", "G-5 3FB", "NUL 00F")
            NOTES("NUL 003", "G-5 3FB", "", "")

@@p4_08:    NOTES("E-4 5FB", "F-4 0F3", "G-4 0FF", "A-4 0FB")
            NOTES("C-5 0F2", "A-4 0F0", "G-4 0F2", "F-4 0F0")
            NOTES("E-4 0FB", "", "", "")

@@p5_08:    NOTES("C-5 5FB", "D-5 0F3", "E-5 0FF", "F-5 0FB")
            NOTES("A-5 0F2", "F-5 0F0", "E-5 0F2", "D-5 0F0")
            NOTES("C-5 0FB", "", "", "")

@@p1_09:    NOTES("C-1 1F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("A#1 0F1", "A#2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("A#1 0F1", "A#2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")

@@p4_09:    NOTES("E-5 5FB", "D-5 0F3", "C-5 0FF", "D-5 0FB")
            NOTES("C-5 0F3", "E-5 0F2", "D-5 0F0", "C-5 0FB")

@@p5_09:    NOTES("G-5 5FB", "F-5 0F3", "E-5 0FF", "F-5 0FB")
            NOTES("E-5 0F3", "G-5 0F2", "F-5 0F0", "E-5 0FB")

@@p3_10:    NOTES("NUL 10F", "NUL 103", "G-5 3FB", "NUL 00F")
            NOTES("NUL 00F", "", "", "")

@@p4_10:    NOTES("G-4 5FB", "F-4 0F3", "E-4 0F2", "F-4 0F0")
            NOTES("G-4 0FB", "A-4 0FB", "F-4 0F2", "D-4 0F0")
            NOTES("E-4 0F2", "F-4 0F0", "G-4 0FB", "")

@@p5_10:    NOTES("E-5 5FB", "D-5 0F3", "C-5 0F2", "D-5 0F0")
            NOTES("E-5 0FB", "F-5 0FB", "D-5 0F2", "B-4 0F0")
            NOTES("C-5 0F2", "D-5 0F0", "E-5 0FB", "")

@@p1_11:    NOTES("C-1 1F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("A#1 0F1", "A#2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("A#1 0F1", "A#2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "D-1 0F1", "E-1 0F1", "F-1 0F1")

@@p4_11:    NOTES("G-4 5FB", "F-5 0F3", "E-5 0F2", "C-5 0F0")
            NOTES("A-4 0FB", "A#4 0F7", "E-5 0F2", "B-4 0F2")
            NOTES("D-5 0F1", "C-5 0FF", "", "")

@@p4_12:    NOTES("NUL 5FF", "NUL 0FF", "NUL 0FF", "NUL 00F")

@@p5_11:    NOTES("E-5 5FB", "D-5 0F3", "C-5 0F2", "E-5 0F0")
            NOTES("C-5 0FB", "D-5 0F7", "C-5 0F2", "D-5 0F2")
            NOTES("F-5 0F1", "E-5 0FF", "", "")

            ; Fading Bass-line
@@pf_08:    NOTES("C-1 1F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("F-1 0E1", "F-2 0E1", "F-1 0E1", "F-2 0E1")
            NOTES("F-1 0E1", "F-2 0E1", "G-1 0E1", "G-2 0E1")
            NOTES("C-1 0E1", "C-2 0E1", "C-1 0E1", "C-2 0E1")
            NOTES("C-1 0E1", "C-2 0E1", "C-1 0E1", "C-2 0E1")

@@pf_09:    NOTES("C-1 1E1", "C-2 0E1", "C-1 0E1", "C-2 0E1")
            NOTES("C-1 0E1", "C-2 0E1", "A#1 0E1", "A#2 0E1")
            NOTES("A-1 0D1", "A-2 0D1", "A-1 0D1", "A-2 0D1")
            NOTES("A-1 0D1", "A-2 0D1", "A-1 0D1", "A-2 0D1")
            NOTES("A#1 0C1", "A#2 0C1", "A#1 0C1", "A#2 0C1")
            NOTES("A#1 0C1", "A#2 0C1", "G-1 0C1", "G-2 0C1")
            NOTES("C-1 0B1", "C-2 0B1", "C-1 0B1", "C-2 0B1")
            NOTES("C-1 0B1", "C-2 0B1", "C-1 0B1", "C-2 0B1")

@@pf_10:    NOTES("C-1 1A1", "C-2 0A1", "C-1 0A1", "C-2 0A1")
            NOTES("C-1 0A1", "C-2 0A1", "D-1 0A1", "D-2 0A1")
            NOTES("E-1 091", "E-2 091", "E-1 091", "E-2 091")
            NOTES("E-1 091", "E-2 091", "E-1 091", "E-2 091")
            NOTES("F-1 081", "F-2 081", "F-1 081", "F-2 081")
            NOTES("F-1 081", "F-2 081", "G-1 081", "G-2 081")
            NOTES("C-1 071", "C-2 071", "C-1 071", "C-2 071")
            NOTES("C-1 071", "C-2 071", "C-1 071", "C-2 071")

@@pf_11:    NOTES("C-1 161", "C-2 061", "C-1 061", "C-2 061")
            NOTES("C-1 061", "C-2 061", "A#1 061", "A#2 061")
            NOTES("A-1 051", "A-2 051", "A-1 051", "A-2 051")
            NOTES("A-1 051", "A-2 051", "A-1 051", "A-2 051")
            NOTES("A#1 041", "A#2 041", "A#1 041", "A#2 041")
            NOTES("A#1 031", "A#2 031", "G-1 031", "G-2 031")
            NOTES("C-1 021", "C-2 021", "C-1 021", "C-2 021")
            NOTES("C-1 011", "D-1 011", "E-1 011", "F-1 011")

            ; Fading TX Sequence
@@pf_01:    NOTES("G-4 6F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0E0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0E0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "G-4 0F0")
            NOTES("D-5 0F0", "G-5 0F0", "G-4 0F0", "D-5 0F0")
            NOTES("G-5 0F0", "G-4 0F0", "D-5 0F0", "G-5 0F0")
            NOTES("G-4 0F0", "D-5 0F0", "G-5 0F0", "D-5 0F0")
            NOTES("G-4 0E0", "D-5 0E0", "G-5 0E0", "G-4 0E0")
            NOTES("D-5 0E0", "G-5 0E0", "G-4 0E0", "D-5 0E0")
            NOTES("G-5 0E0", "G-4 0E0", "D-5 0E0", "G-5 0E0")
            NOTES("G-4 0E0", "D-5 0E0", "G-5 0E0", "D-5 0E0")

@@pf_02:    NOTES("G-4 6E0", "D-5 0E0", "G-5 0E0", "G-4 0E0")
            NOTES("D-5 0E0", "G-5 0E0", "G-4 0E0", "D-5 0E0")
            NOTES("G-5 0E0", "G-4 0E0", "D-5 0E0", "G-5 0E0")
            NOTES("G-4 0E0", "D-5 0E0", "G-5 0E0", "D-5 0E0")
            NOTES("G-4 0D0", "D-5 0D0", "G-5 0D0", "G-4 0D0")
            NOTES("D-5 0D0", "G-5 0D0", "G-4 0D0", "D-5 0D0")
            NOTES("G-5 0D0", "G-4 0D0", "D-5 0D0", "G-5 0D0")
            NOTES("G-4 0D0", "D-5 0D0", "G-5 0D0", "D-5 0D0")
            NOTES("G-4 0C0", "D-5 0C0", "G-5 0C0", "G-4 0C0")
            NOTES("D-5 0C0", "G-5 0C0", "G-4 0C0", "D-5 0C0")
            NOTES("G-5 0C0", "G-4 0C0", "D-5 0C0", "G-5 0C0")
            NOTES("G-4 0C0", "D-5 0C0", "G-5 0C0", "D-5 0C0")
            NOTES("G-4 0B0", "D-5 0B0", "G-5 0B0", "G-4 0B0")
            NOTES("D-5 0B0", "G-5 0B0", "G-4 0B0", "D-5 0B0")
            NOTES("G-5 0B0", "G-4 0B0", "D-5 0B0", "G-5 0B0")
            NOTES("G-4 0B0", "D-5 0B0", "G-5 0B0", "D-5 0B0")

@@pf_03:    NOTES("G-4 6A0", "D-5 0A0", "G-5 0A0", "G-4 0A0")
            NOTES("D-5 0A0", "G-5 0A0", "G-4 0A0", "D-5 0A0")
            NOTES("G-5 0A0", "G-4 0A0", "D-5 0A0", "G-5 0A0")
            NOTES("G-4 0A0", "D-5 0A0", "G-5 0A0", "D-5 0A0")
            NOTES("G-4 090", "D-5 090", "G-5 090", "G-4 090")
            NOTES("D-5 090", "G-5 090", "G-4 090", "D-5 090")
            NOTES("G-5 090", "G-4 090", "D-5 090", "G-5 090")
            NOTES("G-4 090", "D-5 090", "G-5 090", "D-5 090")
            NOTES("G-4 080", "D-5 080", "G-5 080", "G-4 080")
            NOTES("D-5 080", "G-5 080", "G-4 080", "D-5 080")
            NOTES("G-5 080", "G-4 080", "D-5 080", "G-5 080")
            NOTES("G-4 080", "D-5 080", "G-5 080", "D-5 080")
            NOTES("G-4 070", "D-5 070", "G-5 070", "G-4 070")
            NOTES("D-5 070", "G-5 070", "G-4 070", "D-5 070")
            NOTES("G-5 070", "G-4 070", "D-5 070", "G-5 070")
            NOTES("G-4 070", "D-5 070", "G-5 070", "D-5 070")

@@pf_04:    NOTES("G-4 660", "D-5 060", "G-5 060", "G-4 060")
            NOTES("D-5 060", "G-5 060", "G-4 060", "D-5 060")
            NOTES("G-5 060", "G-4 060", "D-5 060", "G-5 060")
            NOTES("G-4 060", "D-5 060", "G-5 060", "D-5 060")
            NOTES("G-4 050", "D-5 050", "G-5 050", "G-4 050")
            NOTES("D-5 050", "G-5 050", "G-4 050", "D-5 050")
            NOTES("G-5 050", "G-4 050", "D-5 050", "G-5 050")
            NOTES("G-4 050", "D-5 050", "G-5 050", "D-5 050")
            NOTES("G-4 040", "D-5 040", "G-5 040", "G-4 040")
            NOTES("D-5 040", "G-5 040", "G-4 040", "D-5 040")
            NOTES("G-5 030", "G-4 030", "D-5 030", "G-5 030")
            NOTES("G-4 030", "D-5 030", "G-5 030", "D-5 030")
            NOTES("G-4 020", "D-5 020", "G-5 020", "G-4 020")
            NOTES("D-5 020", "G-5 020", "G-4 020", "D-5 020")
            NOTES("G-5 010", "G-4 010", "D-5 010", "G-5 010")
            NOTES("G-4 010", "D-5 010", "G-5 010", "D-5 010")

            ; Fading arpeggio
@@pf_15:    NOTES("NUL 10F", "NUL 103", "G-5 2EB", "NUL 00F")
            NOTES("NUL 003", "G-5 2DB", "", "")

@@pf_16:    NOTES("NUL 10F", "NUL 103", "G-5 2CB", "NUL 00F")
            NOTES("NUL 003", "G-5 2BB", "", "")

@@pf_17:    NOTES("NUL 10F", "NUL 103", "G-5 28B", "NUL 00F")
            NOTES("NUL 003", "G-5 27B", "", "")

@@pf_18:    NOTES("NUL 10F", "NUL 103", "G-5 25B", "NUL 00F")
            NOTES("NUL 003", "G-5 24B", "", "")

            ; End drum hit
@@p0_04:    NOTES("DRM 1FF", "", "", "")
@@p0_05:    NOTES("DRM 5F1", "DRM 5AD", "NUL 00F", "NUL 00F")
            NOTES("NUL 00F", "", "", "")

            ENDP

;; ======================================================================== ;;
;;  End of File:  butterfly.asm                                             ;;
;; ======================================================================== ;;
