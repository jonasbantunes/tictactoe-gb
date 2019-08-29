SECTION "Vblank", ROM0[$0040]
	reti


SECTION "LCDC", ROM0[$0048]
	reti


SECTION "Timer", ROM0[$0050]
	call TimerInt
	reti


SECTION "Serial", ROM0[$0058]
	reti


SECTION "Joypad", ROM0[$0060]
	reti


SECTION "Entry", ROM0[$100]
	di
	jp Start


SECTION "Header", ROM0[$104]

REPT $150-$104
	db 0
ENDR