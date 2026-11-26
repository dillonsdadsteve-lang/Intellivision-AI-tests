;* ======================================================================== *;
;*  These routines are placed into the public domain by their authors.  All *;
;*  copyright rights are hereby relinquished on the routines and data in    *;
;*  this file.  -- Arnauld Chevallier, 2008; James Pujals, 2017             *;
;* ======================================================================== *;

;; ======================================================================== ;;
;; Intellivision Music Tracker (version 1.5, rev. #4)                       ;;
;; ------------------------------------------------------------------------ ;;
;;                                                                          ;;
;;  TRKINIT       Global tracker initialization                             ;;
;;  TRKSNGINIT    Song initialization                                       ;;
;;  TRKSNGINIT.1  Alternate entry point                                     ;;
;;  TRKPLAY       Ticks the tracker and updates the PSG                     ;;
;;                                                                          ;;
;;  TRKPATINIT    (internal) Pattern initialization                         ;;
;;  TRKPSGINIT    (internal) PSG device initialization                      ;;
;;  TRKCHUPD      (internal) Updates one channel                            ;;
;;  TRKPSGUPD     (internal) Updates one PSG device                         ;;
;;                                                                          ;;
;; ------------------------------------------------------------------------ ;;
;;  WARNING:                                                                ;;
;;      The routines below have been heavily optimized for speed and size,  ;;
;;      and some of those optimizations rely on assumptions about the       ;;
;;      intricate layout of the code.  Any changes must therefore account   ;;
;;      for these assumptions, or run the risk of breaking the library.     ;;
;;                                                                          ;;
;;      You are encouraged to explore the code, but you are advised to only ;;
;;      make changes if you are *absolutely* sure of what you are doing.    ;;
;;                                                                          ;;
;;      YOU HAVE BEEN WARNED.                                               ;;
;; ------------------------------------------------------------------------ ;;
;;  AUTHORS & CONTRIBUTORS                                                  ;;
;;      Originally created and released publicly by Arnauld Chevallier;     ;;
;;      later modified by James Pujals to include new features, address     ;;
;;      some bugs, and optimize for performance.                            ;;
;;                                                                          ;;
;;      Created By:     Arnauld Chevallier <a_chevallier AT yahoo.com>      ;;
;;      Updated By:     James Pujals <dz-game AT techunlimited.net>         ;;
;;      Thanks To:      Shazz & Zapac for their creative input!             ;;
;; ------------------------------------------------------------------------ ;;
;;  REVISION HISTORY                                                        ;;
;;      07-Sep-2008 Initial Revision                                        ;;
;;      10-Jun-2017 Modified by DZ-Jay to support drum instruments and      ;;
;;                  second PSG from ECS module.  Also patched some bugs and ;;
;;                  optimised processing for performance.                   ;;
;;      12-Apr-2018 Finally fixed drums+tone bug so that you can use the A  ;;
;;                  Channel for either, interchangeably.                    ;;
;;      31-Jul-2020 Marked-up with comments and cleaned up the source for   ;;
;;                  public release.  Also made 6-channel support optional,  ;;
;;                  with an explicit conditional symbol (TRK_ENABLED_6_CHN).;;
;;      09-Aug-2020 That drum fix from 2018? Didn't work. It is now fixed   ;;
;;                  and fully tested, so I am absolutely sure.  Drums and   ;;
;;                  tones can now be used interchangeably on channel "A"    ;;
;;                  in either PSG, independently.  YAY!!!                   ;;
;;      24-Aug-2020 Fixed drums to honor volume in DRUM() note declaration. ;;
;;                  This allows for accents and other performance niceties. ;;
;;      29-Dec-2020 Updated library to support flexible interface for ASM   ;;
;;                  and IntyBASIC integration.                              ;;
;;      ------------------------------------------------------------------- ;;
;;      10-Jan-2021 Rev. #1                                                 ;;
;;                  Happy New Year! Fixed a bug that caused proc TRKPATINIT ;;
;;                  to skip 7 words per pattern instead of 4 when, when the ;;
;;                  6-channel support (TRK_ENABLED_6_CHN) is disabled.      ;;
;;                                                                          ;;
;;                  Adjusted envelope synthesizer to support five levels    ;;
;;                  (0..4), which allows single-tick advancements.          ;;
;;                                                                          ;;
;;      22-Jan-2021 Rev. #2                                                 ;;
;;                  NPK.Note() did not treat NUL events at the top of the   ;;
;;                  pattern as a new event, and therefore skipped them.     ;;
;;                                                                          ;;
;;                  Added new instruments to the Global Music module.       ;;
;;                                                                          ;;
;;                  Updated procedure TRKPATINIT to skip PSG updates        ;;
;;                  completely when the end of song marker is detected.     ;;
;;                  This ensures that the tracker stays silent, even if     ;;
;;                  notes were still active.                                ;;
;;                                                                          ;;
;;                  NPK.Note() did not verify that DRM events had a valid   ;;
;;                  instrument number.                                      ;;
;;                                                                          ;;
;;                  NPK.Note() did not compact same instrument in multiple  ;;
;;                  note events.                                            ;;
;;                                                                          ;;
;;      03-Feb-2021 Rev. #3                                                 ;;
;;                  Added "Active Channel State" to selectively enable      ;;
;;                  playback channels.  This is implemented by re-arranging ;;
;;                  the call order of the TRKPSGUPD "call-chain" and        ;;
;;                  skipping any inactive channels, based on priority.      ;;
;;                                                                          ;;
;;                  Re-organized the integration interface and extracted    ;;
;;                  all IntyBASIC alternative interfaces into a new module. ;;
;;                                                                          ;;
;;      07-Mar-2021 Rev. #4                                                 ;;
;;                  Instrument envelopes now recycle indefinitely, by       ;;
;;                  backtracking a number of sample points from the end.    ;;
;;                  The backtracking offset is configurable with a global   ;;
;;                  constant (TRK_ENV_REWIND_COUNT).                        ;;
;;                                                                          ;;
;;                  Optimized the code for size and speed to compensate for ;;
;;                  additional code brought in by recent enhancements.      ;;
;;                                                                          ;;
;;                  Changed the behaviour of "NULL" events that include     ;;
;;                  instrument changes, to reset the channel counter.  The  ;;
;;                  old behaviour is believed to be a bug.                  ;;
;; ------------------------------------------------------------------------ ;;
;;                                                                          ;;
;;  INPUTS for TRKINIT                                                      ;;
;;      None                                                                ;;
;;                                                                          ;;
;;  INPUTS for TRKSNGINIT                                                   ;;
;;      R5      Pointer to invocation record, followed by return address    ;;
;;              Song base address               1 DECLE                     ;;
;;                                                                          ;;
;;  INPUTS for TRKSNGINIT.1                                                 ;;
;;      R1      Song base address                                           ;;
;;                                                                          ;;
;;  INPUTS for TRKPLAY                                                      ;;
;;      None                                                                ;;
;;                                                                          ;;
;;  CODESIZE                                                                ;;
;;      569     words (6-channels)                                          ;;
;;      543     words (3-channels)                                          ;;
;;                                                                          ;;
;; ======================================================================== ;;

;; ======================================================================== ;;
;;  TRKSNGINIT    Song initialization                                       ;;
;;      R5: Input record followed by return address:                        ;;
;;          Pointer to song address                                         ;;
;;                                                                          ;;
;;  @@1:                                                                    ;;
;;      R1: Song address                                                    ;;
;;      R5: Return address                                                  ;;
;; ======================================================================== ;;
TRKSNGINIT      PROC
                MVI@    R5,     R1                          ; \_ Retrieve the song address and store it
@@1:            MVO     R1,     _w_var(SONG)                ; /

                ; Extract song header:
                ; ------------------------------------------
                ADDI    #2,     R1                          ; \_ @@instr
                MVI@    R1,     R1                          ; /
                MVO     R1,     _w_var(INS_PTR)             ;     Retrieve instrument record address and store it

                MVII    #TRK_BYTEVAR.SIZE,      R1          ; Clear all 8-bit variables
                MVII    #TRK_BYTEVAR.START,     R4
                CLRR    R0
@@__loop:       MVO@    R0,     R4
                DECR    R1
                BNZE    @@__loop

                MVII    #TRK_GLOBAL_FADER,  R0
                MVO     R0,     _b_var(MASTER_FADER)        ; default global volume fading

                ; NOTE:
                ;   Routine falls through onto next, so
                ;   that the first pattern is initialized
                ;   as part of the song initialization.
                ;           ,_____,
                ;           |     |
                ;           |     |
                ;        ,__|     |__,
                ;         \         /
                ;           \     /
                ;             \,/
            ENDP

;; ======================================================================== ;;
;;  TRKPATINIT    Pattern initialization                                    ;;
;; ======================================================================== ;;
TRKPATINIT      PROC
                MVI     _w_var(SONG),  R4
                INCR    R4                                  ; skip speed
                MVI@    R4,     R2                          ; R2 = address of 1st pattern
                ADDI    #2,     R4                          ; skip instruments and drums ptr
                MVI     _b_var(PAT),   R0                   ; R0 = position in patterns order table
                ADDR    R0,     R4

                ; ------------------------------------------
                ; Check if we found the end of the song.
                ; ------------------------------------------
                MVI@    R4,     R1                          ; R1 = pattern number
                TSTR    R1
                BPL     @@pat_ok                            ; end of patterns ? ...

                CMPI    #TRK_END_SONG, R1                   ; ... yes : stop replay ?
                BEQ     @@end_song

@@rewind:       ADDR    R1,     R0                          ; ... no : jump to loop position ...
                ADDR    R1,     R4
                DECR    R4
                MVI@    R4,     R1                          ; ... and read again

@@pat_ok:       INCR    R0                                  ; increment position
                MVO     R0,     _b_var(PAT)                 ; in patterns order table

            IF (TRK_ENABLED_6_CHN)
                MOVR    R1,     R0                          ; Skip to next record: 7x words ahead from @@patterns
                SLL     R1,     2                           ; R4 = ((R1 * 8) - R1) + R2 (address of 1st pattern)
                SLL     R1,     1
                SUBR    R0,     R1
            ELSE                                            ; Skip to next record: 4x words ahead from @@patterns
                SLL     R1,     2                           ; R4 = (R1 * 4) + R2 (address of 1st pattern)
            ENDI

                MOVR    R1,     R4                          ; (beginning of pattern's details)
                ADDR    R2,     R4

                MVI@    R4,     R0                          ; save pattern counter (length, first DECLE in @@patterns)
                MVO     R0,     _b_var(COUNT_P)

                MOVR    R5,     R2                          ; Save the return address

                MVII    #_w_var(POS_A), R5                  ; Get base address of channel pattern position records

            REPEAT (TRK_MAX_CHANNELS)                       ; Update channel pattern positions
                MVI@    R4,     R0
                MVO@    R0,     R5
            ENDR

                JR      R2                                  ; Return

                ; NEAT HACK:
                ;   Change the return address to bypass
                ;   PSG updates in TRKPLAY().
                ; ------------------------------------------
@@end_song:     MVII    #TRKPLAY.done,  R2                  ; Change the return address ...
                DECLE   $0208                               ;   ... Skip next instruction (NOPP)

                ; NOTE:
                ;   Routine falls through onto next, so
                ;   that we initialize the PSG devices
                ;   on our way out the door.
                ;           ,_____,
                ;           |     |
                ;           |     |
                ;        ,__|     |__,
                ;         \         /
                ;           \     /
                ;             \,/
                ENDP

;; ======================================================================== ;;
;;  TRKINIT       Global tracker initialization                             ;;
;; ======================================================================== ;;
TRKINIT         PROC
                MOVR    R5,     R2

                CLRR    R0
                MVO     R0,     _b_var(CHN_STATE)           ; Reset active-channel state (all active)
                MVO     R0,     _w_var(SONG)                ; Clear song pointer
                MVO     R0,     _b_var(MASTER_FADER)        ; Reset global volume fader

                MVII    #TRKPSGINIT.call_chain, R5          ; Engage call-chain (just fall through)

                ; NOTE:
                ;   Routine falls through onto next, so
                ;   that we reset each PSG device
                ;   individually, as part of tracker
                ;   global initialization.
                ;           ,_____,
                ;           |     |
                ;           |     |
                ;        ,__|     |__,
                ;         \         /
                ;           \     /
                ;             \,/
            ENDP

;; ======================================================================== ;;
;;  TRKPSGINIT      PSG initialization                                      ;;
;;      R2: Return address                                                  ;;
;;      R5: Input record:                                                   ;;
;;          Pointer to PSG address                                          ;;
;; ======================================================================== ;;
TRKPSGINIT      PROC
                MVI@    R5,     R4                          ; Get PSG base address argument ($xF0)

                CLRR    R0
                                                            ; Clear all channel periods / low, use auto increm
                MVO@    R0,     R4                          ;   @@chn_a_lo ($xF0 ch A)
                MVO@    R0,     R4                          ;   @@chn_b_lo ($xF1 ch B)
                MVO@    R0,     R4                          ;   @@chn_c_lo ($xF2 ch C)

                INCR    R4                                  ; Skip @@envlp_lo
                                                            ; Clear all channel periods / hi
                MVO@    R0,     R4                          ;   @@chn_a_hi ($xF4 ch A)
                MVO@    R0,     R4                          ;   @@chn_b_hi ($xF5 ch B)
                MVO@    R0,     R4                          ;   @@chn_c_hi ($xF6 ch C)

                INCR    R4                                  ; Skip @@envlp_hi
                MVII    #$38,   R1                          ; Enable I/O port, enable tone, disable noise
                MVO@    R1,     R4                          ;   @@chan_enable ($xF8)

                ADDI    #2,     R4                          ; Skip to @@chn_a_vol
                                                            ; Clear all channel volumes
                MVO@    R0,     R4                          ;   @@chn_a_vol ($xFB ch A)
                MVO@    R0,     R4                          ;   @@chn_b_vol ($xFC ch B)
                MVO@    R0,     R4                          ;   @@chn_c_vol ($xFD ch C)

                MVI@    R5,     PC                          ; Jump to next procedure in chain

@@call_chain:   ; -----------------------------------------
                ; Call-chain to initialize PSG devices
                ; -----------------------------------------
                DECLE   PSG0                                ; Initialize PSG #0

        IF (TRK_ENABLED_6_CHN)
                DECLE   TRKPSGINIT
                DECLE   PSG1                                ; Initialize PSG #1
        ENDI

                DECLE   ($ + 1)                             ; End call-chain

@@return:       JR      R2                                  ; Return to caller
                ENDP

;; ======================================================================== ;;
;;  TRKPLAY       Ticks the tracker and updates the PSG                     ;;
;; ======================================================================== ;;
TRKPLAY         PROC
                BEGIN

                MVI     _w_var(SONG),     R1                ; R1 = song base address
                TSTR    R1                                  ; is a song actually playing ?
                BEQ     @@done

                MVI     _b_var(COUNT_M),  R0                ; ... yes : increment global music counter
                INCR    R0
                MVO     R0,     _b_var(COUNT_M)

                MVI     _b_var(REF_M),    R0                ; refresh notes ?
                DECR    R0
                MVO     R0,     _b_var(REF_M)
                BPL     @@upd_psg                           ; ... no : update PSG

                MVI@    R1,     R0                          ; ... yes : read speed
                MVO     R0,     _b_var(REF_M)

                ; -----------------------------------------
                ; The call-chain below avoids having to
                ; CALL-then-RETURN from a procedure, only
                ; to CALL another one.  We save about 2/3
                ; of the cycle cost from calling normally.
                ; -----------------------------------------
@@upd_chn:      CALL    TRKCHUPD                            ; Engage call-chain
                DECLE   _b_var(REF_A)

                DECLE   TRKCHUPD
                DECLE   _b_var(REF_B)

                DECLE   TRKCHUPD
                DECLE   _b_var(REF_C)

        IF (TRK_ENABLED_6_CHN)
                DECLE   TRKCHUPD
                DECLE   _b_var(REF_D)

                DECLE   TRKCHUPD
                DECLE   _b_var(REF_E)

                DECLE   TRKCHUPD
                DECLE   _b_var(REF_F)
        ENDI

                DECLE   ($ + 1)                             ; End call-chain

                MVII    #@@upd_psg,         R5              ; Set return address to avoid an expensive
                                                            ;   CALL after BNZE test.

                MVI     _b_var(COUNT_P),    R0              ; \
                DECR    R0                                  ;  > Decrement pattern counter (--COUNT_P)
                MVO     R0,     _b_var(COUNT_P)             ; /
                BZE     TRKPATINIT                          ; If zero, get and initialize new pattern.
                                                            ;   (Branch directly is cheaper than BNZE + CALL.)
                ; -----------------------------------------
                ; The call-chain below avoids having to
                ; CALL-then-RETURN from a procedure, only
                ; to CALL another one.  We save about 2/3
                ; of the cycle cost from calling normally.
                ; -----------------------------------------
@@upd_psg:      MVII    #@@__psg_tbl,       R5              ; \_ Compute call-chain starting point
                ADD     _b_var(CHN_STATE),  R5              ; /
                MVI@    R5,     PC                          ; Engage call-chain

@@__psg_tbl:    DECLE   TRKPSGUPD                           ; Channel #6: offset 0
                DECLE   _b_var(NOTE_C)
                DECLE   PSG0.chn_c_lo

        IF (TRK_ENABLED_6_CHN)
                DECLE   TRKPSGUPD                           ; Channel #5: offset 3
                DECLE   _b_var(NOTE_F)
                DECLE   PSG1.chn_c_lo

                DECLE   TRKPSGUPD                           ; Channel #4: offset 6
                DECLE   _b_var(NOTE_E)
                DECLE   PSG1.chn_b_lo

                DECLE   TRKPSGUPD                           ; Channel #3: offset 9
                DECLE   _b_var(NOTE_D)
                DECLE   PSG1.chn_a_lo
        ENDI

                DECLE   TRKPSGUPD                           ; Channel #2: offset 12
                DECLE   _b_var(NOTE_B)
                DECLE   PSG0.chn_b_lo

                DECLE   TRKPSGUPD                           ; Channel #1: offset 15
                DECLE   _b_var(NOTE_A)
                DECLE   PSG0.chn_a_lo

                DECLE   ($ + 1)                             ; End call-chain

@@done:         RETURN
                ENDP

;; ======================================================================== ;;
;;  TRKCHUPD      Updates a channel                                         ;;
;;      R5: Input record followed by return address:                        ;;
;;          Pointer to channel x refresh counter (REF_x)                    ;;
;; ======================================================================== ;;
TRKCHUPD        PROC
                MVI@    R5,     R3                          ; Get channel argument

                MVI@    R3,     R0                          ; (R3 = REF_x)
                SUBI    #$10,   R0                          ; Decrement counter (it's shifted left 4-bits: counter -= 16)
                BPL     @@ch_updt                           ;   >= 0: Update channel counter and exit
                                                            ;   <  0: Reset channel

@@ch_new:       ADDI    #_bw_vardlt(REF_A, POS_A),  R3      ; (R3 = POS_x)
                MVI@    R3,     R4                          ; Get pointer to sub-pattern to play
                MVI@    R4,     R0                          ; Get content of sub-pattern (row event)

                MOVR    R0,     R1                          ; See if the event includes a change in instrument:
                BPL     @@data_ok                           ;   >= 0: No instrument change, continue
                                                            ;   <  0: Instrument change, read additional record

                MVI@    R4,     R2                          ; Get instrument data
                ADDI    #_wb_vardlt(POS_A, INSTR_A),R3      ;   (R3 = INSTR_x)
                MVO@    R2,     R3                          ; Save it
                SUBI    #_wb_vardlt(POS_A, INSTR_A),R3      ;   (R3 = POS_x)

@@data_ok:      MVO@    R4,     R3                          ; Update POS_x

                ADDI    #_wb_vardlt(POS_A, NOTE_A), R3      ; (R3 = NOTE_x)
                ANDI    #$7F00, R1                          ; Keep only 7 bits to get only note # (i.e., note is in upper byte)
                BZE     @@skip_sav                          ; Skip if note == 0 (i.e., "NULL" event, keep same note)

                SWAP    R1                                  ; Move note in the reg lower byte
                MVO@    R1,     R3                          ; Save new note

@@skip_sav:     ADDI    #_b_vardlt(NOTE_A, REF_A),  R3      ; (R3 = REF_x)
                MVO@    R0,     R3                          ; Save new refresh value

                ANDI    #$FF0F, R0                          ; Isolate volume: keep only last 4 bits of pattern data
                ADDI    #_b_vardlt(REF_A, VOL_A),   R3      ; (R3 = VOL_x)
                MVO@    R0,     R3                          ; Save new volume (lower byte only)

                ANDI    #$FF00, R0                          ; If ((note == 0) && (instr == 0)) (i.e., "NULL" event)?
                BZE     @@ch_ok                             ;   Yes: Skip counter reset (it's just a note extension)

                ; NOTE:
                ;   The note or the instrument changed, so
                ;   we reset the channel counter.
                ;
                ;   Because the above ANDI instruction
                ;   cleared the lower byte, we can just use
                ;   it to store a zero in 8-bit variable
                ;   "COUNT_x," saving the cost of CLRR.
                ;   (Neat, uh?)
                ; -----------------------------------------
                ADDI    #_b_vardlt(VOL_A, COUNT_A), R3      ; (R3 = COUNT_x)
@@ch_updt:      MVO@    R0,     R3

@@ch_ok:        MVI@    R5,     PC                          ; Jump to next procedure in chain
                ENDP

;; ======================================================================== ;;
;;  TRKPSGUPD     Updates the PSG                                           ;;
;;      R5: Input record followed by return address:                        ;;
;;          Pointer to PSG channel note (NOTE_x)                            ;;
;;          Pointer to PSG channel low address (@@chn_x_lo)                 ;;
;; ======================================================================== ;;
TRKPSGUPD       PROC
                MVI@    R5,     R3                          ; Get channel argument

                MVI@    R3,     R1                          ; read note in NOTE_x

                ; ------------------------------------------
                ; NOTE:
                ;   Local channel counter (COUNT_x) is used
                ;   for instrument pitch effects, localized
                ;   to a note.  It counts from $00 to $FF
                ;   or until the end of a note.
                ;
                ;   The reason the pitch effects do not use
                ;   the global counter (COUNT_M) is so that
                ;   they can guarantee that each note starts
                ;   its pitch effects from the beginning of
                ;   each effect record (index #0).
                ; ------------------------------------------
                ADDI    #_b_vardlt(NOTE_A, COUNT_A),  R3    ; (R3 = COUNT_x)
                MVI@    R3,     R2                          ; Get counter value
                CMPI    #$FF,   R2                          ; \_ Limit counter at $FF without recycling
                BEQ     @@cnt_ok                            ; /

                INCR    R2                                  ; \
                MVO@    R2,     R3                          ;  > Increment counter and store it, but keep
                DECR    R2                                  ; /     the pre-increment value for effects.

@@cnt_ok:       CMPI    #@@nt_cnt, R1                       ; Is this a drum event?
                BGT     @@drum                              ;   Yes: Jump to drums synthesizer

;; ------------------------------------------------------------------------ ;;
;;  Standard Instrument Synthesizer                                         ;;
;; ------------------------------------------------------------------------ ;;
;;      R1: NOTE_x event data (current "note" < 85)                         ;;
;;      R2: COUNT_x value (pre-increment)                                   ;;
;;      R3: Pointer to COUNT_x                                              ;;
;;      R5: Input record followed by return address:                        ;;
;;          Pointer to PSG channel frequency register (@@chn_x_lo)          ;;
;;                                                                          ;;
;;  Note Data Format (NOTE_x):                                              ;;
;;      0nnn nnnn                                                           ;;
;;                                                                          ;;
;;      Legend:                                                             ;;
;;          n: Note index number (1..84)                                    ;;
;;                                                                          ;;
;;  NOTE:   A note index ("n") of zero indicates a "Null" event, which      ;;
;;          involves a volume or instrument change on the same note.        ;;
;; ------------------------------------------------------------------------ ;;
                SUBI    #_b_vardlt(INSTR_A, COUNT_A),R3     ; (R3 = INSTR_x)
                MVI@    R3,     R4                          ; R4 = pointer to instrument
                ADD     _w_var(INS_PTR),R4

                PSHR    R2                                  ; Save channel counter
                ANDI    #(TRK_PITCH_FX_STEPS - 1),   R2     ; \
                ADD@    R4,     R2                          ;  > Apply pitch effect (0..7):
                ADD@    R2,     R1                          ; /     note += (*instr[0] + (COUNT_x % 8))

                ADDI    #(@@nt - 1),    R1                  ; Read period from notes (@@nt) table
                MVI@    R1,     R0                          ; R0 = note period

                ; Compute vibrato amplitude
                ;   0:  No vibrato
                ;   1:  1/4 amplitude (low)
                ;   2:  1/2 amplitude (med)
                ;   3:  Full amplitude (high)
                MVI@    R4,     R2                          ; R2 = type of vibrato for this channel
                DECR    R2                                  ; \_ If (--vibrato < 0) ?
                BMI     @@vibr0                             ; /     Yes, skip amplitude adjustment

                ADDI    #@@nt_cnt,      R1                  ; read vibrato amplitude for this note
                MVI@    R1,     R1                          ; R1 = vibrato amplitude

                ADDR    R2,     PC                          ; Determine the factor by which to divide the amplitude.

@@low_vibr:     SLR     R1                                  ; low vibrato --> 1/4 amplitude
@@mid_vibr:     SLR     R1                                  ; medium vibrato --> 1/2 amplitude

                ; ------------------------------------------
                ; NOTE:
                ;   Vibrato is applied using the global
                ;   counter.  This synchronizes the effect
                ;   on all channels, and allows it to run
                ;   throughout the full length of the note.
                ; ------------------------------------------
                ;       |
                ;   +1 _|                  .#.
                ;       |                .`   `.
                ; +1/2 _|             .#         #.
                ;       |           .`             `.
                ;    0 _|____|___.#____|____|____|____#.___|____|
                ;       |      .`                       `.
                ; -1/2 _|   .#                             #.
                ;       | .`                                 `.
                ;   -1 _#
                ;       |
                ; ------------------------------------------
@@apply_vb:     MVI     _b_var(COUNT_M),  R2                ; apply vibrato
                ANDI    #7,     R2                          ; according to current step
                ADDI    #@@v_tb,R2                          ; (i.e. COUNT_M % 8)
                MVI@    R2,     PC

@@v_tb:         DECLE   @@vibr1, @@vibr2                    ; vibrato processing index
                DECLE   @@vibr0, @@vibr3
                DECLE   @@vibr4, @@vibr3
                DECLE   @@vibr0, @@vibr2

@@vibr2:        SLR     R1                                  ; - 1/2 amplitude
@@vibr1:        SUBR    R1,     R0                          ; - amplitude
                B       @@vibr0

@@vibr3:        SLR     R1                                  ; + 1/2 amplitude
@@vibr4:        ADDR    R1,     R0                          ; + amplitude

                ; R0: Vibrato-adjusted period
                ; R1: Free
                ; R2: Free
                ; R3: Instrument
@@vibr0:        MVI@    R5,     R2                          ; Get PSG period address argument

                MVO@    R0,     R2                          ; write period (low)
                SWAP    R0
                ADDI    #4,     R2
                MVO@    R0,     R2                          ; write period (high)

                ; ------------------------------------------
                ; NOTE: The patch below allows for a channel
                ;       to be used for both DRUMS and TONE.
                ;
                ;       Drums are supported only on the "A"
                ;       channel, so if we made it down here
                ;       and we are an "A" channel, then it
                ;       means that we are not playing drums,
                ;       so we reset the "channel-enable"
                ;       flags to tone and no noise.
                ;
                ;       Also, we need to account for the
                ;       active-channel state.
                ; ------------------------------------------
                MOVR    R2,     R0
                ANDI    #$F,    R0                          ; \_ Test for "A" channel
                BNZE    @@restore                           ; /     @@chn_a_hi = (@@chn_x_hi & $F)

                MOVR    R2,     R1
                ADDI    #4,     R1                          ; Get @@chan_enable from @@chn_a_hi

                MVI@    R1,     R0                          ; \
                ANDI    #$F6,   R0                          ;  |_ Reset channel "A" to tone and no noise
                ADDI    #$08,   R0                          ;  |    in case drums were used.
                MVO@    R0,     R1                          ; /     (@@chan_enable = %????1??0)

@@restore:      PULR    R0                                  ; Restore decremented channel counter (i.e., COUNT_x - 1)

                CMPI    #64,    R0                          ; \_ Has the counter gone over?
                BLT     @@env                               ; /     No, process envelope ...

                ; Re-cycle the counter to backtrack the
                ; envelope
                ; ------------------------------------------
                MOVR    R0,     R1                          ; \
                ANDI    #$3F,   R1                          ;  > offset = (counter & $3F) + rwd_cycle
                ADDI    #TRK_ENV_REWIND_COUNT,  R1          ; /
                SUBR    R1,     R0                          ; counter -= offset

@@env:          MVI@    R4,     R4                          ; R4 = pointer to envelope

                ; Compute the index to the envelope
                ; by adjusting the counter by the speed.
                ; ------------------------------------------
                ADD@    R4,     PC                          ; Apply speed of envelope:
                SLR     R0                                  ;   0: 16 ticks \
                SLR     R0                                  ;   1:  8 ticks  |
                SLR     R0                                  ;   2:  4 ticks   > env_sp = (count / 2^(4 - speed))
                SLR     R0                                  ;   3:  2 ticks  |
                                                            ;   4:  1 tick  /
                ; R0: Envelope index
                ; R1: Free
                ; R2: Pointer to PSG.chn_x_hi
                ; R3: Pointer to INSTR_x
                ; R4: Pointer to envelope array
                MOVR    R0,     R1                          ; Keep a copy of the adjusted speed
                SLR     R0,     2                           ; \_ env += (env_sp / 4)
                ADDR    R0,     R4                          ; /     (each data "record" contains 4 envelope elements)
                MVI@    R4,     R0                          ; Get envelope data "record"
                ANDI    #3,     R1                          ; \
                ADDI    #@@e_tb,R1                          ;  > Decode element nibble
                MVI@    R1,     PC                          ; /

@@e_tb:         DECLE   @@env0, @@env1
                DECLE   @@env2, @@env3

@@env1:         SWAP    R0                                  ; 2nd nybble: $0X00
                B       @@env3

@@env0:         SWAP    R0                                  ; 1st nybble: $X000

@@env2:         SLR     R0,     2                           ; 3rd nybble: $00X0
                SLR     R0,     2

@@env3:         ANDI    #$F,    R0                          ; 4th nybble: $000X

                SUBI    #_b_vardlt(VOL_A, INSTR_A),R3       ; (R3 = VOL_x)
                SUB@    R3,           R0                    ; Adjust volume from song note
                SUB     _b_var(MASTER_FADER),      R0       ; Attenuate volume with global fader

                BPL     @@upd_vol                           ; \_ Flatten volume at zero
                CLRR    R0                                  ; /

                ; R0: Adjusted volume
                ; R1: Free
                ; R2: PSG.chn_x_hi
                ; R3: VOL_x
@@upd_vol:      ADDI    #7,     R2                          ; @@chn_x_hi + 7 = @@chn_x_vol
                MVO@    R0,     R2                          ; apply new volume

                MVI@    R5,     PC                          ; Jump to next procedure in chain

;; ------------------------------------------------------------------------ ;;
;;  Drums Synthesizer                                                       ;;
;; ------------------------------------------------------------------------ ;;
;;      R1: NOTE_x event data (current "note" >= 85)                        ;;
;;      R2: COUNT_x value (pre-increment)                                   ;;
;;      R3: Pointer to COUNT_x                                              ;;
;;      R5: Input record followed by return address:                        ;;
;;          Pointer to PSG channel low address (@@chn_x_lo)                 ;;
;;                                                                          ;;
;;  Drum Data Format (NOTE_x):                                              ;;
;;      0ddd dddd                                                           ;;
;;                                                                          ;;
;;      Legend:                                                             ;;
;;          d: Drum index number (85..127 : drum + 84)                      ;;
;;                                                                          ;;
;;  NOTE:   There's a global assumption that drums only play on channels    ;;
;;          "A" and "D" (the first voice of each PSG device), and this      ;;
;;          assumption drives some code optimizations.                      ;;
;; ------------------------------------------------------------------------ ;;
                ; R0: Free
                ; R1: NOTE_x
                ; R2: COUNT_x
                ; R3: Pointer to COUNT_x
                ; R4: Free
                ; R5: input-rec[1]
@@drum:         CMPI    #TRK_DRUM_STEPS, R2                 ; Check if this is the end of drum?
                BGE     @@end_drums                         ;   Yes?  Jump to end.

                PSHR    R3                                  ; Save pointer to COUNT_x

                SUBI    #(@@nt_cnt + 1), R1                 ; Get drum index (drums start at 84 + (drum # > 1), 0 means unchanged)
                MVI     _w_var(SONG),    R3                 ; Get pointer to base of drums table ...
                ADDI    #3,     R3                          ;   which is 3 words after the song entry ptr.
                ADD@    R3,     R1
                MVI@    R1,     R4

        IF (TRK_ENABLE_LONG_DRUMS)
                SLR     R2,     1                           ; If "long drums" are enabled, repeat each step twice
        ENDI

                SLL     R2,     2                           ; Add current step
                ADDR    R2,     R4                          ;   drum = @@drum + (COUNT_x * 4)

                MVI@    R5,     R2                          ; Get @@chn_x_lo

                MVI@    R4,     R0                          ; tone period
                MVO@    R0,     R2                          ; write period (low)
                SWAP    R0
                ADDI    #4,     R2
                MVO@    R0,     R2                          ; write period (high)

                MOVR    R2,     R1                          ; \_ Get @@chan_enable from @@chn_a_hi
                ADDI    #4,     R1                          ; /     (drums are only on channel "a"!)

                MVI@    R4,     R0                          ; get noise period
                MVI@    R4,     R3                          ; enable tone / noise
                MVO@    R3,     R1                          ; Set channel enable flags

                INCR    R1                                  ; @@noise
                MVO@    R0,     R1                          ; Set noise period

                PULR    R3                                  ; Restore pointer to COUNT_x
                SUBI    #_b_vardlt(VOL_A, COUNT_A),R3       ; (R3 = VOL_x)

                MVI@    R4,           R0                    ; Get volume
                SUB@    R3,           R0                    ; Adjust volume from song note
                SUB     _b_var(MASTER_FADER),      R0       ; Attenuate volume with global fader
                BPL     @@drum_vol                          ; \_ but flatten at zero.
                CLRR    R0                                  ; /

@@drum_vol:     ADDI    #7,     R2                          ; Adjust pointer to channel volume
                MVO@    R0,     R2                          ; Set channel volume

                MVI@    R5,     PC                          ; Jump to next procedure in chain

                ; ------------------------------------------
                ; When the last drum plays, we can't really
                ; tell in which state the noise and tone
                ; registers are, and we can't guarantee that
                ; another drum or tone is coming up to reset
                ; them.  Therefore, we need to silence the
                ; channel explicitly.
                ; ------------------------------------------
@@end_drums:    MVI@    R5,     R2                          ; \_ Get pointer to @@chn_a_vol
                ADDI    #$B,    R2                          ; /
                CLRR    R0                                  ; \_ Reset channel volume to zero
                MVO@    R0,     R2                          ; /     (just in case ...)

                MVI@    R5,     PC                          ; Jump to next procedure in chain

;; ======================================================================== ;;
;;  Periods of the 84 defined notes                                         ;;
;;  (from C-1 to B-7)                                                       ;;
;; ======================================================================== ;;
@@nt:           DECLE   $0D5C, $0C9D, $0BE7, $0B3C, $0A9B, $0A02, $0973, $08EB
                DECLE   $086B, $07F2, $0780, $0714, $06AE, $064E, $05F4, $059E
                DECLE   $054D, $0501, $04B9, $0475, $0435, $03F9, $03C0, $038A
                DECLE   $0357, $0327, $02FA, $02CF, $02A7, $0281, $025D, $023B
                DECLE   $021B, $01FC, $01E0, $01C5, $01AC, $0194, $017D, $0168
                DECLE   $0153, $0140, $012E, $011D, $010D, $00FE, $00F0, $00E2
                DECLE   $00D6, $00CA, $00BE, $00B4, $00AA, $00A0, $0097, $008F
                DECLE   $0087, $007F, $0078, $0071, $006B, $0065, $005F, $005A
                DECLE   $0055, $0050, $004C, $0047, $0043, $0040, $003C, $0039
                DECLE   $0035, $0032, $0030, $002D, $002A, $0028, $0026, $0024
                DECLE   $0022, $0020, $001E, $001C

@@nt_cnt        EQU     ($ - @@nt)

;; ======================================================================== ;;
;;  Vibrato amplitude for each note above                                   ;;
;;  (30% of an half-tone)                                                   ;;
;; ======================================================================== ;;
                DECLE   $003B, $0038, $0035, $0032, $002F, $002C, $002A, $0028
                DECLE   $0025, $0023, $0021, $001F, $001E, $001C, $001A, $0019
                DECLE   $0018, $0016, $0015, $0014, $0013, $0012, $0011, $0010
                DECLE   $000F, $000E, $000D, $000C, $000C, $000B, $000A, $000A
                DECLE   $0009, $0009, $0008, $0008, $0007, $0007, $0007, $0006
                DECLE   $0006, $0006, $0005, $0005, $0005, $0004, $0004, $0004
                DECLE   $0004, $0003, $0003, $0003, $0003, $0003, $0003, $0002
                DECLE   $0002, $0002, $0002, $0002, $0002, $0002, $0002, $0002
                DECLE   $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
                DECLE   $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
                DECLE   $0001, $0001, $0001, $0000
                ENDP

;; ======================================================================== ;;
;;  End of File:  tracker.asm                                               ;;
;; ======================================================================== ;;
