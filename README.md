# munch — Multi-FPGA Usable Newbie Chips

Minimal multi-board LED blinker that builds with Yosys (and open tools) and ships ready-to-flash images in GitHub Releases.

**Boards:** Tang Nano 9K · Tang Nano 20K · Arty A7 · Arty S7 · Nexys 2 · SuperStation One / MiSTer (Cyclone V)

## Flash it (easiest)

1. Go to [Releases](https://github.com/guilt/munch/releases) and download the file for your board.
2. Follow the one-liner in **[FLASH.md](FLASH.md)**.

Example (Tang Nano 9K):
```bash
openFPGALoader -b tangnano9k blinky-tangnano-9k.fs
```

## What you get in each release

| Board                  | Artifact                     | Status                                      |
|------------------------|------------------------------|---------------------------------------------|
| Tang Nano 9K           | `blinky-tangnano-9k.fs`       | Full open flow — ready to flash             |
| Tang Nano 20K          | `blinky-tangnano-20k.fs`      | Full open flow — ready to flash             |
| Arty A7                | `blinky-arty-a7.json`        | Yosys synth (openXC7 for full `.bit`)       |
| Arty S7                | `blinky-arty-s7.json`        | Yosys synth (openXC7 for full `.bit`)       |
| Nexys 2                | `blinky-nexys2.edif`         | Yosys experimental synth (needs ISE)        |
| SuperStation / MiSTer  | `blinky-superstation.vqm`    | Yosys open synth (full .rbf needs local Quartus; CI image is incompatible) |

Only the Tang Nano image is a complete open bitstream on every hosted CI run. The others produce open Yosys intermediates; finish them locally or with the documented Docker/Quartus step.

## Design

One shared Verilog (`src/blinky.v`) — free-running counter, MSB drives an LED. Board pin constraints live under `constraints/`.

## Build locally (open toolchain)

## Quick start with top-level Makefile

```bash
make              # show help
make pre-check    # verify tools
make build        # build default board (Tang Nano 9K)
make BOARD=arty-s7 build
make flash        # flash default board (openFPGALoader)
make clean
```


Install [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build/releases), then:

```bash
# Tang Nano 9K (full bitstream)
cd boards/tangnano-9k && make

# Tang Nano 20K (full bitstream)
cd boards/tangnano-20k && make

# Arty A7 (JSON / EDIF)
cd boards/arty-a7 && make

# Arty S7 (JSON / EDIF)
cd boards/arty-s7 && make

# Nexys 2 (EDIF)
cd boards/nexys2 && make

| SuperStation / MiSTer  | `blinky-superstation.vqm`    | Yosys open synth (full .rbf needs local Quartus; CI image is incompatible) |
cd boards/mister && make
```

For the SuperStation `.rbf`, run the Quartus Docker image used in CI or a local Quartus install against `constraints/mister.qsf`.

## License

MIT
