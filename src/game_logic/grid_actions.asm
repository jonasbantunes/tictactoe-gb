CursorLeft:
    ld a, [cursor_x]
.if
    and a, a  ; cp a, 0
    jp z, .end
.then
    sub a, 1
    ld [cursor_x], a

    ld a, [cursor]
    sub a, 1
    ld [cursor], a

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

    ld a, [cursor]
    add a, 1
    ld [cursor], a

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

    ld a, [cursor]
    sub a, 3
    ld [cursor], a

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

    ld a, [cursor]
    add a, 3
    ld [cursor], a

    call TurnOffLCD
    call RenderCursor
    call TurnOnLCD
.end
    ret

MarkOpponent:
    ld d, 0
    ld a, [serial_data]
    ld e, a

    ld a, [player_num]
    xor a, $01
    add a, 1
    ld c, a
    call Mark
    ret

MarkPlayer:
.offset
    ld d, 0
    ld a, [cursor]
    ld e, a
    
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