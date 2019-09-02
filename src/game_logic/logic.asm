SECTION "Game logic", ROM0

LogicEntry:
    jp PlayerTurn

PlayerTurn
    call TurnOffLCD
    call RenderTurnP1
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
    call MarkPlayer
    call ChangePlayer
    jp Decision
.end
    jp .lockup

OpponentTurn:
    call TurnOffLCD
    call RenderTurnP2
    call HideCursor
    call TurnOnLCD

    call DisableTimerInt
    call DisableVBlank
    call EnableSerial
.lockup
    ei
    halt
    di
; .if
;     ld a, [serial_turn]
;     cp a, 1  ; check if is the internal clock turn
;     jp nz, .end
; .then

; .end
    jp .lockup

Decision:
    call VerifyWinner
    ld a, [winner]
    and a, a ; cp a, 0
.ifWinner
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


ShowWinner
    call TurnOffLCD
    call HideCursor
.if
    ld a, [winner]
    cp a, 1
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
    jp .lockup

ChangePlayer:
    ld a, [player_turn]
    xor a, $01
    ld [player_turn], a
    ret 

; Calculate offset from cursor axis.
;
; Arguments:
;
; - `l`: y axis
; - `e`: x axis
;
; Return:
; - `de`: offset calculed
;
; Destroy registers `af`, `bc`, `de`, `hl`
CalcOffset:
    ld h, 0
    ld d, 0
    push de
    push hl

    ld hl, 3
    pop de
    call Multiply  ; bc = de * hl

    pop de
    ld a, c
    add a, e

    ld d, 0
    ld e, a

    ret

MarkPlayer:
.offset
    ld a, [cursor_y]
    ld l, a
    ld a, [cursor_x]
    ld e, a
    call CalcOffset
    ld a, [player_num]
    add a, 1
    ld c, a
    call Mark
    ret

; Mark a move.
;
; Arguments:
;
; - `de`: offset to be marked
; - `c`: value to be marked
;
; Destroy registers `af`, `bc`, `de`, `hl`
Mark:
.store
    ld hl, marks
    add hl, de

    ld a, c
    ld [hl], a
.update
    ; TODO: put this render update outside function
    call TurnOffLCD
    call RenderMarks
    call TurnOnLCD

    ret

CursorLeft:
    ld a, [cursor_x]
.if
    and a, a  ; cp a, 0
    jp z, .end
.then
    sub a, 1
    ld [cursor_x], a
    call TurnOffLCD
    call RenderCursor
    call TurnOnLCD
.end
    ret

CursorRight:
    ld a, [cursor_x]
.if
    cp a, 2
    jp nc, .end
.then
    add a, 1
    ld [cursor_x], a
    call TurnOffLCD
    call RenderCursor
    call TurnOnLCD
.end
    ret

CursorUp:
    ld a, [cursor_y]
.if
    and a, a  ; cp a, 0
    jp z, .end
.then
    sub a, 1
    ld [cursor_y], a
    call TurnOffLCD
    call RenderCursor
    call TurnOnLCD
.end
    ret

CursorDown:
    ld a, [cursor_y]
.if
    cp a, 2
    jp nc, .end
.then
    add a, 1
    ld [cursor_y], a
    call TurnOffLCD
    call RenderCursor
    call TurnOnLCD
.end
    ret

VerifyWinner:
    ld a, 0
    ld b, 0    ; counter
    ld c, $03  ; winner
.while123
    ld a, b
    cp a, 3
    jp nc, .end123
.do123
    ld hl, marks
    ld a, l
    add a, b
    ld l, a

    ld d, [hl]
    ld a, c
    and a, d
    ld c, a

    inc b

    jp .while123
.end123

.if123Winner
    ld a, c
    and a, a  ; cp a, 0
    jp z, .end123Winner
.then123Winner
    ld hl, winner
    ld [hl], a

    ld a, 1
    ld [marks_blink], a
    ld [marks_blink + 1], a
    ld [marks_blink + 2], a
.end123Winner
.end
    ret

SetupGame:
	call TurnOffLCD
	call RenderGrid
	; call RenderScore
	; call UpdateScore
	call RenderCursor
	call RenderMarks
	call TurnOnLCD

    ld a, 0
    ld [player_turn], a
    ld a, 0
    ld [player_num], a
    ret