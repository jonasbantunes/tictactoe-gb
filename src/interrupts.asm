SECTION "Interruptions", ROM0

TimerInt:
    ld a, [counter]
    inc a
.if
    cp a, $4
    jp c, .else
.then
    call TurnOffLCD
    call ToggleCursor
    call TurnOnLCD

    ld a, 0
    ld [counter], a
    
    jp .end
.else
    ld [counter], a
.end
    ret