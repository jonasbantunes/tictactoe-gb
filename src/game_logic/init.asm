SECTION "Game code", ROM0

; Start:
; 	call CleanWRAM
; 	call TurnOffLCD
; 	call ClearORM
; 	call SetPalettes
; 	call LoadFont
; 	call TurnOnLCD
; 	call SetupGame
; 	jp PlayerTurn

; Multiplayer
Start:
	call CleanWRAM
	call TurnOffLCD
	call ClearORM
	call SetPalettes
	call LoadFont
	call TurnOnLCD
	jp AwaitConnection
