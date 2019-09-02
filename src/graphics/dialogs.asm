RenderAwaiting:
	ld de, msg_awaiting
	ld hl, _SCRN0
	call RenderString
	ret

RenderConnecting:
	ld de, msg_connecting
	ld hl, _SCRN0
	call RenderString
	ret

RenderConnected:
	ld de, msg_connected
	ld hl, _SCRN0
	call RenderString
	ret

RenderYouWon:
	ld de, msg_won
	ld hl, _SCRN0
	call RenderString
	ret

RenderYouLost:
	ld de, msg_lost
	ld hl, _SCRN0
	call RenderString
	ret

RenderTurnP1:
	ld de, msg_turn_p1
	ld hl, _SCRN0
	call RenderString
	ret

RenderTurnP2:
	ld de, msg_turn_p2
	ld hl, _SCRN0
	call RenderString
	ret