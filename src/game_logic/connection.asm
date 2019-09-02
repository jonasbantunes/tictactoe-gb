SECTION "Connection", ROM0

Connect:
    call TurnOffLCD
    call RenderAwaiting
    call TurnOnLCD

    call EnableVBlank
    call EnableSerial

    jp AwaitConnection

AwaitConnection:
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
.lockup
    jp .lockup

AcceptConnection:
    call TurnOffLCD
    call RenderConnected
    call TurnOnLCD
.lockup
    jp .lockup

Connected:
.lockup
    jp .lockup

SendData:
    ld [rSB], a
    ld a, $81
    ld [rSC], a
    ret

ListenData:
    ld a, $80
    ld [rSC], a
    ret