SECTION "Game code", ROM0

Start:
	call CleanWRAM
	call InitVariables
	call TurnOffLCD
	call ClearORM
	call SetBGPalette
	call LoadFont
	call RenderGrid
	call UpdateScore
	call RenderCursor
	call RenderMarks
	call TurnOnLCD
	call EnableVBlank
	call EnableTimerInt
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
	ld [cursor_y], a
	ld a, 5*8
	ld [cursor_x], a
	ld a, 1
	ld [marks], a
	ld a, 2
	ld [marks+1], a
	ld a, 1
	ld [marks+3], a
	ld a, 1
	ld [marks+6], a
	ld a, 3
	ld [scores], a
	ld a, 7
	ld [scores+1], a
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

RenderGrid:
	ld hl, RenderString_arg0
	ld de, grid
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl

	call RenderString
	ret

RenderString:
.loadAdresses
	ld a, [RenderString_arg0]
	ld b, a
	ld a, [RenderString_arg0+1]
	ld c, a

	ld hl, $9800 + 32*2
	; ld bc, grid
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

UpdateScore:
	ld a, [scores]
	add a, $30
	ld [$9800+32*17+4], a

	ld a, [scores+1]
	add a, $30
	ld [$9800+32*17+19], a

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

RenderCursor:
	ld hl, _OAMRAM
	ld a, [cursor_y]
	ld [hl], a
	inc hl
	ld a, [cursor_x]
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

EnableVBlank:
	ld a, [rIE]
	xor a, IEF_VBLANK
	ld [rIE], a
	ret

EnableTimerInt:
	ld a, [rTAC]
	cpl
	and a, TACF_16KHZ
	cpl
	or a, TACF_START
	ld [rTAC], a

	ld a, [rIE]
	or a, IEF_TIMER
	ld [rIE], a

	ret

ToggleCursor:
	ld a, [cursor_y]
	ld b, a

	ld hl, _OAMRAM
	ld a, [hl]

	xor a, b
	ld [hl], a

	ret


SECTION "Font", ROM0

FontTiles:
INCBIN "src/assets/font.chr"
FontTilesEnd:


SECTION "Constants", ROM0

message:
	db "     YOUR TURN!     "
	db "                    "
	db 0
grid:
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
	db 0
scoreboard:
	db "                    "
	db "P1: 0          P2: 0"
	db 0


SECTION "Variables", WRAM0

cursor_y:
	ds 1
cursor_x:
	ds 1
marks:
	ds 9
marks_end:
counter:
	ds 1
scores:
	ds 2

SECTION "Arguments", WRAM0

RenderString_arg0:
	ds 2
RenderString_arg1:
	ds 1
RenderString_arg2:
	ds 1
Multiply_arg0:
	ds 2
Multiply_arg1:
	ds 2
Multiply_out:
	ds 2