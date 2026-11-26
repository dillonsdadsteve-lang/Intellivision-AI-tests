;;==========================================================================;;
;; Title:       Intellivision Mustic Tracker (v1.5) Demo                    ;;
;; By:          James Pujals <dz-game AT techunlimited.net>                 ;;
;;                                                                          ;;
;; Description: A simple program to demonstrate the capabilities of the     ;;
;;              music tracker library, and to illustrate how to use it.     ;;
;;                                                                          ;;
;; ------------------------------------------------------------------------ ;;
;;  These routines are placed into the public domain by their authors.  All ;;
;;  copyright rights are hereby relinquished on the routines and data in    ;;
;;  this file.  -- James Pujals, 2020                                       ;;
;;==========================================================================;;

        LISTING "on"

;; ======================================================================== ;;
;; ROM HEADER SET-UP                                                        ;;
;; ======================================================================== ;;
                INCLUDE "sdk/cart.mac"
                INCLUDE "sdk/gimini.asm"

                REQ_ECS     ; ECS unit required!
                ROMSETUP 16K, 2020, "Tracker Demo", MAIN, 16
                ROMSEG  0

                INCLUDE "lib/asm-interface.asm"
                INCLUDE "sdk/print.asm"

;; ======================================================================== ;;
;;  MAIN:   This routine will be called directly by the EXEC during its     ;;
;;          initialization process; we intercept it at that point and take  ;;
;;          over.  This routine will then serve as our program initializer. ;;
;;                                                                          ;;
;;          Our program is initialized by doing the following:              ;;
;;              1. Set up a basic Interrupt Service Routine (ISR)           ;;
;;              2. Fix the title screen.                                    ;;
;;              3. Initialize the tracker sub-system.                       ;;
;;              4. Load and play our demo song.                             ;;
;;              5. Loop forever and let the tracker play.                   ;;
;;                                                                          ;;
;;          The tracker state will be updated automatically by the ISR on   ;;
;;          every frame refresh, which will play the song in the background ;;
;;          without any further program intervention.                       ;;
;; ======================================================================== ;;
MAIN            PROC
                ; 1. Set up basic ISR
                ; ------------------------------
                MVII    #ISR,   R0
                MVO     R0,     $100
                SWAP    R0
                MVO     R0,     $101

                EIS                             ; Enable interrupts

                ; 2. Fix title screen
                ; ------------------------------
                CALL    PRINT.FLS               ; Overwrite title
                DECLE   7
                DECLE   $200 + 3*20 + 1
                DECLE   "   James Pujals   ", 0

                CALL    PRINT.FLS               ; Add tracker version
                DECLE   7
                DECLE   $200 + 8*20 + 7
                DECLE   "(v1.5)", 0

                CALL    PRINT.FLS               ; Remove copyright
                DECLE   7
                DECLE   $200 + 10*20 + 1
                DECLE   "  31 August 2020  ", 0

                ; 3. Initialize tracker
                ; ------------------------------
                CALL    TRKINIT
                SET_ACTIVE_CHANNELS(6)          ; Enable all channels

                ; 4. Load song and play
                ; ------------------------------
                CALL    TRKSNGINIT
                DECLE   DRUMS_DEMO
                ; DECLE   DEMO_REMIX
                ; DECLE   BUTTERFLY
                ; DECLE   SPACE_MUSIC
                ; DECLE   VOYAGE
                ; DECLE   BEAT_IT

                ; 5. Loop forever and play
                ; ------------------------------
@@loop:         DECR    PC
                ENDP

;; ======================================================================== ;;
;;  ISR   -- A simple ISR to keep the screen enabled.                       ;;
;; ======================================================================== ;;
ISR             PROC
                BEGIN

                MVO     R0,     $20     ; STIC handshake to keep display enabled

                CALL    TRKPLAY         ; Update the music tracker

                RETURN
                ENDP

                INCLUDE "songs/global-music.asm"
                INCLUDE "songs/drums-demo.asm"
                ; INCLUDE "songs/space-6ch.asm"
                ; INCLUDE "songs/butterfly.asm"
                ; INCLUDE "songs/voyage-6ch.asm"
                ; INCLUDE "songs/test-drums.asm"
                ; INCLUDE "songs/simple-song.asm"
                ; INCLUDE "songs/demo-remix.asm"
                ; INCLUDE "songs/beatit-remix.asm"

;; ======================================================================== ;;
;;  End of File:  trk-demo.asm                                              ;;
;; ======================================================================== ;;
