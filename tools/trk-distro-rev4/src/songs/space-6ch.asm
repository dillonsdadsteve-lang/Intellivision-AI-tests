;* ======================================================================== *;
;*  This code is placed into the public domain by its collective authors.   *;
;*  All copyright rights are hereby relinquished on the code and data in    *;
;*  this file.                                                              *;
;*      -- James Pujals, 2020                                               *;
;*      -- Anders Carlsson, 2020                                            *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  SONG: Journey Through The Stars (Space Music)                           ;;
;;      This song was composed for the "Voyage: An Intv Journey" demo for   ;;
;;      the @Party in Boston, MA, 2017.  It was donated by its author to    ;;
;;      serve as an example of a 6-channel track, so that others may learn  ;;
;;      from it.                                                            ;;
;;                                                                          ;;
;;      Composed By:    Anders Carlsson (Zapac)                             ;;
;;      Tracked By:     Anders Carlsson (Zapac)                             ;;
;;      Remixed By:     James Pujals (DZ-Jay)                               ;;
;; ======================================================================== ;;
SPACE_MUSIC PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;
            DECLE   6, @@patterns, @@instr, @@drums

; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
            DECLE    0,  1,  2,  3              ; Intro
            DECLE    4,  4,  5,  6              ; First Verse  <--,
            DECLE    7,  8,  9, 10              ; Second Verse    |
            DECLE   11, 12, 13, 14, 15, 16      ; Break           |
            DECLE   -14                         ; Repeat ---------'

; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;
@@patterns: DECLE   64, @@p2_00, @@p0_00, @@p1_10, @@p2_00, @@p2_00, @@p2_00  ; #0
            DECLE   64, @@p4_03, @@p0_00, @@p1_00, @@p2_00, @@p2_00, @@p2_00  ; #1
            DECLE   64, @@p4_04, @@p0_00, @@p1_01, @@p2_00, @@p2_00, @@p2_00  ; #2
            DECLE   64, @@p4_04, @@p0_00, @@p1_01, @@p2_02, @@p2_00, @@p2_00  ; #3

            DECLE   64, @@p4_01, @@p0_00, @@p1_01, @@p2_02, @@p3_03, @@p2_00  ; #4
            DECLE   64, @@p4_01, @@p0_04, @@p1_04, @@p2_04, @@p3_04, @@p2_00  ; #5
            DECLE   64, @@p4_02, @@p0_05, @@p1_05, @@p2_05, @@p3_05, @@p2_00  ; #6
            DECLE   64, @@p4_01, @@p0_00, @@p1_01, @@p2_02, @@p3_06, @@p2_00  ; #7
            DECLE   64, @@p4_01, @@p0_00, @@p1_01, @@p2_02, @@p3_07, @@p2_00  ; #8
            DECLE   64, @@p4_01, @@p0_08, @@p1_08, @@p2_08, @@p3_08, @@p2_00  ; #9
            DECLE   64, @@p4_02, @@p0_09, @@p1_09, @@p2_09, @@p3_09, @@p2_00  ; #10

            ; Break patterns
            DECLE   64, @@p4_01, @@p0_00, @@p1_01, @@p2_00, @@p3_10, @@p2_00  ; #11
            DECLE   64, @@p4_02, @@p0_00, @@p1_01, @@p2_00, @@p1_10, @@p2_00  ; #12

            DECLE   64, @@p4_04, @@p2_00, @@p2_00, @@p2_02, @@p2_10, @@p2_00  ; #13
            DECLE   64, @@p4_04, @@p0_10, @@p2_00, @@p2_02, @@p2_00, @@p2_00  ; #14
            DECLE   64, @@p4_01, @@p2_00, @@p2_00, @@p2_02, @@p1_10, @@p2_00  ; #15
            DECLE   64, @@p4_02, @@p2_00, @@p2_00, @@p2_02, @@p1_10, @@p2_00  ; #16

; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
@@instr:    DECLE MUSIC.pitch01, 0, MUSIC.env03     ; #1: Short bass
            DECLE MUSIC.pitch01, 0, MUSIC.env06     ; #2: Long bass
            DECLE MUSIC.pitch04, 0, MUSIC.env04     ; #3: Arpeggio 037C fade
            DECLE MUSIC.pitch04, 0, MUSIC.env04     ; #4: Arpeggio 047C fade
            DECLE MUSIC.pitch06, 0, MUSIC.env04     ; #5: Arpeggio 047A fade
            DECLE MUSIC.pitch07, 0, MUSIC.env05     ; #6: Arpeggio 0368 immediate
            DECLE MUSIC.pitch04, 0, MUSIC.env05     ; #7: Arpeggio 037C immediate
            DECLE MUSIC.pitch08, 0, MUSIC.env05     ; #8: Arpeggio 025A immediate
            DECLE MUSIC.pitch09, 0, MUSIC.env05     ; #9: Arpeggio 0358 immediate
            DECLE MUSIC.pitch10, 0, MUSIC.env05     ; #A: Arpeggio 0269 immediate
            DECLE MUSIC.pitch11, 0, MUSIC.env05     ; #B: Arpeggio 0359 immediate
            DECLE MUSIC.pitch03, 0, MUSIC.env05     ; #C: Arpeggio 059C immediate
            DECLE MUSIC.pitch12, 0, MUSIC.env05     ; #D: Arpeggio 0479 immediate
            DECLE MUSIC.pitch13, 0, MUSIC.env05     ; #E: Arpeggio 0369 immediate
            DECLE MUSIC.pitch04, 0, MUSIC.env05     ; #F: Arpeggio 047C immediate
            DECLE MUSIC.pitch01, 1, MUSIC.env07     ; #G: Sequencer
            DECLE MUSIC.pitch01, 3, MUSIC.env09     ; #H: Melody
            DECLE MUSIC.pitch01, 3, MUSIC.env01     ; #I: Melody, long
            DECLE MUSIC.pitch01, 1, MUSIC.env01     ; #J: Melody, long

; ------------------------------------------------------------------------- ;
;  Drum Kit                                                                 ;
; ------------------------------------------------------------------------- ;
@@drums:    DECLE   MUSIC.bassdrum                  ; #1
            DECLE   MUSIC.snare                     ; #2
            DECLE   MUSIC.hh_closed                 ; #3

; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
@@p0_00:    NOTES("F-3 GF0", "G#3 0F0", "A#3 0F0", "F-3 0F0")
            NOTES("G#3 0F0", "C-4 0F0", "F-3 0F0", "G#3 0F0")
            NOTES("C#4 0F0", "F-3 0F0", "G#3 0F0", "C-4 0F0")
            NOTES("F-3 0F0", "G#3 0F0", "A#3 0F0", "F-3 0F0")
            NOTES("D#3 0F0", "G#3 0F0", "A#3 0F0", "D#3 0F0")
            NOTES("G#3 0F0", "C-4 0F0", "D#3 0F0", "G#3 0F0")
            NOTES("C#4 0F0", "D#3 0F0", "G#3 0F0", "C-4 0F0")
            NOTES("D#3 0F0", "G#3 0F0", "A#3 0F0", "D#3 0F0")
            NOTES("C#3 0F0", "G#3 0F0", "A#3 0F0", "C#3 0F0")
            NOTES("G#3 0F0", "C-4 0F0", "C#3 0F0", "G#3 0F0")
            NOTES("C#4 0F0", "C#3 0F0", "G#3 0F0", "C-4 0F0")
            NOTES("C#3 0F0", "G#3 0F0", "A#3 0F0", "C#3 0F0")
            NOTES("C-3 0F0", "G-3 0F0", "G#3 0F0", "C-3 0F0")
            NOTES("G-3 0F0", "A#3 0F0", "C-3 0F0", "G-3 0F0")
            NOTES("C-4 0F0", "C-3 0F0", "G-3 0F0", "A#3 0F0")
            NOTES("C-3 0F0", "G-3 0F0", "G#3 0F0", "G-3 0F0")

@@p0_10:    NOTES("F-1 JFF", "D#1 JCF", "NUL 0AF", "NUL 00F")

@@p1_00:    NOTES("F-1 2FF", "D#1 0FF", "C#1 0FF", "C-1 0FD")
            NOTES("C-2 0F1", "", "", "")

@@p1_10:    NOTES("F-1 2FF", "D#1 0FF", "C#1 0FF", "C-1 0FF")

@@p2_00:    NOTES("NUL 20F", "NUL 00F", "NUL 00F", "NUL 00F")
@@p2_10:    NOTES("NUL 2FF", "NUL 0FF", "NUL 00F", "NUL 00F")

@@p1_01:    NOTES("F-1 1F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("D#1 0F1", "D#2 0F1", "D#1 0F1", "D#2 0F1")
            NOTES("D#1 0F1", "D#2 0F1", "D#1 0F1", "D#2 0F1")
            NOTES("C#1 0F1", "C#2 0F1", "C#1 0F1", "C#2 0F1")
            NOTES("C#1 0F1", "C#2 0F1", "C#1 0F1", "C#2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "A#1 0F1", "G-1 0F1")

@@p2_02:    NOTES("NUL 101", "F-4 3FD", "NUL 001", "D#4 4FD")
            NOTES("NUL 001", "C#4 4FD", "NUL 001", "C-4 5FD")

@@p4_01:    NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F0", "DRM 1F0", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F0", "DRM 1F0")
            NOTES("DRM 2F1", "DRM 3F1", "", "")

@@p4_02:    NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 2F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F0", "DRM 1F0", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 2F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 1F0", "DRM 3F0")
            NOTES("DRM 2F0", "DRM 1F0", "DRM 3F0", "DRM 3D0")
            NOTES("DRM 1F1", "DRM 3F0", "DRM 1F0", "DRM 2F0")
            NOTES("DRM 2F0", "DRM 2F0", "DRM 2F0", "")
            
@@p4_03:    NOTES("DRM 1F1", "DRM 1C1", "DRM 1A1", "DRM 195")
            NOTES("DRM 1D1", "DRM 1A1", "DRM 1F1", "DRM 1C1")
            NOTES("DRM 1A1", "DRM 199", "", "")

            NOTES("DRM 1F1", "DRM 1C1", "DRM 1A1", "DRM 195")
            NOTES("DRM 1D1", "DRM 1A1", "DRM 1F1", "DRM 1C1")
            NOTES("DRM 1A1", "DRM 199", "", "")

@@p4_04:    NOTES("DRM 1F1", "DRM 3F1", "DRM 1F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 1F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F1", "DRM 1F1", "DRM 3F1")
            NOTES("DRM 1F1", "DRM 3F0", "DRM 1F0", "DRM 1F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 1F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 1F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F1", "DRM 1F1")
            NOTES("DRM 3F1", "DRM 1F1", "DRM 3F0", "DRM 1F0")
            NOTES("DRM 1F1", "DRM 3F1", "", "")

@@p3_03:    NOTES("G-5 HF2", "G#5 0F2", "F-5 0F2", "G-5 0F2")
            NOTES("A#5 0F0", "G#5 0F0", "G-5 0F0", "F-5 0F0")
            NOTES("D#5 0F9", "G-5 0F1", "G#5 0F0", "G-5 0F0")
            NOTES("F-5 0F0", "D#5 0F0", "C#5 0F9", "G-5 0F1")
            NOTES("G#5 0F0", "G-5 0F0", "F-5 0F0", "D#5 0F0")
            NOTES("E-5 0F2", "F-5 0F2", "G-5 0F2", "G#5 0F2")
            NOTES("A#5 0F1", "C-6 0F1", "", "")

@@p0_04:    NOTES("F-3 GF0", "G#3 0F0", "A#3 0F0", "F-3 0F0")
            NOTES("G#3 0F0", "C-4 0F0", "F-3 0F0", "G#3 0F0")

            NOTES("C-4 0F0", "E-3 0F0", "G-3 0F0", "C-4 0F0")
            NOTES("E-3 0F0", "G-3 0F0", "C-4 0F0", "E-3 0F0")

            NOTES("F-3 0F0", "G#3 0F0", "C#4 0F0", "F-3 0F0")
            NOTES("G#3 0F0", "C#4 0F0", "F-3 0F0", "G#3 0F0")

            NOTES("C-4 0F0", "D#3 0F0", "G#3 0F0", "C-4 0F0")
            NOTES("D#3 0F0", "G#3 0F0", "C-4 0F0", "G#3 0F0")

            NOTES("F#3 0F0", "A-3 0F0", "C-4 0F0", "F#3 0F0")
            NOTES("A-3 0F0", "C-4 0F0", "F#3 0F0", "A-3 0F0")
            NOTES("B-3 0F0", "F-3 0F0", "G-3 0F0", "B-3 0F0")
            NOTES("F-3 0F0", "G-3 0F0", "B-3 0F0", "G-3 0F0")
            NOTES("G#3 0F0", "B-3 0F0", "D-4 0F0", "G#3 0F0")
            NOTES("B-3 0F0", "D-4 0F0", "G#3 0F0", "B-3 0F0")
            NOTES("C#4 0F0", "G-3 0F0", "A-3 0F0", "C#4 0F0")
            NOTES("G-3 0F0", "A-3 0F0", "C#4 0F0", "G-3 0F0")

@@p1_04:    NOTES("A#1 1F1", "A#2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("C-2 0F1", "C-3 0F1", "C-2 0F1", "C-3 0F1")
            NOTES("C#2 0F1", "C#3 0F1", "C#2 0F1", "C#3 0F1")

            NOTES("G#1 0F1", "G#2 0F1", "G#1 0F1", "G#2 0F1")

            NOTES("D-1 0F1", "D-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("E-1 0F1", "E-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")

@@p2_04:    NOTES("NUL 101", "D-4 6F5", "D-4 8F7", "NUL 001")
            NOTES("D#4 8F5", "D#4 CF7", "", "")

            NOTES("NUL 001", "C-4 AF5", "B-3 6F7", "NUL 001")
            NOTES("D-4 AF5", "C#4 6F7", "", "")

@@p3_04:    NOTES("A#5 HF2", "G#5 0F2", "G-5 0F5", "G#5 0F0")
            NOTES("G-5 0F0", "F-5 0F0", "D#5 0F0", "F-5 0F2")
            NOTES("G#5 0F1", "A#5 0F1", "C-6 0F8", "A-5 0F2")
            NOTES("B-5 0F1", "C-6 0F1", "B-5 0F8", "G#5 0F2")
            NOTES("A-5 0F1", "B-5 0F1", "A-5 0F2", "E-6 0F1")
            NOTES("C#6 0F1", "A-5 0F1", "", "")

@@p0_05:    NOTES("F-3 GF0", "G#3 0F0", "A#3 0F0", "F-3 0F0")
            NOTES("G#3 0F0", "C-4 0F0", "F-3 0F0", "G#3 0F0")

            NOTES("C-4 0F0", "E-3 0F0", "G-3 0F0", "C-4 0F0")
            NOTES("E-3 0F0", "G-3 0F0", "C-4 0F0", "E-3 0F0")

            NOTES("F-3 0F0", "G#3 0F0", "C#4 0F0", "F-3 0F0")
            NOTES("G#3 0F0", "C#4 0F0", "F-3 0F0", "G#3 0F0")

            NOTES("C-4 0F0", "D#3 0F0", "G#3 0F0", "C-4 0F0")
            NOTES("D#3 0F0", "G#3 0F0", "C-4 0F0", "G#3 0F0")

            NOTES("F-3 0F0", "G-3 0F0", "B-3 0F0", "F-3 0F0")
            NOTES("G-3 0F0", "B-3 0F0", "F-3 0F0", "G-3 0F0")
            NOTES("A-3 0F0", "E-3 0F0", "G-3 0F0", "A-3 0F0")
            NOTES("E-3 0F0", "G-3 0F0", "A-3 0F0", "E-3 0F0")
            NOTES("F#3 0F0", "A-3 0F0", "C-4 0F0", "F#3 0F0")
            NOTES("A-3 0F0", "C-4 0F0", "F#3 0F0", "A-3 0F0")
            NOTES("B-3 0F0", "F-3 0F0", "G-3 0F0", "B-3 0F0")
            NOTES("F-3 0F0", "G-3 0F0", "B-3 0F0", "G-3 0F0")

@@p1_05:    NOTES("A#1 1F1", "A#2 0F1", "A#1 0F1", "A#2 0F1")
            NOTES("C-2 0F1", "C-3 0F1", "C-2 0F1", "C-3 0F1")
            NOTES("C#2 0F1", "C#3 0F1", "C#2 0F1", "C#3 0F1")

            NOTES("G#1 0F1", "G#2 0F1", "G#1 0F1", "G#2 0F1")

            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("D-1 0F1", "D-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")

@@p2_05:    NOTES("NUL 101", "D-4 6F5", "D-4 8F7", "NUL 001")
            NOTES("D#4 8F5", "D#4 CF7", "", "")

            NOTES("NUL 001", "B-3 6F5", "C-4 DF7", "NUL 001")
            NOTES("C-4 AF5", "D-4 BF7", "", "")

@@p3_05:    NOTES("A#5 HF2", "G#5 0F2", "G-5 0F5", "G#5 0F0")
            NOTES("G-5 0F0", "F-5 0F0", "D#5 0F0", "F-5 0F2")

            NOTES("G#5 0F1", "F-5 0F1", "D#5 0F4", "")

            NOTES("G#5 0F0", "G-5 0F0", "F-5 0F0", "D#5 0F0")
            NOTES("D-5 0F2", "C-5 0F1", "D-5 0F1", "E-5 0F2")
            NOTES("C-5 0F3", "E-5 0F1", "F#5 0F2", "G-5 0F2")
            NOTES("A-5 0F1", "G-5 0F1", "B-5 0F1", "D-6 0F1")
            NOTES("G-6 0F1", "", "", "")

@@p3_06:    NOTES("F-6 HF1", "C-6 0F1", "F-5 0F2", "C-5 0F0")
            NOTES("F-5 0F0", "E-5 0F0", "F-5 0F0", "G-5 0F0")
            NOTES("G#5 0F1", "C-6 0F1", "A#5 0F2", "G#5 0F2")
            NOTES("G-5 0F9", "A#5 0F2", "G#5 0F1", "G-5 0F0")
            NOTES("F-5 0F7", "G#5 0F1", "G-5 0F2", "E-5 0F1")
            NOTES("D-5 0F0", "E-5 0F9", "", "")

@@p3_07:    NOTES("F-6 HF1", "C-6 0F1", "F-5 0F2", "C-5 0F0")
            NOTES("F-5 0F0", "E-5 0F0", "F-5 0F0", "G-5 0F0")
            NOTES("G#5 0F1", "C-6 0F1", "G-5 0F2", "G#5 0F2")
            NOTES("C-6 0F9", "G-5 0F2", "G#5 0F1", "G-5 0F0")
            NOTES("F-5 0F9", "G-5 0FF", "", "")

@@p0_08:    NOTES("D-4 GF0", "A#3 0F0", "G-3 0F0", "D-4 0F0")
            NOTES("A#3 0F0", "G-3 0F0", "D-4 0F0", "A#3 0F0")
            NOTES("C-4 0F0", "G-3 0F0", "E-3 0F0", "C-4 0F0")
            NOTES("G-3 0F0", "E-3 0F0", "C-4 0F0", "G-3 0F0")
            NOTES("C-4 0F0", "A-3 0F0", "F-3 0F0", "C-4 0F0")
            NOTES("A-3 0F0", "F-3 0F0", "C-4 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A-3 0F0", "F-3 0F0", "D-4 0F0")
            NOTES("A-3 0F0", "F-3 0F0", "D-4 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A#3 0F0", "G-3 0F0", "D-4 0F0")
            NOTES("A#3 0F0", "G-3 0F0", "D-4 0F0", "A#3 0F0")
            NOTES("C#4 0F0", "A-3 0F0", "E-3 0F0", "C#4 0F0")
            NOTES("A-3 0F0", "E-3 0F0", "C#4 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A-3 0F0", "F-3 0F0", "A-3 0F0")
            NOTES("B-3 0F0", "G#3 0F0", "E-3 0F0", "G#3 0F0")
            NOTES("C-4 0F0", "A-3 0F0", "F-3 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A-3 0F0", "F#3 0F0", "A-3 0F0")

@@p1_08:    NOTES("G-1 1F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("D-1 0F1", "D-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("A-1 0F1", "A-2 0F1", "A-1 0F1", "A-2 0F1")
            NOTES("D-1 0F1", "D-2 0F1", "E-1 0F1", "E-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F#1 0F1", "F#2 0F1")

@@p2_08:    NOTES("NUL 101", "G-4 7F5", "G-4 CF7", "NUL 001")
            NOTES("F-4 FF5", "F-4 DF7", "NUL 001", "G-4 7F5")
            NOTES("A-4 FF7", "NUL 001", "D-4 7F1", "E-4 FF3")
            NOTES("F-4 FF3", "F#4 EF3", "", "")

@@p3_08:    NOTES("G-6 HF1", "D-6 0F1", "G-5 0F2", "D-5 0F0")
            NOTES("E-5 0F0", "F-5 0F0", "G-5 0F0", "A-5 0F0")
            NOTES("A#5 0F1", "D-6 0F1", "C-6 0F2", "A#5 0F2")
            NOTES("A-5 0F9", "C-6 0F2", "A#5 0F1", "A-5 0F0")
            NOTES("G-5 0F7", "E-5 0F1", "G-5 0F2", "F-5 0F1")
            NOTES("E-5 0F0", "D-5 0F9", "", "")

@@p0_09:    NOTES("D-4 GF0", "A#3 0F0", "G-3 0F0", "D-4 0F0")
            NOTES("A#3 0F0", "G-3 0F0", "D-4 0F0", "A#3 0F0")
            NOTES("C-4 0F0", "G-3 0F0", "E-3 0F0", "C-4 0F0")
            NOTES("G-3 0F0", "E-3 0F0", "C-4 0F0", "G-3 0F0")
            NOTES("C-4 0F0", "A-3 0F0", "F-3 0F0", "C-4 0F0")
            NOTES("A-3 0F0", "F-3 0F0", "C-4 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A-3 0F0", "F-3 0F0", "D-4 0F0")
            NOTES("A-3 0F0", "F-3 0F0", "D-4 0F0", "A-3 0F0")
            NOTES("D-4 0F0", "A#3 0F0", "G-3 0F0", "D-4 0F0")
            NOTES("A#3 0F0", "G-3 0F0", "D-4 0F0", "A#3 0F0")
            NOTES("C-4 0F0", "G-3 0F0", "E-3 0F0", "C-4 0F0")
            NOTES("G-3 0F0", "E-3 0F0", "C-4 0F0", "G-3 0F0")
            NOTES("C-4 0F0", "A-3 0F0", "F-3 0F0", "C-4 0F0")
            NOTES("A-3 0F0", "F-3 0F0", "C-4 0F0", "A-3 0F0")
            NOTES("C-4 0F0", "G-3 0F0", "E-3 0F0", "C-4 0F0")
            NOTES("G-3 0F0", "E-3 0F0", "C-4 0F0", "G-3 0F0")

@@p1_09:    NOTES("G-1 1F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("D-1 0F1", "D-2 0F1", "D-1 0F1", "D-2 0F1")
            NOTES("G-1 0F1", "G-2 0F1", "G-1 0F1", "G-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")
            NOTES("F-1 0F1", "F-2 0F1", "F-1 0F1", "F-2 0F1")
            NOTES("C-1 0F1", "C-2 0F1", "C-1 0F1", "C-2 0F1")

@@p2_09:    NOTES("NUL 101", "G-4 7F5", "G-4 CF7", "NUL 001")
            NOTES("F-4 FF5", "F-4 DF7", "NUL 001", "G-4 7F5")
            NOTES("G-4 CF7", "NUL 001", "F-4 FF5", "G-4 CF7")

@@p3_09:    NOTES("G-6 HF1", "D-6 0F1", "G-5 0F2", "D-5 0F0")
            NOTES("E-5 0F0", "F-5 0F0", "G-5 0F0", "A-5 0F0")
            NOTES("A#5 0F1", "D-6 0F1", "C-6 0F2", "D-6 0F2")
            NOTES("F-6 0F9", "A-5 0F2", "G-5 0F1", "F-5 0F0")
            NOTES("E-5 0F9", "F-5 IFF", "", "")

@@p3_10:    NOTES("NUL HFF", "NUL 0FF", "NUL 00F", "NUL 00F")
            ENDP

;; ======================================================================== ;;
;;  End of File:  space-6ch.asm                                             ;;
;; ======================================================================== ;;
