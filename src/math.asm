Multiply:
    ld bc, 0
.while
    ld a, d
    or a, e
    jp z, .end
.do
    ld a, c
    add a, l
    ld c, a

    ld a, b
    adc a, h
    ld b, a

    dec de
    jp .while
.end
    ret