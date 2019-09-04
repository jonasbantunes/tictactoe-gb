SECTION "Game code", ROM0

Start:
	call CleanWRAM
	call TurnOffLCD
	call ClearORM
	call SetPalettes
	call LoadFont
	call RenderAwaiting
	call TurnOnLCD

	jp AwaitConnection
