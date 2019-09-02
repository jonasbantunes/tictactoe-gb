SECTION "Game code", ROM0

Start:
	call CleanWRAM
	call TurnOffLCD
	call ClearORM
	call SetPalettes
	call LoadFont
	call RenderTurnP1
	call RenderGrid
	call RenderScore
	call UpdateScore
	call RenderCursor
	call RenderMarks
	call TurnOnLCD
	call EnableVBlank
	call EnableTimerInt
	ei
	jp LogicEntry

; Start:
; 	call CleanWRAM
; 	call TurnOffLCD
; 	call ClearORM
; 	call SetPalettes
; 	call LoadFont
; 	call TurnOnLCD
; 	jp Connect
