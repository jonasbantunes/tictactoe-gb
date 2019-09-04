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


HideCursor:
	ld a, 0
	ld [_OAMRAM + 2], a
	ret

ShowCursor:
	ld a, $40
	ld [_OAMRAM + 2], a
	ret