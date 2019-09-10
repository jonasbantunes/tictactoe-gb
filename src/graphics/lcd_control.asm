; Wait until Vblank to disable LCD to show VRAM content.
;
; **Warning: the LCD must be enable to use this function! Otherwise, unexpected
;   behavior can happen**.
;
; Destroys register `af`
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

; Set flag to enable LCD to display the VRAM content.
;
; Destroys register `af`
TurnOnLCD:
	ld a, [rLCDC]
	or a, LCDCF_ON
	or a, LCDCF_BGON
	ld [rLCDC], a
	ret

; Set hardcoded palettes for background and sprites.
;
; Destroys register `af`
SetPalettes:
	ld a, %11100100
	ld [rBGP], a
    ld a, %11100100
    ld [rOBP0], a
    ld a, %00000000
    ld [rOBP1], a

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