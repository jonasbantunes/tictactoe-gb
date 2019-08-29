SECTION "Game code", ROM0

Start:
	call CleanWRAM
	call InitVariables
	call TurnOffLCD
	call ClearORM
	call SetBGPalette
	call LoadFont
	call ShowGrid
	call ShowCursor
	call TurnOnLCD
	call EnableVBlank
	ei
.lockup
	halt
	jp .lockup

CleanWRAM:
	ld a, 0
	ld hl, $C000
.while
	ld a, h
	cp $D0
	jp nc, .end
.do
	ld [hl], 0
	inc hl
	jp .while
.end
	ret

InitVariables:
	ld a, 4*8
	ld [cursor_x], a
	ld a, 5*8
	ld [cursor_y], a
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

SetBGPalette:
	ld a, %11100100
	ld [rBGP], a
	ret

LoadFont:
	ld hl, $8000
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

ShowGrid:
	ld hl, $9800
	ld bc, hello
	ld d, 0
.while
	ld a, [bc]
	inc bc
	and a
	jp z, .endWhile
.do
	ld [hl], a
	inc hl
	inc d

.if
	ld a, d
	cp 20
	jp c, .endIf
.then
	ld a, l
	add a, 12
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

	ld d, 0
	jp .endIf
.endIf

	jp .while
.endWhile
	ret

ClearORM:
	ld a, 0
	ld hl, _OAMRAM
.do
	ld [hl], 0
	inc hl
	inc a
.while
	cp a, $9F+1
	jp c, .do
.end
	ret

ShowCursor:
	ld hl, _OAMRAM
	ld a, [cursor_x]
	ld [hl], a
	inc hl
	ld a, [cursor_y]
	ld [hl], a
	inc hl
	ld [hl], $40
	inc hl
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

EnableVBlank:
	ld a, [rIE]
	xor a, IEF_VBLANK
	ld [rIE], a
	ret


SECTION "Font", ROM0

FontTiles:
INCBIN "src/assets/font.chr"
FontTilesEnd:


SECTION "Constants", ROM0

hello:
	db "     YOUR TURN!     "
	db "                    "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "   ----+----+----   "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "   ----+----+----   "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "                    "
	db "P1: 0          P2: 0"
	db 0


SECTION "Variables", WRAM0

cursor_x:
	ds 1
cursor_y:
	ds 1
grid:
	ds 9
grid_end:
