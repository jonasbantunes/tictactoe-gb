RenderGrid:
	ld de, grid
	ld hl, _SCRN0 + 32*2

	call RenderString
	ret

; Render all marks done by players until now.
;
; Destroys registers `af`, `bc`, `de`, `hl`
RenderMarks:
	ld hl, _OAMRAM + $4
	ld b, 6*8 ; y-axis
	ld c, 5*8 ; x-axis
	ld de, marks
.while_y
	ld a, b
	cp 16*8+1
	jp nc, .end_y
.do_y
.while_x
	ld a, c
	cp 15*8+1
	jp nc, .end_x
.do_x
	ld a, b
	ld [hl], a
	inc hl

	ld a, c
	ld [hl], a
	inc hl

	ld a, [de]
	inc de
.ifMarkedX
	cp a, 1
	jp nz, .ifMarkedO
.thenMarkedX
	ld a, $58
	jp .end_if
.ifMarkedO
	cp a, 2
	jp nz, .else
.thenMarkedO
	ld a, $4F
	jp .end_if
.else
	ld a, $00
	jp .end_if
.end_if
	ld [hl], a
	inc hl

	ld a, 0
	ld [hl], a
	inc hl

	ld a, c
	add a, 5*8
	ld c, a

	jp .while_x
.end_x
	ld c, 5*8

	ld a, b
	add a, 5*8
	ld b, a

	jp .while_y
.end_y
	ret

; Switch marks's palettes. Can be use to give a blink effect.
;
; Destroy registers `af`, `b`, `de`, `hl`
ToggleMarks:
    ld hl, _OAMRAM + 4 + 3
    ld de, marks_blink
    ld b, 0
.while
    ld a, b
    cp a, 9
    jp nc, .endWhile
.do
    ld a, [de]
    inc de
.if
    cp a, 1
    jp nz, .endIf
.then
    ld a, [hl]
    xor a, %00010000
    ld [hl], a
.endIf
    ld a, l
    add a, 4
    ld l, a
    ld a, h
    adc a, 0
    ld h, a

    inc b
    jp .while
.endWhile
    ret