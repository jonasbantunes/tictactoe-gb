SECTION "Game logic", ROM0

LogicEntry:
    jp TurnP1

TurnP1
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
    call Mark3819
    jp .end
.end
    jp TurnP1

WaitVblank:
.do
    halt
.while
    ld a, [rLY]
    cp 144
    jp c, .do
.end
    ret

Mark:
.offset
    ld hl, 3
    ld d, 0
    ld a, [cursor_y]
    ld e, a
    call Multiply  ; bc = de * hl
    
    ld a, [cursor_x]
    ld b, a
    ld a, c
    add a, b
.store
    ld hl, marks
    ld e, a
    ld d, 0
    add hl, de

    ld [hl], 1
.update
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