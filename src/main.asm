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


SECTION "Header", ROM0[$100]
    di
    jp Start

REPT $150-$104
    db 0
ENDR


SECTION "Game code", ROM0

Start:
.lockup
    jp .lockup
