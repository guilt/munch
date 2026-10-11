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

**File:** `blinky-tangnano9k.fs`  
**Open flow:** Yes (Yosys + nextpnr + Apicula)

Temporary (SRAM):
```bash
openFPGALoader -b tangnano9k blinky-tangnano9k.fs
```

Permanent (flash):
```bash
openFPGALoader -b tangnano9k -f blinky-tangnano9k.fs
```

LED on pin 10 should blink.

---

## Arty S7 (Spartan-7)

**File:** `blinky-arty-s7.json` (and `.edif`)  
**Open flow:** Yosys synthesis. Full `.bit` needs openXC7 / nextpnr-xilinx + Project X-Ray chipdb.

Temporary (when you have a `.bit`):
```bash
openFPGALoader -b arty_s7 blinky-arty-s7.bit
```

Permanent:
```bash
openFPGALoader -b arty_s7 -f blinky-arty-s7.bit
```

---

## Nexys 2 (Spartan-3E)

**File:** `blinky-nexys2.edif`  
**Open flow:** Yosys experimental (`synth_xilinx -family xc3se`). Full bitstream needs ISE 14.7.

After finishing in ISE:
```bash
openFPGALoader -b nexys2 blinky-nexys2.bit
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
| Tang Nano 9K           | `blinky-tangnano9k.fs`        | `openFPGALoader -b tangnano9k FILE`             |
| Arty S7                | `blinky-arty-s7.json`         | Finish with openXC7 → `openFPGALoader -b arty_s7` |
| Nexys 2                | `blinky-nexys2.edif`          | Finish with ISE → `openFPGALoader -b nexys2`    |
| SuperStation / MiSTer  | `blinky-superstation.rbf`     | Copy to SD card, or `openFPGALoader -c usb-blaster` |

Add `-f` to openFPGALoader commands for persistent flash where supported.

Pin constraints are starting points — verify against your board schematic if the LED does not blink.
