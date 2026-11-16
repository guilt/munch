# Board directories

Each directory has a self-contained Makefile. Top-level `make bit BOARD=...` dispatches here.

- `tangnano-9k/` — full open flow (Yosys + nextpnr-himbaechel + Apicula) → `blinky-tangnano-9k.fs`
- `tangnano-20k/` — full open flow → `blinky-tangnano-20k.fs`
- `arty-a7/` — Yosys + openXC7 → `blinky-arty-a7.bit` (json/edif also produced)
- `arty-s7/` — Yosys + openXC7 → `blinky-arty-s7.bit` (json/edif also produced)
- `kintex7-480t/` — Yosys + openXC7 for the YPCB-00338-1P1 (XC7K480T-FFG1156) → `blinky-kintex7-480t.bit` (AC24 pull-up via `board.fasm`)
- `nexys2/` — Yosys `synth_xilinx -family xc3se` + ISE 14.7 P&R → `blinky-nexys2.bit` (json/edif also produced)
- `mister/` — Yosys `synth_intel_alm` → `blinky-superstation.vqm` (finish with Quartus for `.rbf`)

Pin constraints under `../constraints/` are starting points — always verify against your board schematic.

## Commands

```bash
make bit                  # from repo root, default board
make BOARD=arty-a7 bit
cd boards/arty-a7 && make bit
```
