SECTION "Rendering", ROM0

RenderYouWon:
	ld de, msg_won
	ld hl, _SCRN0
	call RenderString
	ret

RenderTurnP1:
	ld de, msg_turn_p1
	ld hl, _SCRN0
	call RenderString
	ret

RenderScore:
	ld de, scoreboard
	ld hl, _SCRN0 + 32*16
	call RenderString 
	ret

RenderGrid:
	ld de, grid
	ld hl, _SCRN0 + 32*2

	call RenderString
	ret

RenderString:
.loadAdresses
	ld b, 0
.while
	ld a, [de]
	inc de
	and a
	jp z, .endWhile
.do
	ld [hl], a
	inc hl
	inc b

.if
	ld a, b
	cp 20
	jp c, .endIf
.then
	ld a, l
	add a, 12
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

	ld b, 0
	jp .endIf
.endIf

	jp .while
.endWhile
	ret

UpdateScore:
	ld a, [scores]
	add a, $30
	ld [_SCRN0+32*17+4], a

	ld a, [scores+1]
	add a, $30
	ld [_SCRN0+32*17+19], a

	ret

RenderCursor:
	ld hl, 5*8
	ld d, 0
	ld a, [cursor_y]
	ld e, a
	call Multiply  ; bc = de * hl
	ld a, c
	add a, 4*8
	ld hl, _OAMRAM
	ld [hl], a

	ld hl, 5*8
	ld d, 0
	ld a, [cursor_x]
	ld e, a
	call Multiply  ; bc = de * hl
	ld a, c
	add a, 5*8
	ld hl, _OAMRAM + 1
	ld [hl], a

	ld hl, _OAMRAM + 2
	ld [hl], $40
	
	ld hl, _OAMRAM + 3
	ld a, 0
	or a, OAMF_YFLIP
	ld [hl], a

	ld a, [rLCDC]
	or a, LCDCF_OBJON
	cpl
	or a, LCDCF_OBJ16
	cpl
	ld [rLCDC], a
	ret

ToggleCursor:
	ld hl, _OAMRAM+3
	ld a, [hl]

	xor a, %00010000
	ld [hl], a

	ret

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

TurnOffLCD:
.loop
	ld a, [rLY]
	cp a, 144
	jp c, .loop
.end
	ld a, [rLCDC]
	cpl
	or a, LCDCF_ON
	cpl
	ld [rLCDC], a
	ret

TurnOnLCD:
	ld a, [rLCDC]
	or a, LCDCF_ON
	or a, LCDCF_BGON
	ld [rLCDC], a
	ret

SetPalettes:
	ld a, %11100100
	ld [rBGP], a
    ld a, %11100100
    ld [rOBP0], a
    ld a, %00000000
    ld [rOBP1], a

	ret

LoadFont:
	ld hl, _VRAM
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
.while
	ld a, b
	or c
	and a
	jp z, .end
.do
	ld a, [de]
	inc de
	ld [hl], a
	inc hl
	dec bc
	jp .while
.end
	ret