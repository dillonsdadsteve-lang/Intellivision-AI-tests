' ============================================================
'  RUNNER PRO  -  Jungle runner for Mattel Intellivision
'  Language : IntyBASIC   Target : jzintv / real hardware
'
'  Controls : disc LEFT / RIGHT = run, any side button = jump
'  Hazards  : rolling boulders, opening/closing pits,
'             giant spiders, scorpions
' ============================================================

INCLUDE "constants.bas"

' ---- private constants (K_ prefix avoids clashes) ----------
CONST K_VIS   = $0200      ' sprite visible flag (X register)
CONST K_DBL   = $0080      ' 8x16 sprite flag (Y register)
CONST K_FLIPX = $0400      ' horizontal flip (Y register)
CONST K_GRAM  = $0800      ' GRAM select bit for card words
CONST K_GY    = 72         ' Y of 16px hero standing on ground
CONST K_EY    = 80         ' Y of 8px enemies standing on ground

' ---- arrays -------------------------------------------------
DIM #ex(4)                 ' enemy X (0,1 boulders  2 spider  3 scorpion)
DIM ed(4)                  ' enemy direction 0=left 1=right
DIM ew(4)                  ' enemy respawn wait (frames), 0 = active
DIM #pt(3)                 ' pit timers
DIM pcol(3)                ' pit left column

' ---- one-time setup ----------------------------------------
MODE 0,1,1,1,1             ' colour stack: blue sky
CLS
DEFINE 0,20,gfx
WAIT
SOUND 4,,$38               ' tones on, noise off
pcol(0) = 4
pcol(1) = 9
pcol(2) = 14
#hi = 0

' ============================================================
title_screen:
    FOR i = 0 TO 7 : SPRITE i,0,0,0 : NEXT i
    GOSUB drawbg
    PRINT AT 105 COLOR 7,"RUNNER PRO"
    PRINT AT 143 COLOR 6,"JUNGLE ESCAPE"
    PRINT AT 185 COLOR 7,"PRESS FIRE"
    PRINT AT 224 COLOR 7,"HI",<5>#hi
    WHILE CONT.BUTTON = 0
        r = RAND
        WAIT
    WEND
    WHILE CONT.BUTTON <> 0
        WAIT
    WEND

new_game:
    lives = 3
    #score = 0
    lvl = 1
    fr = 0
    snd = 0
    #pt(0) = 0
    #pt(1) = 60
    #pt(2) = 120
    GOSUB drawbg
    GOSUB reset_round

' ============================================================
game_loop:
    WAIT
    fr = fr + 1
    IF (fr AND 31) = 0 THEN #score = #score + 1
    lvl = 1 + #score / 150
    IF lvl > 5 THEN lvl = 5

    GOSUB read_input
    GOSUB update_pits
    GOSUB update_enemies
    GOSUB check_hits
    GOSUB draw_all

    IF hitf THEN
        GOSUB dead
        IF lives = 0 THEN GOTO game_over
        GOSUB reset_round
    END IF
    GOTO game_loop

' ============================================================
game_over:
    IF #score > #hi THEN #hi = #score
    FOR i = 0 TO 7 : SPRITE i,0,0,0 : NEXT i
    PRINT AT 125 COLOR 2,"GAME OVER"
    PRINT AT 165 COLOR 7,"SCORE",<5>#score
    FOR f = 0 TO 89
        WAIT
    NEXT f
    WHILE CONT.BUTTON = 0
        r = RAND
        WAIT
    WEND
    WHILE CONT.BUTTON <> 0
        WAIT
    WEND
    GOTO title_screen

' ============================================================
'  PROCEDURES
' ============================================================

' ---- jungle backdrop ---------------------------------------
drawbg: PROCEDURE
    CLS
    FOR i = 0 TO 19
        #BACKTAB(20 + i)  = K_GRAM + 18*8 + 5     ' canopy
        #BACKTAB(40 + i)  = K_GRAM + 18*8 + 5
        #BACKTAB(200 + i) = K_GRAM + 14*8 + 5     ' grass
        #BACKTAB(220 + i) = K_GRAM + 15*8 + 3     ' dirt
    NEXT i
    FOR rr = 3 TO 9                                ' tree trunks
        #BACKTAB(rr*20 + 1)  = K_GRAM + 17*8 + 3
        #BACKTAB(rr*20 + 3)  = K_GRAM + 17*8 + 3
        #BACKTAB(rr*20 + 7)  = K_GRAM + 17*8 + 3
        #BACKTAB(rr*20 + 12) = K_GRAM + 17*8 + 3
        #BACKTAB(rr*20 + 17) = K_GRAM + 17*8 + 3
    NEXT rr
END

' ---- start of life / round ---------------------------------
reset_round: PROCEDURE
    px = 80
    jt = 0
    jh = 0
    py = K_GY
    face = 0
    an = 0
    hitf = 0
    FOR i = 0 TO 3
        #ex(i) = 0
        ed(i) = 0
        ew(i) = 40 + i * 35
    NEXT i
    FOR i = 1 TO 7 : SPRITE i,0,0,0 : NEXT i
END

' ---- controller, jump arc ----------------------------------
read_input: PROCEDURE
    mv = 0
    IF CONT.LEFT THEN
        IF px > 8 THEN px = px - 1
        face = 1
        mv = 1
    END IF
    IF CONT.RIGHT THEN
        IF px < 152 THEN px = px + 1
        face = 0
        mv = 1
    END IF
    IF mv THEN
        IF (fr AND 7) = 0 THEN an = an XOR 1
    ELSE
        an = 0
    END IF

    IF jt = 0 THEN
        IF CONT.BUTTON THEN
            jt = 1
            SOUND 0,220,12
            snd = 8
        END IF
    ELSE
        jt = jt + 1
        IF jt >= 28 THEN jt = 0
    END IF

    jh = 0
    IF jt > 0 THEN jh = jt * (28 - jt) / 7        ' parabola, peak 28 px
    py = K_GY - jh

    IF snd > 0 THEN
        snd = snd - 1
        IF snd = 0 THEN SOUND 0,,0
    END IF
END

' ---- pits cycle: closed 0-89, cracking 90-119, open 120-179 -
update_pits: PROCEDURE
    FOR k = 0 TO 2
        #pt(k) = #pt(k) + 1
        IF #pt(k) >= 180 THEN #pt(k) = 0
    NEXT k
END

' ---- enemy movement and respawn ----------------------------
update_enemies: PROCEDURE
    FOR i = 0 TO 3
        IF ew(i) > 0 THEN
            ew(i) = ew(i) - 1
            IF ew(i) = 0 THEN
                ed(i) = RANDOM(2)
                IF ed(i) = 0 THEN
                    #ex(i) = 170
                ELSE
                    #ex(i) = 0
                END IF
            END IF
        ELSE
            dx = 1
            IF i < 2 THEN
                IF (fr AND 3) = 0 THEN dx = 2       ' boulders roll fast
                IF lvl > 2 THEN dx = dx + 1
            END IF
            IF i = 2 THEN
                dx = 0
                IF (fr AND 1) = 0 THEN dx = 1       ' spiders crawl slowly
            END IF

            IF ed(i) = 0 THEN
                #ex(i) = #ex(i) - dx
                IF #ex(i) < 3 THEN
                    GOSUB retire
                ELSE
                    IF #ex(i) > 200 THEN GOSUB retire
                END IF
            ELSE
                #ex(i) = #ex(i) + dx
                IF #ex(i) > 172 THEN GOSUB retire
            END IF
        END IF
    NEXT i
END

retire: PROCEDURE
    #score = #score + 10
    r = RANDOM(90)
    r = r / lvl
    ew(i) = 25 + r
    #ex(i) = 0
END

' ---- collisions --------------------------------------------
check_hits: PROCEDURE
    hitf = 0

    ' fall into an open pit (only when on the ground)
    IF jt = 0 THEN
        #c = px + 4
        FOR k = 0 TO 2
            IF #pt(k) >= 120 THEN
                #d = pcol(k) * 8 + 8
                IF #c >= #d THEN
                    IF #c < #d + 16 THEN hitf = 1
                END IF
            END IF
        NEXT k
    END IF

    ' enemies
    FOR i = 0 TO 3
        IF ew(i) = 0 THEN
            #d = #ex(i) + 4 - px
            IF #d >= 1 THEN
                IF #d <= 9 THEN
                    IF i = 2 THEN
                        IF py > 58 THEN hitf = 1     ' spider is 16 px tall
                    ELSE
                        IF py > 66 THEN hitf = 1     ' boulder / scorpion 8 px
                    END IF
                END IF
            END IF
        END IF
    NEXT i
END

' ---- draw pits, sprites, HUD -------------------------------
draw_all: PROCEDURE
    ' pits
    FOR k = 0 TO 2
        c = pcol(k)
        IF #pt(k) < 90 THEN
            #t1 = K_GRAM + 14*8 + 5
            #t2 = K_GRAM + 15*8 + 3
        ELSE
            IF #pt(k) < 120 THEN
                #t1 = K_GRAM + 19*8 + 0          ' crumbling warning
                #t2 = K_GRAM + 19*8 + 0
            ELSE
                #t1 = K_GRAM + 16*8 + 0          ' open pit
                #t2 = #t1
            END IF
        END IF
        #BACKTAB(200 + c) = #t1
        #BACKTAB(201 + c) = #t1
        #BACKTAB(220 + c) = #t2
        #BACKTAB(221 + c) = #t2
    NEXT k

    ' hero
    pc = 0
    IF jt > 0 THEN
        pc = 4
    ELSE
        IF an THEN pc = 2
    END IF
    #a = K_GRAM + pc*8 + 6
    #y = K_DBL + py
    IF face THEN #y = #y + K_FLIPX
    SPRITE 0, K_VIS + px, #y, #a

    ' enemies
    FOR i = 0 TO 3
        s = i + 1
        IF ew(i) > 0 THEN
            SPRITE s,0,0,0
        ELSE
            #x = #ex(i)
            IF i < 2 THEN
                #a = K_GRAM + 6*8 + 3             ' boulder (tan)
                IF #x AND 4 THEN #a = K_GRAM + 7*8 + 3
                SPRITE s, K_VIS + #x, K_EY, #a
            ELSE
                IF i = 2 THEN
                    #a = K_GRAM + 10*8 + 0        ' giant spider (black)
                    IF #x AND 8 THEN #a = K_GRAM + 12*8 + 0
                    SPRITE s, K_VIS + #x, K_DBL + K_GY, #a
                ELSE
                    #a = K_GRAM + 8*8 + 2         ' scorpion (red)
                    IF #x AND 4 THEN #a = K_GRAM + 9*8 + 2
                    SPRITE s, K_VIS + #x, K_EY, #a
                END IF
            END IF
        END IF
    NEXT i

    ' HUD
    PRINT AT 0 COLOR 7,"SCORE"
    PRINT AT 5 COLOR 6,<5>#score
    PRINT AT 14 COLOR 7,"LIVES"
    PRINT AT 19 COLOR 2,<1>lives
END

' ---- lose a life -------------------------------------------
dead: PROCEDURE
    lives = lives - 1
    SOUND 0,,0
    FOR f = 0 TO 59
        IF (f AND 4) = 0 THEN
            SPRITE 0, K_VIS + px, K_DBL + py, K_GRAM + 4*8 + 2
        ELSE
            SPRITE 0,0,0,0
        END IF
        SOUND 0, 300 + f*6, 12
        WAIT
    NEXT f
    SOUND 0,,0
END

' ============================================================
'  GRAPHICS  (20 GRAM cards)
' ============================================================
gfx:
    ' 0  hero run A top
    BITMAP "..XXXX.."
    BITMAP ".XXXXXX."
    BITMAP "..XXXX.."
    BITMAP "...XX..."
    BITMAP ".XXXXXX."
    BITMAP "X.XXXX.X"
    BITMAP "X.XXXX.X"
    BITMAP "..XXXX.."
    ' 1  hero run A bottom
    BITMAP "..XXXX.."
    BITMAP "..XX.XX."
    BITMAP ".XX..XX."
    BITMAP ".XX...XX"
    BITMAP "XX....XX"
    BITMAP "XX.....X"
    BITMAP "XX......"
    BITMAP "XXX....."
    ' 2  hero run B top
    BITMAP "..XXXX.."
    BITMAP ".XXXXXX."
    BITMAP "..XXXX.."
    BITMAP "...XX..."
    BITMAP ".XXXXXX."
    BITMAP ".XXXXXX."
    BITMAP "X.XXXX.X"
    BITMAP "..XXXX.."
    ' 3  hero run B bottom
    BITMAP "..XXXX.."
    BITMAP "..XXXX.."
    BITMAP "...XX..."
    BITMAP "...XX..."
    BITMAP "..XXXX.."
    BITMAP "..XX.XX."
    BITMAP "..XX.XX."
    BITMAP ".XXX.XXX"
    ' 4  hero jump top
    BITMAP "X.XXXX.X"
    BITMAP "X.XXXX.X"
    BITMAP ".XXXXXX."
    BITMAP "..XXXX.."
    BITMAP "...XX..."
    BITMAP "..XXXX.."
    BITMAP "..XXXX.."
    BITMAP "..XXXX.."
    ' 5  hero jump bottom
    BITMAP ".XXXXXX."
    BITMAP ".XX..XX."
    BITMAP "XX....XX"
    BITMAP "XX....XX"
    BITMAP "XXX..XXX"
    BITMAP "........"
    BITMAP "........"
    BITMAP "........"
    ' 6  boulder A
    BITMAP "..XXXX.."
    BITMAP ".XXXXXX."
    BITMAP "XXX.XXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXX.X"
    BITMAP "XXXXXXXX"
    BITMAP ".XXXXXX."
    BITMAP "..XXXX.."
    ' 7  boulder B
    BITMAP "..XXXX.."
    BITMAP ".XXXXXX."
    BITMAP "XXXXXXXX"
    BITMAP "XX.XXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXX.XXX"
    BITMAP ".XXXXXX."
    BITMAP "..XXXX.."
    ' 8  scorpion A
    BITMAP ".....XX."
    BITMAP "....X..X"
    BITMAP "X...X..X"
    BITMAP ".XXXXXX."
    BITMAP "XXXXXXXX"
    BITMAP ".X.XX.X."
    BITMAP "X..XX..X"
    BITMAP "...XX..."
    ' 9  scorpion B
    BITMAP ".....XX."
    BITMAP "....X..X"
    BITMAP "X...X..X"
    BITMAP ".XXXXXX."
    BITMAP "XXXXXXXX"
    BITMAP "X.X..X.X"
    BITMAP ".X.XX.X."
    BITMAP "..X..X.."
    ' 10 spider A top
    BITMAP "........"
    BITMAP "...XX..."
    BITMAP "..XXXX.."
    BITMAP ".X.XX.X."
    BITMAP "X.XXXX.X"
    BITMAP ".XXXXXX."
    BITMAP "X.XXXX.X"
    BITMAP ".X.XX.X."
    ' 11 spider A bottom
    BITMAP "X..XX..X"
    BITMAP ".X.XX.X."
    BITMAP "..XXXX.."
    BITMAP "..XXXX.."
    BITMAP ".X.XX.X."
    BITMAP "X..XX..X"
    BITMAP "X......X"
    BITMAP "........"
    ' 12 spider B top
    BITMAP "........"
    BITMAP "...XX..."
    BITMAP "..XXXX.."
    BITMAP "X..XX..X"
    BITMAP ".XXXXXX."
    BITMAP "X.XXXX.X"
    BITMAP ".XXXXXX."
    BITMAP "X.XXXX.X"
    ' 13 spider B bottom
    BITMAP ".X.XX.X."
    BITMAP "X..XX..X"
    BITMAP "..XXXX.."
    BITMAP "..XXXX.."
    BITMAP "X..XX..X"
    BITMAP ".X.XX.X."
    BITMAP ".X....X."
    BITMAP "........"
    ' 14 grass top
    BITMAP "X.X.XX.X"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    ' 15 dirt
    BITMAP "XXXXXXXX"
    BITMAP "XX.XXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXX.XX"
    BITMAP "XXXXXXXX"
    BITMAP "X.XXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXX.XXX"
    ' 16 pit (solid, drawn black)
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    BITMAP "XXXXXXXX"
    ' 17 tree trunk
    BITMAP "..XXXX.."
    BITMAP "..X.XX.."
    BITMAP "..XXXX.."
    BITMAP "..XX.X.."
    BITMAP "..XXXX.."
    BITMAP "..X.XX.."
    BITMAP "..XXXX.."
    BITMAP "..XXX.X."
    ' 18 leaves
    BITMAP ".X.XX.X."
    BITMAP "XXXXXXXX"
    BITMAP "XXX.XXXX"
    BITMAP "XXXXXXXX"
    BITMAP ".XXXX.XX"
    BITMAP "XXXXXXXX"
    BITMAP "X.XXXXX."
    BITMAP ".XXXXXX."
    ' 19 crumbling ground (warning)
    BITMAP "X.X.X.X."
    BITMAP ".X.X.X.X"
    BITMAP "X.X.X.X."
    BITMAP ".X.X.X.X"
    BITMAP "X.X.X.X."
    BITMAP ".X.X.X.X"
    BITMAP "X.X.X.X."
    BITMAP ".X.X.X.X"
