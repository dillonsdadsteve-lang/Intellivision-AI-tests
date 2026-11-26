;* ======================================================================== *;
;*  These routines are placed into the public domain by their authors.  All *;
;*  copyright rights are hereby relinquished on the routines and data in    *;
;*  this file.  -- Arnauld Chevallier, 2008; James Pujals, 2017             *;
;* ======================================================================== *;

;; ======================================================================== ;;
;;  GLOBAL TRACKER CONFIGURATION                                            ;;
;; ------------------------------------------------------------------------ ;;
;;  WARNING:                                                                ;;
;;      The tracker library supports a configuration of either 3-channels   ;;
;;      or 6-channels, set at assembly time via the assembler symbol        ;;
;;      "TRK_ENABLED_6_CHN" as defined below:                               ;;
;;                                                                          ;;
;;          TRK_ENABLED_6_CHN = 0   : 3-channels                            ;;
;;          TRK_ENABLED_6_CHN = 1   : 6-channels                            ;;
;;                                                                          ;;
;;      Consequently, if you opt for 3-channels support, you must make sure ;;
;;      that your music data includes only three channels per pattern       ;;
;;      definition, or else Bad Things will happen.                         ;;
;;                                                                          ;;
;;      Also, when defining your song's drums and pitch effects, be sure to ;;
;;      use the correct number steps specified in the constants below, or   ;;
;;      else more Bad Things will happen.                                   ;;
;;                                                                          ;;
;;      YOU HAVE BEEN WARNED.                                               ;;
;; ======================================================================== ;;
TRK_ENABLED_6_CHN       EQU     1           ; Enable six channels
TRK_GLOBAL_FADER        EQU     0           ; Global volume attenuator
TRK_DRUM_STEPS          EQU     16          ; Number of steps in drums
TRK_ENABLE_LONG_DRUMS   EQU     0           ; Enable long drums
TRK_PITCH_FX_STEPS      EQU     4           ; Number of steps in pitch effects
TRK_ENV_REWIND_COUNT    EQU     8           ; Number of steps to rewind the envelope

;; ======================================================================== ;;
;;  DEFINITIONS:                                                            ;;
;; ------------------------------------------------------------------------ ;;
;;      TRK_ENABLED_6_CHN                                                   ;;
;;          Indicates whether the tracker should support 3 or 6 channel     ;;
;;          songs.  Note that the tracker will play 6 channels whether the  ;;
;;          ECS is available or not, but they won't be heard unless it is.  ;;
;;              Values:                                                     ;;
;;                  1:          6 channels enabled (default)                ;;
;;                  0:          6 channels disabled                         ;;
;;                                                                          ;;
;;      TRK_GLOBAL_FADER                                                    ;;
;;          Defines a default volume attenuation to apply to songs.  The    ;;
;;          song's master volume will be reduced by this amount as it plays.;;
;;              Values:                                                     ;;
;;                  0:          No attenuation (normal song volume)         ;;
;;                  1 to 15:    Amount to attenuate master volume.          ;;
;;                                                                          ;;
;;      TRK_DRUM_STEPS                                                      ;;
;;          The number of steps that define a drum instrument.  Each step   ;;
;;          corresponds to a "tick" of the music tracker.                   ;;
;;              Values:                                                     ;;
;;                  1 to 255:   Number of steps to play a drum sound.       ;;
;;                                                                          ;;
;;      TRK_ENABLE_LONG_DRUMS                                               ;;
;;          Indicates whether "long drums" are enabled.  Long drums play    ;;
;;          each step for two ticks instead of one, doubling the length     ;;
;;          of the drum sound.                                              ;;
;;              Values:                                                     ;;
;;                  1:          Long drums enabled                          ;;
;;                  0:          Long drums disabled (default)               ;;
;;                                                                          ;;
;;      TRK_PITCH_FX_STEPS                                                  ;;
;;          Similar to TRK_DRUM_STEPS, this value indicates the number of   ;;
;;          steps that define a pitch effect, i.e., the number of semi-tone ;;
;;          changes to repeat for each arpeggio.  Each step corresponds to  ;;
;;          a "tick" of the music tracker.                                  ;;
;;              Values:                                                     ;;
;;                  4 to 256:   Must be a power of two.                     ;;
;;                                                                          ;;
;;      TRK_ENV_REWIND_COUNT                                                ;;
;;          Indicates the number of steps to backtrack when an instrument   ;;
;;          envelope is exhausted while a note is sustained.  This allows   ;;
;;          for long notes to play indefinitely.  Each step corresponds to  ;;
;;          an envelope sample point.                                       ;;
;;              Values:                                                     ;;
;;                  0 to 63:    Number of samples to backtrack envelope.    ;;
;;                                                                          ;;
;; ======================================================================== ;;

TRK_END_SONG        EQU     $F000   ; Marks the end of a song

        ; Determine the number of tracks to process
        IF (TRK_ENABLED_6_CHN)
TRK_MAX_CHANNELS    EQU     6
        ELSE
TRK_MAX_CHANNELS    EQU     3
        ENDI

;; ======================================================================== ;;
;;  End of File:  global-config.asm                                         ;;
;; ======================================================================== ;;
