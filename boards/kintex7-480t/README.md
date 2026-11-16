# Kintex-7 XC7K480T — YPCB-00338-1P1

Surplus PCIe accelerator card sold as "Inspur/Baidu XC7K480T development board".
The FPGA is an **XC7K480T-2FFG1156** (IDCODE `0x23751093`), with a 64 MiB
Micron `MT28GU512` BPI flash and an x8 PCIe edge connector. The factory image
enumerates as `10ee:7028`; it is an 18.73 MB bitstream at flash offset 0.

This target builds the shared `src/blinky.v` for the card with openXC7. It is a
JTAG-only bring-up image: it does **not** implement PCIe, so loading it removes
the card from the PCIe bus until power-off/JPROGRAM.

## Pins

| Signal | Pin | Notes |
|---|---|---|
| `SYS_CLK` | `AA28` | 50 MHz, bank 14, LVCMOS18 |
| `led` (LED0) | `P30` | active high, LVCMOS18; LED1/LED2 are `M30`/`N30` |
| `AC24` | `AC24` | board reset — **must never be pulled low** |

`board.fasm` in this directory is appended to every build and sets
`LIOB33_SING_X0Y150.IOB_Y0.PULLTYPE.PULLUP` for AC24. Without it, startup never
reaches DONE and the card resets itself. Do not build with `BOARD_FASM=`.

## Build

```bash
make -C boards/kintex7-480t bit
```

Needs the [openXC7](https://github.com/openXC7) toolchain (`yosys`,
`nextpnr-xilinx`, `fasm2frames`, `xc7frames2bit`, `bbasm`) and the full
prjxray-db for Kintex-7. The first build generates the XC7K480T chipdb into
`$(CHIPDB)` and can take several minutes and ~13 GB of RAM. Toolchain and cache
paths can be overridden, e.g.:

```bash
make -C boards/kintex7-480t bit \
  NEXTPNR_XILINX_DIR=/opt/openxc7 \
  CHIPDB_DIR=/opt/openxc7-build/chipdb \
  CHIPDB=/opt/openxc7-build/chipdb/xc7k480t.bin \
  PRJXRAY_DB=/opt/openxc7-build/prjxray-db \
  GEN_SCRIPT=/opt/openxc7-build/nextpnr/himbaechel/uarch/xilinx/gen/xilinx_gen.py \
  META_REPO=/opt/openxc7-build/nextpnr-xilinx-meta
```

Output: `blinky-kintex7-480t.bit`.

## JTAG

JTAG is on the card's **J1** header (standard Xilinx 2×7, 1.8 V bank). PCIe does
not carry JTAG; use the header.

| J1 | Signal | J1 | Signal |
|---|---|---|---|
| 1,3,5,7,9,11,13 | GND | 2 | VREF |
| 4 | TMS | 6 | TCK |
| 8 | TDO | 10 | TDI |
| 12 | NC | 14 | SRST |

Cables:

- Digilent JTAG-HS3 / HS2, or any FT232H/FT2232H cable.
- Xilinx Platform Cable USB II / DLC10 clone (`03fd:0013`, `03fd:000d`), with
  openFPGALoader **v1.2.0 or newer** (the 0.13.1 package predates the XPCU
  driver). Check with `openFPGALoader --list-cables | grep xilinx`.

The card's JTAG chain also contains an Inspur CPLD at `0x10931093` (IR length 8),
so pass `--misc-device 0x10931093,8,inspur_cpld`.

The XPCU clone needs its FX2 firmware loaded on each plug-in; openFPGALoader can
use the copy shipped with ISE/Vivado:

```bash
openFPGALoader \
  -c xilinxPlatformCableUsb \
  --probe-firmware /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xp2.hex \
  --misc-device 0x10931093,8,inspur_cpld \
  -b ypcb003381p1 \
  --detect
```

Expected: IDCODE `0x23751093`, model `xc7k480t`. For a Digilent/FT232H cable use
`-c digilent_hs3` (or `digilent_hs2`) instead; drop the firmware and
`--misc-device` options if the cable handles them.

Load (volatile SRAM — lost on power-off):

```bash
openFPGALoader ... -b ypcb003381p1 blinky-kintex7-480t.bit
```

Flash:

```bash
openFPGALoader ... -b ypcb003381p1 --dump-flash --file-size 67108864 factory.bin
openFPGALoader ... -b ypcb003381p1 -f blinky-kintex7-480t.bit
```

**Back up the 64 MiB factory flash before writing it.** Writing the BPI flash
replaces the factory PCIe image; a JTAG cable is then the only recovery path.
`--dump-flash` over BPI-over-JTAG is slow; Vivado Lab's
`readback_hw_cfgmem` is much faster. Never program eFUSE/OTP bits, and keep
`AC24` pulled up.

## References

- [sirmick/ypcb-00338-1p1](https://github.com/sirmick/ypcb-00338-1p1) — card
  notes, board.fasm, openXC7 designs, JTAG/flash utilities.
- [TiferKing/ypcb_00338_1p1_hack](https://github.com/TiferKing/ypcb_00338_1p1_hack)
  — board files, pinout, Vivado example.
- [FeSens/inspur-adventures](https://github.com/FeSens/inspur-adventures) —
  openXC7 bring-up and DLC10/XPCU details.
- [openFPGALoader cable support](https://trabucayre.github.io/openFPGALoader/compatibility/cable.html)
  and [board list](https://trabucayre.github.io/openFPGALoader/compatibility/board.html).
