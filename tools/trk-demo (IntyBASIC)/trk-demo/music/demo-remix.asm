;* ======================================================================== *;
;*  This code is placed into the public domain by its collective authors.   *;
;*  All copyright rights are hereby relinquished on the code and data in    *;
;*  this file.                                                              *;
;*      -- Arnauld Chevallier, 2018                                         *;
;*      -- James Pujals, 2020                                               *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  SONG: Demo Song (Remix)                                                 ;;
;;      This song was included in Arnauld Chevallier's original public      ;;
;;      distribution of his music tracker.  Its purpose was to demonstrate  ;;
;;      the full range of capabilities of the tracker at the time.          ;;
;;                                                                          ;;
;;      This new version has been re-tracked and remixed by DZ-Jay to take  ;;
;;      advantage of the latest Intellivision Music Tracker features,       ;;
;;      including 6-channel polyphony and dual drum tracks.                 ;;
;;                                                                          ;;
;;      Composed By:    Arnauld Chevallier                                  ;;
;;      Tracked By:     Arnauld Chevallier                                  ;;
;;      Remixed By:     James Pujals (DZ-Jay)                               ;;
;; ======================================================================== ;;
DEMO_REMIX  PROC

; ------------------------------------------------------------------------- ;
;  Song Header                                                              ;
; ------------------------------------------------------------------------- ;
            DECLE   6, @@patterns, @@instr, @@drums

; ------------------------------------------------------------------------- ;
;  Sequence                                                                 ;
; ------------------------------------------------------------------------- ;
            DECLE    5,  6,  7,  7                              ; Intro
            DECLE    0,  1,  2,  3,  0,  1,  2,  4,  0,  1      ; Song  <----------,
            DECLE   11, 12, 13, 14,  9, 10,  0,  1,  8, 12      ; Break            |
            DECLE   -18                                         ; Rinse & Repeat --'

; ------------------------------------------------------------------------- ;
;  Channel Patterns                                                         ;
; ------------------------------------------------------------------------- ;
            ;           Drums1   Bass   Synth   Drums2  Melody  Unused
            ;           ------  ------  ------  ------  ------  ------
@@patterns: DECLE   32, @@d0b1, @@p000, @@p001, @@d0h1, @@p002, @@pXXX  ; #0
            DECLE   32, @@d0b2, @@p000, @@p001, @@d0h2, @@p003, @@pXXX  ; #1
            DECLE   32, @@d0b2, @@p000, @@p001, @@d0h1, @@p004, @@pXXX  ; #2
            DECLE   32, @@d0b4, @@p000, @@p001, @@d0h1, @@p005, @@pXXX  ; #3
            DECLE   32, @@d0b3, @@p000, @@p001, @@d0h2, @@p006, @@pXXX  ; #4

            ; Break tracks
            DECLE   32, @@d0b1, @@pXXX, @@pXXX, @@d0h1, @@pXXX, @@pXXX  ; #5
            DECLE   32, @@d0b3, @@pXXX, @@pXXX, @@d0h2, @@pXXX, @@pXXX  ; #6

            DECLE   32, @@d0b1, @@p000, @@pXXX, @@d0h1, @@pXXX, @@pXXX  ; #7
            DECLE   32, @@d0b1, @@p000, @@p008, @@d0h2, @@p002, @@pXXX  ; #8

            DECLE   32, @@d0b1, @@pXXX, @@p001, @@d0h1, @@pXXX, @@pXXX  ; #9
            DECLE   32, @@d0b4, @@pXXX, @@p001, @@d0h2, @@pXXX, @@pXXX  ; #10

            DECLE   32, @@d0b4, @@p000, @@p007, @@d0h1, @@p002, @@pXXX  ; #11
            DECLE   32, @@d0b3, @@p000, @@pXXX, @@d0h2, @@p003, @@pXXX  ; #12

            DECLE   32, @@d0b4, @@p000, @@pXXX, @@d0h3, @@pXXX, @@pXXX  ; #13
            DECLE   32, @@d0b3, @@p000, @@pXXX, @@d0h3, @@p003, @@pXXX  ; #14


; ------------------------------------------------------------------------- ;
;  Instruments                                                              ;
; ------------------------------------------------------------------------- ;
@@instr:    DECLE   MUSIC.pitch01, 1, MUSIC.env02   ; #1
            DECLE   MUSIC.pitch01, 2, MUSIC.env01   ; #2
            DECLE   MUSIC.pitch02, 2, MUSIC.env02   ; #3
            DECLE   MUSIC.pitch01, 2, MUSIC.env02   ; #4
            DECLE   MUSIC.pitch01, 3, MUSIC.env01   ; #5

; ------------------------------------------------------------------------- ;
;  Drum Kit                                                                 ;
; ------------------------------------------------------------------------- ;
@@drums:    DECLE   MUSIC.bassdrum                  ; #1
            DECLE   MUSIC.snare                     ; #2
            DECLE   MUSIC.hh_closed                 ; #3
            DECLE   MUSIC.hh_open                   ; #4

; ------------------------------------------------------------------------- ;
;  Sub-Patterns                                                             ;
; ------------------------------------------------------------------------- ;
            ; Base beat patterns
@@d0b1:     NOTES("DRM 1F3", "DRM 2F3", "DRM 1F1", "DRM 1F1")
            NOTES("DRM 2F3", "DRM 1F3", "DRM 2F3", "DRM 1F1")
            NOTES("DRM 1F1", "DRM 2F1", "DRM 1F1", "")

@@d0b2:     NOTES("DRM 1F3", "DRM 2F3", "DRM 1F1", "DRM 1F1")
            NOTES("DRM 2F3", "DRM 1F3", "DRM 2F3", "DRM 1F1")
            NOTES("DRM 1F1", "DRM 2F1", "DRM 2F1", "")

@@d0b3:     NOTES("DRM 1F3", "DRM 2F3", "DRM 1F1", "DRM 1F1")
            NOTES("DRM 2F3", "DRM 1F3", "DRM 2F2", "DRM 2F0")
            NOTES("DRM 1F1", "DRM 2F0", "NUL 2F0", "DRM 2F1")
            NOTES("DRM 2F0", "DRM 2F0", "", "")

@@d0b4:     NOTES("DRM 1F3", "DRM 2F3", "DRM 1F1", "DRM 1F1")
            NOTES("DRM 2F3", "DRM 1F3", "DRM 2F3", "DRM 1F2")
            NOTES("DRM 1F0", "DRM 2F1", "DRM 1F0", "DRM 1F0")

            ; Hi-hat patterns
@@d0h1:     NOTES("DRM 3F1", "DRM 3D1", "DRM 3F1", "DRM 3D1")
            NOTES("DRM 3F1", "DRM 3D1", "DRM 3F1", "DRM 3D0")
            NOTES("DRM 3D0", "DRM 3F1", "DRM 3D1", "DRM 3F1")
            NOTES("DRM 3D1", "DRM 3F1", "DRM 3D0", "DRM 3D0")
            NOTES("DRM 3F0", "DRM 3D0", "DRM 4E1", "")

@@d0h2:     NOTES("DRM 3F1", "DRM 3D1", "DRM 3F1", "DRM 3D1")
            NOTES("DRM 3F1", "DRM 3D1", "DRM 3F1", "DRM 3D0")
            NOTES("DRM 3D0", "DRM 3F1", "DRM 3D1", "DRM 3F0")
            NOTES("DRM 3D0", "DRM 4E1", "DRM 3F1", "DRM 4D0")
            NOTES("DRM 3D0", "DRM 3F0", "DRM 4E2", "")

@@d0h3:     NOTES("DRM 3F1", "DRM 4E1", "DRM 3F1", "DRM 4E1")
            NOTES("DRM 3F1", "DRM 4E1", "DRM 3F1", "DRM 4E1")
            NOTES("DRM 3F1", "DRM 4E1", "DRM 3F1", "DRM 4E1")
            NOTES("DRM 3F1", "DRM 4E1", "DRM 3E1", "DRM 4E1")

            ; Music patterns
@@p000:     NOTES("A-1 1F0", "A-2 1E0", "A-1 1F0", "A-2 1E0")
            NOTES("A-1 1F0", "A-2 1E0", "A-1 1F0", "A-2 1E0")
            NOTES("A-1 1F0", "A-2 1E0", "A-1 1F0", "A-2 1E0")
            NOTES("A-1 1F0", "A-2 1E0", "A-1 1F0", "A-2 1E0")
            NOTES("E-1 1F0", "E-2 1E0", "E-1 1F0", "E-2 1E0")
            NOTES("E-1 1F0", "E-2 1E0", "E-1 1F0", "E-2 1E0")
            NOTES("E-1 1F0", "E-3 1E0", "E-2 1F0", "E-3 1E0")
            NOTES("E-2 1F0", "E-3 1E0", "E-2 1F0", "E-3 1E0")

@@p001:     NOTES("A-3 2E3", "C-4 2E2", "E-4 2E0", "F-4 2E1")
            NOTES("E-4 2E1", "C-4 2E3", "A-3 2E3", "C-4 2E2")
            NOTES("E-4 2E0", "F-4 2E1", "A-4 2E1", "G-4 2E3")

@@p002:     NOTES("A-5 3F7", "G-5 3F7", "E-5 3F7", "D-5 3F1")
            NOTES("E-5 3F5", "", "", "")

@@p003:     NOTES("A-5 3F7", "G-5 3F7", "E-5 3F7", "F-5 3F1")
            NOTES("E-5 3F5", "", "", "")

@@p004:     NOTES("A-5 4F3", "G-5 4F1", "A-5 4F1", "C-6 4F1")
            NOTES("B-5 4F2", "A-5 4F0", "G-5 4F1", "E-5 4F3")
            NOTES("D-5 4F1", "E-5 4F3", "A-5 4F1", "G-5 4F3")

@@p005:     NOTES("A-5 4F3", "G-5 4F1", "A-5 4F1", "C-6 4F1")
            NOTES("B-5 4F3", "C-6 4F0", "D-6 4F0", "E-6 4F1")
            NOTES("C-6 4F1", "B-5 4F1", "G-5 4F1", "C-6 4F1")
            NOTES("A-5 4F1", "F-5 4F1", "G-5 4F1", "")

@@p006:     NOTES("A-5 4F3", "G-5 4F1", "A-5 4F1", "C-6 4F1")
            NOTES("B-5 4F3", "C-6 4F0", "D-6 4F0", "E-6 4F0")
            NOTES("F-6 4F0", "E-6 4F1", "E-6 4F0", "F-6 4F0")
            NOTES("E-6 4F0", "D-6 4F0", "E-6 4F0", "D-6 4F0")
            NOTES("C-6 4F0", "B-5 4F0", "C-6 4F0", "B-5 4F0")
            NOTES("A-5 4F0", "G-5 4F0", "", "")

            ; Sustained long notes over entire pattern
@@p007:     NOTES("A-4 5EF", "NUL 5EF", "", "")
@@p008:     NOTES("NUL 5EF", "NUL 5EF", "", "")

            ; Silence throughout entire pattern
@@pXXX:     NOTES("NUL 20F", "NUL 20F", "", "")
            ENDP

;; ======================================================================== ;;
;;  End of File:  demo-remix.asm                                            ;;
;; ======================================================================== ;;
