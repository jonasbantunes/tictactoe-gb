SendData:
    ld [rSB], a
    ld a, $81
    ld [rSC], a
    ret

ListenData:
    ld a, $80
    ld [rSC], a
    ret