SECTION "Connection", ROM0

AwaitConnection:
    call TurnOffLCD
    call RenderAwaiting
    call TurnOnLCD

    call EnableVBlank
    call EnableSerial
    call ListenData
.lockup
    ei
    call WaitVblank
    di
.ifStart
    ; TODO: put this next 5 instructions in a function
    ld a, [joybuttons]
    ld b, a
    ld a, [joyhold]
    cpl
    and a, b

    bit PADB_START, a
    jp z, .ifReceive
.thenStart
    jp StartConnection
.ifReceive
    ld a, [serial_data]
    cp a, %10101010
    jp nz, .end
.thenReceive
    jp AcceptConnection
.end
    jp .lockup

StartConnection:
    call TurnOffLCD
    call RenderConnecting
    call TurnOnLCD

    ld a, %10101010
    call SendData

    call EnableVBlank
    call EnableTimerInt
.lockup
    ei
    call WaitVblank
    di
.if
    ld a, [serial_data]
    cp a, %10101010
    jp nz, .end 
.then
;     call TurnOffLCD
;     call RenderConnected
;     call TurnOnLCD
; .lock
;     jp .lock
    call SetupGame
    ld a, 0
    ld [player_turn], a
    ld a, 0
    ld [player_num], a
    jp Decision
.end
    jp .lockup

AcceptConnection:
    ; call TurnOffLCD
    ; call RenderConnected
    ; call TurnOnLCD

    ld a, %10101010
    call SendData
.lockup
    call SetupGame
    ld a, 0
    ld [player_turn], a
    ld a, 1
    ld [player_num], a
    jp Decision
    jp .lockup
