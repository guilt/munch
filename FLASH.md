# How to flash munch bitstreams

Download the latest release from the Releases page. You will find one file per board that has a ready-to-flash image.

Install the programmer once (Linux / macOS / Windows):

```bash
# Debian/Ubuntu example
sudo apt install openfpgaloader
# or from source: https://github.com/trabucayre/openFPGALoader
```

Plug the board in with a data USB cable (not a charge-only cable). Then run the matching command below.

---

## Tang Nano 9K

**File:** `blinky-tangnano9k.fs`

Temporary (lost on power cycle):
```bash
openFPGALoader -b tangnano9k blinky-tangnano9k.fs
```

Permanent (survives power cycle):
```bash
openFPGALoader -b tangnano9k -f blinky-tangnano9k.fs
```

LED on pin 10 should blink.

---

## Arty S7 (Spartan-7)

**File:** `blinky-arty-s7.bit` (produced by openXC7 / Yosys flow when available)

Temporary:
```bash
openFPGALoader -b arty_s7 blinky-arty-s7.bit
```

Permanent (SPI flash):
```bash
openFPGALoader -b arty_s7 -f blinky-arty-s7.bit
```

(Or use the onboard PROG button + Digilent Adept / Vivado Hardware Manager if you prefer.)

---

## Nexys 2 (Spartan-3E)

**File:** `blinky-nexys2.bit` (requires ISE 14.7 to finish after Yosys EDIF)

Nexys 2 uses a Cypress USB interface. Common options:

```bash
# openFPGALoader (if cable detected)
openFPGALoader -b nexys2 blinky-nexys2.bit
```

Or use Digilent Adept / Impact from ISE:
```
Impact → Boundary Scan → Initialize chain → Assign blinky-nexys2.bit → Program
```

---

## SuperStation One / MiSTer (Cyclone V)

**File:** `blinky-superstation.rbf` (Quartus flow)

1. Copy the `.rbf` to the root of the MiSTer SD card (or the SuperStation media).
2. Reboot or select it from the MiSTer menu.

Alternatively with a USB Blaster:
```bash
openFPGALoader -c usb-blaster blinky-superstation.rbf
```

---

## Quick reference

| Board            | File                     | Flash command (SRAM / temp)                  |
|------------------|--------------------------|----------------------------------------------|
| Tang Nano 9K     | blinky-tangnano9k.fs     | `openFPGALoader -b tangnano9k FILE`          |
| Arty S7          | blinky-arty-s7.bit       | `openFPGALoader -b arty_s7 FILE`             |
| Nexys 2          | blinky-nexys2.bit        | `openFPGALoader -b nexys2 FILE` or Impact    |
| SuperStation 1   | blinky-superstation.rbf  | Copy to SD card or `openFPGALoader -c usb-blaster` |

Add `-f` to any openFPGALoader command to write flash (persistent) instead of SRAM.

Pin constraints in this repo are starting points — verify against your board schematic if the LED does not blink.
