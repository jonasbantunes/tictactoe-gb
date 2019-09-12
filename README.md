# Tic Tac Toe for Game Boy

## Requisites

- A Game Boy emulator like [SameBoy](https://sameboy.github.io/) or [BGB](http://bgb.bircd.org/)
- [RGBDS](https://github.com/rednex/rgbds) for compiling the game (on PATH)
- [GNU Make](https://www.gnu.org/software/make/) (on PATH)

## Building

- Run `make` to generate the game (called `tictactoe.gb`)

## Running

- Just run the `.gb` file on a Game Boy emulator with link support or on 2 real Game Boy with link cable configured
- If BGB emulator is on PATH, you can also run `make run-linked` to start 2 linked emulators