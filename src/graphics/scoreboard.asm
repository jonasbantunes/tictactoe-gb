RenderScore:
	ld de, scoreboard
	ld hl, _SCRN0 + 32*16
	call RenderString 
	ret

UpdateScore:
	ld a, [scores]
	add a, $30
	ld [_SCRN0+32*17+4], a

	ld a, [scores+1]
	add a, $30
	ld [_SCRN0+32*17+19], a

	ret