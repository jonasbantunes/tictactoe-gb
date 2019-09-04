SECTION "Game logic", ROM0

PlayerTurn
    call TurnOffLCD
    call RenderTurnP1
    call ShowCursor
    call TurnOnLCD
    call EnableVBlank
    call EnableTimerInt
.lockup
    ei
    call WaitVblank
    di
    ld a, [joybuttons]
    ld b, a
    ld a, [joyhold]
    cpl
    and a, b
.ifUp
    bit PADB_UP, a
    jp z, .ifDown
.thenUp
    call CursorUp
    jp .end
.ifDown
    bit PADB_DOWN, a
    jp z, .ifLeft
.thenDown
    call CursorDown
    jp .end
.ifLeft
    bit PADB_LEFT, a
    jp z, .ifRight
.thenLeft
    call CursorLeft
    jp .end
.ifRight
    bit PADB_RIGHT, a
    jp z, .ifA
.thenRight
    call CursorRight
    jp .end
.ifA
    bit PADB_A, a
    jp z, .end
.thenA
    ; call MarkPlayer
    ; call SendMark
    ; call ChangePlayer
    ; jp Decision
    jp CheckPlayer
.end
    jp .lockup

CheckPlayer:
    ld hl, marks
    ld d, 0
    ld a, [cursor]
    ld e, a
    add hl, de
.ifNotMarked
    ld a, [hl]
    and a, a ; cp a, 0
    jp nz, .else
.then
    call MarkPlayer
    call SendMark
    call ChangePlayer
    jp Decision
.else
    jp PlayerTurn

OpponentTurn:
    call TurnOffLCD
    call RenderTurnP2
    call HideCursor
    call TurnOnLCD

    call DisableTimerInt
    call EnableVBlank
    call EnableSerial
.lockup
    ei
    halt
    di
.if
    ld a, [serial_turn]
    cp a, 1  ; check if is the internal clock turn
    jp nz, .end
.then
    call MarkOpponent
    call ChangePlayer
    jp Decision
.end
    jp .lockup

Decision:
.ifDraw
    ld a, [turns_left]
    and a, a ; cp a, 0
    jp nz, .endDraw
.thenDraw
    jp ShowDraw
.endDraw
.ifWinner
    call VerifyWinner
    ld a, [winner]
    and a, a ; cp a, 0
    jp z, .endWinner
.thenWinner
    jp ShowWinner
.endWinner
.ifPlayerTurn:
    ld a, [player_turn]
    ld b, a
    ld a, [player_num]
    cp a, b
    jp nz, .elsePlayerTurn
.thenPlayerTurn:
    jp PlayerTurn
.elsePlayerTurn:
    jp OpponentTurn


ShowDraw:
    call TurnOffLCD
    call HideCursor
    call RenderDrawGame
    call TurnOnLCD
.lockup
    halt
    ; jp .lockup
    jp AwaitConnection

ShowWinner
    call TurnOffLCD
    call HideCursor
.if
    ld a, [player_num]
    add a, 1
    ld b, a
    
    ld a, [winner]
    cp a, b
    jp nz, .else
.then
    call RenderYouWon
    jp .end
.else
    call RenderYouLost
.end
    call TurnOnLCD
    ei
.lockup
    halt
    ; jp .lockup
    jp AwaitConnection

ChangePlayer:
    ld a, [player_turn]
    xor a, $01
    ld [player_turn], a

    ld a, [turns_left]
    dec a
    ld [turns_left], a
    ret 

VerifyWinner:
    ld c, 0 ; winner
.check123
    ld hl, marks
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check456
    ld hl, marks+3
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check789
    ld hl, marks+6
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check147
    ld hl, marks
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    inc hl
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check258
    ld hl, marks + 1
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    inc hl
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check369
    ld hl, marks + 2
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    inc hl
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check159
    ld hl, marks
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    inc hl
    inc hl
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.check357
    ld hl, marks+2
    ld a, $03
REPT 3
    ld b, [hl]
    inc hl
    inc hl
    and a, b
ENDR
or a, c
ld c, a

.ifWinner
    ld a, c
    and a, a  ; cp a, 0
    jp z, .endWinner
.thenWinner
    ld hl, winner
    ld [hl], a
.endWinner
    ret

SetupGame:
    ld hl, cursor
    ld de, player_num - cursor
.while
    ld a, d
    or a, e
    jp z, .end
.do
    ld [hl], 0
    inc hl
    dec de
    jp .while
.end
    ld a, 9
    ld [turns_left], a
    
	call TurnOffLCD
	call RenderGrid
	call RenderScore
	call UpdateScore
	call RenderCursor
	call RenderMarks
	call TurnOnLCD
    ret