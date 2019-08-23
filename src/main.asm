INCLUDE "hardware.inc"


SECTION "Vblank", ROM0[$0040]
	call VblankInt
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
	ld [counter], a
	ld [palette], a
.enableInt
	ld a, 0
	xor a, IEF_VBLANK
	ld [rIE], a
	ei
.lockup
	halt
    jp .lockup

VblankInt:
.if:
	ld a, [counter]
	cp 60
	jp c, .else
.then:
	call SetPalette
	ld a, 0
	ld [counter], a
	jp .end
.else:
	add a, 1
	ld [counter], a
	jp .end
.end:
	ret

SetPalette:
	ld a, [palette]
	and a, %00000011
	ld b, a

	REPT 3
		sla a
		sla a
		xor a, b
	ENDR

	ld[rBGP], a

	ld a, b
	add a, 1
	and a, %00000011
	ld [palette], a
	ret


SECTION "Variables", WRAM0

counter:
	ds 1
palette:
	ds 1