GB_ASM := rgbasm
GB_LINK := rgblink
GB_FIX := rgbfix
INCLUDE_DIR := include
ROM_NAME := tictactoe
EMULATOR := bgb64

default: build/$(ROM_NAME).gb

run: build/$(ROM_NAME).gb
	$(EMULATOR) $<

build:
	mkdir -p $@

build/main.o: src/main.asm | build
	$(GB_ASM) -i $(INCLUDE_DIR)/ -o $@ $<

build/$(ROM_NAME).gb: build/main.o
	$(GB_LINK) -o $@ $<
	$(GB_FIX) -v -p 0 $@
