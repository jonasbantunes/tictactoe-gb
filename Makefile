GB_ASM := rgbasm
GB_LINK := rgblink
GB_FIX := rgbfix
ROM_NAME := tictactoe
EMULATOR := bgb64

default: build/$(ROM_NAME).gb

run: build/$(ROM_NAME).gb
	$(EMULATOR) $<
run-linked: build/$(ROM_NAME).gb
	$(EMULATOR) $< -set winx=300 -listen &
	$(EMULATOR) $< -set winx=800 -connect &
clean:
	@rm -r build

build:
	mkdir $@

build/main.o: main.asm | build
	$(GB_ASM) -o $@ $<

build/$(ROM_NAME).gb: build/main.o
	$(GB_LINK) -n build/$(ROM_NAME).sym -o $@ $<
	$(GB_FIX) -v -p 0 $@
