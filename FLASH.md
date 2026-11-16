# How to flash munch bitstreams

Download the latest release from the Releases page. Each board has one clearly named artifact.

Install the programmer once (Linux / macOS / Windows):

```bash
# Debian/Ubuntu example
sudo apt install openfpgaloader
# or from source: https://github.com/trabucayre/openFPGALoader
```

Plug the board in with a data USB cable (not charge-only). Then run the matching command.

---

## Tang Nano 9K

**File:** `blinky-tangnano-9k.fs`  
**Open flow:** Yes (Yosys + nextpnr + Apicula)

Temporary (SRAM):
```bash
openFPGALoader -b tangnano9k blinky-tangnano-9k.fs
```

Permanent (flash):
```bash
openFPGALoader -b tangnano9k -f blinky-tangnano-9k.fs
```

LED on pin 10 should blink.

---

## Arty S7 (Spartan-7)

**File:** `blinky-arty-s7.bit`  
**Open flow:** CI and local `make bit` produce the full `.bit` with openXC7.

Temporary:
```bash
openFPGALoader -b arty_s7_50 blinky-arty-s7.bit
```

Permanent:
```bash
openFPGALoader -b arty_s7 -f blinky-arty-s7.bit
```

---

## Nexys 2 (Spartan-3E)

**File:** `blinky-nexys2.bit` (built locally)

**Flow:** Yosys `synth_xilinx -family xc3se` + ISE 14.7 place & route.

Build and flash:
```bash
make BOARD=nexys2 bit
openFPGALoader -b nexys2 boards/nexys2/blinky-nexys2.bit
```
Or use Digilent Impact / Adept.

---

## SuperStation One / MiSTer (Cyclone V)

**Files:** `blinky-superstation.vqm` (Yosys open synth) · `blinky-superstation.rbf` (Quartus final, when CI produces it)

**Open flow:** Yosys `synth_intel_alm` produces the VQM. Full bitstream still needs Quartus (Docker image in CI or local).

Flash the `.rbf` (standard MiSTer / SuperStation method):
1. Copy `blinky-superstation.rbf` to the root of the SD card.
2. Reboot the SuperStation / MiSTer or select the core from the menu.

Optional USB Blaster:
```bash
openFPGALoader -c usb-blaster blinky-superstation.rbf
```

---

## Quick reference

| Board                  | Release artifact              | Flash command / method                          |
|------------------------|-------------------------------|-------------------------------------------------|
| Tang Nano 9K           | `blinky-tangnano-9k.fs`        | `openFPGALoader -b tangnano9k FILE`             |
| Arty S7                | `blinky-arty-s7.json`         | Local openXC7 → `openFPGALoader -b arty_s7` |
| Nexys 2                | `blinky-nexys2.bit` (local)   | `make BOARD=nexys2 bit` → `openFPGALoader -b nexys2` |
| Kintex-7 480T (YPCB)   | `blinky-kintex7-480t.bit`     | JTAG `J1` → `openFPGALoader -b ypcb003381p1` |
| SuperStation / MiSTer  | `blinky-superstation.rbf`     | Copy to SD card, or `openFPGALoader -c usb-blaster` |

Add `-f` to openFPGALoader commands for persistent flash where supported.

Pin constraints are starting points — verify against your board schematic if the LED does not blink.

## Tang Nano 20K

```bash
openFPGALoader -b tangnano20k blinky-tangnano-20k.fs
```

## Arty A7

Full bitstream needs a local openXC7 or Vivado install (not in CI). Current release artifact is the Yosys netlist:

```bash
# After generating .bit with openXC7 or Vivado:
openFPGALoader -b arty_a7_35t blinky-arty-a7.bit   # or arty_a7_100t
```

See the board's master XDC for pin confirmation (clk = E3, LED0 = H5).

## Kintex-7 (QMTech XC7K325T)
```bash
openFPGALoader -b qmtechKintex7 blinky-kintex7-qmtech.bit
```

## Kintex-7 480T (YPCB-00338-1P1)

**File:** `blinky-kintex7-480t.bit` (local openXC7 build).
**JTAG only:** header `J1` (2×7, 1.8 V). PCIe does not carry JTAG. The image
does not implement PCIe, so loading it removes the card from the bus until
power-off/JPROGRAM.

```bash
# Xilinx Platform Cable USB II / DLC10 clone (openFPGALoader v1.2.0+)
openFPGALoader -c xilinxPlatformCableUsb \
  --probe-firmware /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xp2.hex \
  --misc-device 0x10931093,8,inspur_cpld \
  -b ypcb003381p1 blinky-kintex7-480t.bit

# Digilent JTAG-HS3 / FT232H
openFPGALoader -c digilent_hs3 -b ypcb003381p1 blinky-kintex7-480t.bit
```

Before writing flash, back up the 64 MiB factory image (`--dump-flash`; Vivado
Lab is faster) and keep a JTAG recovery path. `-f` writes the BPI flash. Never
program eFUSE/OTP bits, and do not remove the AC24 pull-up in `board.fasm`.
See `boards/kintex7-480t/README.md` for the full pinout and cable details.
