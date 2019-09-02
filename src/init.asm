SECTION "Game code", ROM0

; Start:
; 	call CleanWRAM
; 	call TurnOffLCD
; 	call ClearORM
; 	call SetPalettes
; 	call LoadFont
; 	call RenderTurnP1
; 	call RenderGrid
; 	call RenderScore
; 	call UpdateScore
; 	call RenderCursor
; 	call RenderMarks
; 	call TurnOnLCD
; 	call EnableVBlank
; 	call EnableTimerInt
; 	ei
; 	jp LogicEntry

Start:
	call CleanWRAM
	call TurnOffLCD
	call ClearORM
	call SetPalettes
	call LoadFont
	call TurnOnLCD
	jp Connect


SECTION "Font", ROM0

FontTiles:
INCBIN "src/assets/font.chr"
FontTilesEnd:


SECTION "Constants", ROM0

msg_turn_p1:
	db "     YOUR TURN!     "
	db "                    "
	db 0
msg_turn_p2:
	db "   OPPONENT TURN!   "
	db "                    "
	db 0
msg_lost:
	db "      YOU LOST      "
	db "                    "
	db 0
msg_won:
	db "      YOU WON!      "
	db "                    "
	db 0
msg_awaiting:
	db "AWAITING  CONNECTION"
	db "                    "
	db 0
msg_connecting:
	db "  CONNECTING  WITH  "
	db "OPPONENT'S  GAME BOY"
	db 0
msg_connected:
	db "SUCCESFULY CONNECTED"  ; why not "successfully"?
	db "                    "
	db 0
grid:
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "   ----+----+----   "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "   ----+----+----   "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db "       |    |       "
	db 0
scoreboard:
	db "                    "
	db "P1: 0          P2: 0"
	db 0


SECTION "Variables", WRAM0

cursor_y:
	ds 1
cursor_x:
	ds 1
marks:
	ds 9
marks_end:
marks_blink:
	ds 9
marks_blink_end:
counter:
	ds 1
scores:
	ds 2
scores_end:
joybuttons:
	ds 1
joyhold:
	ds 1
player_turn:
	ds 1
winner:
	ds 1
turns_left:
	ds 1
serial_data:
	ds 1
serial_turn:
	ds 1