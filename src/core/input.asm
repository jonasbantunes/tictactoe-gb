SECTION "Input", ROM0

loadJoypad:
.copy
	ld a, [joybuttons]
	ld [joyhold], a
.upper
	ld a, P1F_5
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	cpl
	and $0F
	swap a
	ld b, a
.lower
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
.store
	ld [joybuttons], a
    
	ret