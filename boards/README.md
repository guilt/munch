# Board directories

Each directory has a self-contained Makefile that works with the OSS CAD Suite (Yosys + open tools).

- `tangnano-9k/` — full open flow (Yosys + nextpnr-himbaechel + Apicula) → `blinky-tangnano-9k.fs`
- `arty-s7/` — Yosys `synth_xilinx` → `blinky-arty-s7.json` / `.edif` (Yosys synth only; full .bit needs local openXC7)
- `nexys2/` — Yosys `synth_xilinx -family xc3se` → `blinky-nexys2.edif` (finish with ISE)
- `mister/` — Yosys `synth_intel_alm` → `blinky-superstation.vqm` (finish with Quartus for `.rbf`)

Pin constraints under `../constraints/` are starting points — always verify against your board schematic.

## Added boards
- **Arty A7** (Artix-7): Yosys → JSON/EDIF. Yosys synth only; full .bit needs local openXC7.
- **Tang Nano 20K** (Gowin GW2AR): full open flow → .fs.

- `tangnano-20k/` — full open flow → `blinky-tangnano-20k.fs`
- `arty-a7/` — Yosys synth → `blinky-arty-a7.json` + `.edif`
