INCLUDE "hardware.inc"


SECTION "Vblank", ROM0[$0040]
	call loadJoypad
	call changePalette
	reti


SECTION "LCDC", ROM0[$0048]
	reti


SECTION "Timer", ROM0[$0050]
	reti


SECTION "Serial", ROM0[$0058]
	reti


SECTION "Joypad", ROM0[$0060]
	reti


SECTION "Header", ROM0[$100]
    di
    jp Start

REPT $150-$104
    db 0
ENDR


SECTION "Game code", ROM0

Start:
.initVars
	ld a, 0
	ld [joybuttons], a
.enableInt
	ld a, 0
	xor a, IEF_VBLANK
	ld [rIE], a
	ei
.lockup
	halt
    jp .lockup

loadJoypad:
	; Load upper buttons
	ld a, P1F_5
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	cpl
	and $0F
	swap a
	ld b, a
	; Load lower buttons
	ld a, P1F_4
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	cpl
	and $0F
	or a, b
	; Save loaded buttons
	ld [joybuttons], a
	ret

changePalette:
	ld a, [joybuttons]
	ld b, a
.ifUp:
	bit 6, b
	jp z, .ifDown
.thenUP:
	ld a, %11111111
	ld [rBGP], a
	jp .end
.ifDown:
	bit 7, b
	jp z, .ifLeft
.thenDown:
	ld a, %00000000
	ld [rBGP], a
	jp .end
.ifLeft:
	bit 5, b
	jp z, .ifRight
.thenLeft:
	ld a, %01010101
	ld [rBGP], a
	jp .end
.ifRight:
	bit 4, b
	jp z, .end
.thenRight:
	ld a, %10101010
	ld [rBGP], a
	jp .end
.end:
	ret


SECTION "Variables", WRAM0

joybuttons:
	ds 1