SERIAL_TYPE EQU $0

SECTION "Interruptions", ROM0

SerialInt:
    ld a, [rSC]
.if
    bit SERIAL_TYPE, a
    jp z, .else  ; branch if external clock
.then
    ld a, 0
    ld [serial_turn], a
    call ListenData
    jp .end
.else
    ld a, [rSB]
    ld [serial_data], a
    ld a, 1
    ld [serial_turn], a
.end
    ret

VblankInt:
    call loadJoypad
    ret

TimerInt:
    ld a, [counter]
    inc a
.if
    cp a, $3
    jp c, .else
.then
    call TurnOffLCD
    call ToggleCursor
    ; call ToggleMarks
    call TurnOnLCD

    ld a, 0
    ld [counter], a
    
    jp .end
.else
    ld [counter], a
.end
    ret