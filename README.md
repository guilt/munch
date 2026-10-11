# munch — Multi-Board FPGA Blinky

Minimal LED blinker that builds with Yosys (and open tools) and ships ready-to-flash images in GitHub Releases.

**Boards:** Tang Nano 9K · Arty S7 · Nexys 2 · SuperStation One / MiSTer

## Flash it (easiest)

1. Go to [Releases](https://github.com/guilt/munch/releases) and download the file for your board.
2. Follow the one-liner in **[FLASH.md](FLASH.md)**.

Example (Tang Nano 9K):
```bash
openFPGALoader -b tangnano9k blinky-tangnano9k.fs
```

## What you get in each release

| Board              | Artifact                 | Status                                      |
|--------------------|--------------------------|---------------------------------------------|
| Tang Nano 9K       | `blinky-tangnano9k.fs`   | Full open flow — ready to flash             |
| Arty S7            | `blinky-arty-s7.bit`     | openXC7 (Yosys-based) when toolchain present|
| Nexys 2            | `blinky-nexys2.edif`     | Yosys experimental synth only (needs ISE)   |
| SuperStation / MiSTer | `blinky-superstation.rbf` | Quartus flow (not pure Yosys)            |

Only the Tang Nano image is produced on every GitHub-hosted CI run today. The others are documented so you can finish them locally or on a self-hosted runner.

## Design

One shared Verilog (`src/blinky.v`) — free-running counter, MSB drives an LED. Board pin constraints live under `constraints/`.

## Build locally (Tang Nano)

```bash
# Install OSS CAD Suite: https://github.com/YosysHQ/oss-cad-suite-build/releases
cd boards/tangnano9k
make
openFPGALoader -b tangnano9k blinky-tangnano9k.fs
```

## License

MIT
