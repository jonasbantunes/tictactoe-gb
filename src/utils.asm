SECTION "Utilities", ROM0

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

CleanWRAM:
	ld a, 0
	ld hl, _RAM
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