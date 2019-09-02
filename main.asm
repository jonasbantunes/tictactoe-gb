; How shold be
; INCLUDE "src/constants/index.asm"
; INCLUDE "src/core/index.asm"
; INCLUDE "src/data/index.asm"
; INCLUDE "src/game_logic/index.asm"
; INCLUDE "src/graphics/index.asm"
; INCLUDE "src/utils/utils.asm"

; How VSCode plugin understands
INCLUDE "src/constants/hardware.inc"

INCLUDE "src/core/header.asm"
INCLUDE "src/core/interrupts.asm"
INCLUDE "src/core/input.asm"

INCLUDE "src/data/dialogs.asm"
INCLUDE "src/data/font.asm"
INCLUDE "src/data/grid.asm"
INCLUDE "src/data/scoreboard.asm"
INCLUDE "src/data/wram.asm"

INCLUDE "src/game_logic/logic.asm"
INCLUDE "src/game_logic/connection.asm"
INCLUDE "src/game_logic/init.asm"

INCLUDE "src/graphics/assets.asm"
INCLUDE "src/graphics/cursor.asm"
INCLUDE "src/graphics/dialogs.asm"
INCLUDE "src/graphics/grid.asm"
INCLUDE "src/graphics/lcd_control.asm"
INCLUDE "src/graphics/scoreboard.asm"

INCLUDE "src/utils/utils.asm"
INCLUDE "src/utils/serial.asm"
