SECTION "Connection", ROM0

SetupConnection:
    ld a, $FF
    ld [player_num], a
    jp AwaitConnection

AwaitConnection:
    call EnableVBlank
    call EnableSerial
    call ListenData
.lockup
    ei
    call WaitVblank
    di
.ifStart
    ld a, [joybuttons]

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
    ld a, %10101010
    call SendData

    call SetupGame
.ifFistGame
    ld a, [player_num]
    cp a, $FF
    jp nz, .end
.then
    ld a, 0
    ld [player_num], a
.end
    jp Decision

AcceptConnection:
    ld a, %10101010
    call SendData

    call SetupGame
.ifFistGame
    ld a, [player_num]
    cp a, $FF
    jp nz, .end
.then
    ld a, 1
    ld [player_num], a
.end
    jp Decision
