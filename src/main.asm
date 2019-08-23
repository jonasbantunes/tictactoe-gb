INCLUDE "hardware.inc"


SECTION "Vblank", ROM0[$0040]
	call loadJoypad
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
	cpl
	and $0F
	swap a
	ld b, a
	; Load lower buttons
	ld a, P1F_4
	ld [rP1], a
	ld a, [rP1]
	cpl
	and $0F
	or a, b
	; Save loaded buttons
	ld [joybuttons], a
	ret

; changePalette:
; 	call loadJoypad
; 	ld a, [joybuttons]
; 	ld b, a
; .ifUp:
; 	ld a, b
; 	and a, P1F_2
; 	cp a, P1F_2
; 	jp nz, .ifDown
; .thenUP:
; 	jp .end
; .ifDown:
; .thenDown:
; 	jp .end
; .ifLeft:
; .thenLeft:
; 	jp .end
; .else:
; 	jp .end
; .end:
; 	ld [rBGP], a
; 	ret

SECTION "Variables", WRAM0

joybuttons:
	ds 1