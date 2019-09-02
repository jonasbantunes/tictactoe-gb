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

WaitVblank:
.do
    halt
.while
    ld a, [rLY]
    cp 144
    jp c, .do
.end
    ret

EnableVBlank:
	ld a, [rIE]
	xor a, IEF_VBLANK
	ld [rIE], a
	ret

DisableVBlank:
	ld a, [rIE]
	cpl
	or a, IEF_VBLANK
	cpl
	ld [rIE], a
	ret

EnableSerial:
	ld a, [rIE]
	xor a, IEF_SERIAL
	ld [rIE], a
	ret

DisableSerial:
	ld a, [rIE]
	cpl
	or a, IEF_SERIAL
	cpl 
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