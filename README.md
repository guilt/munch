# munch — Multi-FPGA Usable Newbie Chips

Minimal multi-board LED blinker that builds with Yosys (and open tools) and ships ready-to-flash images in GitHub Releases.

**Boards:** Tang Nano 9K · Tang Nano 20K · Arty A7 · Arty S7 · Kintex-7 (QMTech XC7K325T) · Nexys 2 · SuperStation One / MiSTer (Cyclone V)
- **Arty S7-25** (`arty-s7-25`): openXC7 bitstream
- **Arty A7-100T** (`arty-a7-100t`): openXC7 bitstream

---

## Flash it (easiest)

1) Go to [Releases](https://github.com/guilt/munch/releases) and download the file for your board.  
2) Follow the one-liner in **FLASH.md**.

Example (Tang Nano 9K):

```bash
openFPGALoader -b tangnano9k blinky-tangnano-9k.fs
```

Example (Kintex-7 QMTech):
- **Kintex-7 480T** (`kintex7-480t`): openXC7 bitstream (chipdb generated on first use)

```bash
openFPGALoader -b qmtechKintex7 blinky-kintex7-qmtech.bit
```

---

## What you get in each release

| Board                  | Artifact                          | Status                                      |
|------------------------|-----------------------------------|---------------------------------------------|
| Tang Nano 9K           | blinky-tangnano-9k.fs             | Full open flow — ready to flash             |
| Tang Nano 20K          | blinky-tangnano-20k.fs            | Full open flow — ready to flash             |
| Arty A7                | blinky-arty-a7.bit (+ json/edif)  | Full open flow in CI (openXC7) — ready to flash |
- **Arty A7-100T** (`arty-a7-100t`): openXC7 bitstream
| Arty S7                | blinky-arty-s7.bit (+ json/edif)  | Full open flow in CI (openXC7) — ready to flash |
- **Arty S7-25** (`arty-s7-25`): openXC7 bitstream
| Kintex-7 (QMTech)      | blinky-kintex7-qmtech.bit         | Full open flow in CI (openXC7) — ready to flash |
| Nexys 2                | blinky-nexys2.json + .edif        | Yosys experimental synth (finish with ISE)  |
| SuperStation / MiSTer  | blinky-superstation.vqm           | Yosys open synth (full .rbf needs local Quartus) |

---

## Design

One shared Verilog (`src/blinky.v`) — free-running counter, MSB drives an LED.  
Board pin constraints live under `constraints/`.

---

## Quick start

```bash
make                    # help
make pre-check          # check tools
make bit                # final artifact for default board (tangnano-9k)
make BOARD=arty-a7 bit  # Arty A7 .bit (needs openXC7 locally; CI has it)
- **Arty A7-100T** (`arty-a7-100t`): openXC7 bitstream
make BOARD=kintex7-qmtech bit  # Kintex-7 .bit (needs openXC7)
make build              # intermediates only (json/edif/vqm/fasm)
make flash              # flash default board (openFPGALoader)
make clean
```

Or build from source: https://github.com/openXC7/toolchain-installer

Then:

```bash
make BOARD=tangnano-9k bit     # .fs
make BOARD=tangnano-20k bit    # .fs
make BOARD=arty-a7 bit         # .bit
make BOARD=arty-s7 bit         # .bit
make BOARD=kintex7-qmtech bit  # .bit
make BOARD=nexys2 bit          # .json + .edif
make BOARD=superstation bit    # .vqm
```

---

## Acknowledgments

- Open toolchains: Yosys, nextpnr, Apicula, openXC7, openFPGALoader
- Board vendors and community reverse-engineering efforts
