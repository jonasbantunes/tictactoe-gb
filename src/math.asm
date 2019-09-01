Multiply:
    ld a, [Multiply_arg0]
    ld h, a
    ld a, [Multiply_arg0 + 1]
    ld l, a
    ld a, [Multiply_arg1]
    ld d, a
    ld a, [Multiply_arg1 + 1]
    ld e, a
    ld bc, 0
.while
    ld a, d
    or a, e
    jp z, .end
.do
    ld a, c
    add a, l
    ld c, a

    ld a, d
    adc a, h
    ld d, a

    dec de
    jp .while
.end
    ld a, b
    ld [Multiply_out], a
    ld a, c
    ld [Multiply_out + 1], a
    ret