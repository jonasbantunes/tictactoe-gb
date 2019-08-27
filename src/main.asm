INCLUDE "hardware.inc"


SECTION "Vblank", ROM0[$0040]
	reti


SECTION "LCDC", ROM0[$0048]
	reti


SECTION "Timer", ROM0[$0050]
	reti


SECTION "Serial", ROM0[$0058]
	reti


SECTION "Joypad", ROM0[$0060]
	reti


SECTION "Entrypoint", ROM0[$100]
	di
	jp Start


SECTION "Header", ROM0[$104]

REPT $150-$104
	db 0
ENDR


SECTION "Game code", ROM0

Start:
	call TurnOffLCD
	call SetPalette
	call LoadFont
	call ShowHello
	call TurnOnLCD
	call EnableVBlank
	ei
.lockup
	halt
	jp .lockup

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

SetPalette:
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

ShowHello:
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

EnableVBlank:
	ld a, [rIE]
	xor a, IEF_VBLANK
	ld [rIE], a
	ret


SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:


SECTION "Constants", ROM0

hello:
	db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel justo eros. Morbi egestas vehicula elit posuere viverra. Sed vel tempus est. Aliquam posuere condimentum nibh, vel congue dolor maximus malesuada. Proin iaculis turpis in neque blandi"
	db "t, non sagittis nisl porttitor. Aliquam auctor faucibus leo a gravida. Morbi hendrerit felis tortor metus."
	db 0