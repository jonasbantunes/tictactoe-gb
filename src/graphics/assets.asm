; Load font.chr asset to _VRAM -> _VRAM + $7F.
; 
; Destroys registers `af`, `bc`, `de`,  `hl`
LoadFont:
	ld hl, _VRAM
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
.while
	ld a, b
	or c
	and a
	jp z, .end
.do
	ld a, [de]
	inc de
	ld [hl], a
	inc hl
	dec bc
	jp .while
.end
	ret