# Board directories

Each directory has a self-contained Makefile that works with the OSS CAD Suite (Yosys + open tools).

- `tangnano9k/` — full open flow (Yosys + nextpnr-himbaechel + Apicula) → `blinky-tangnano9k.fs`
- `arty-s7/` — Yosys `synth_xilinx` → `blinky-arty-s7.json` / `.edif` (finish with openXC7)
- `nexys2/` — Yosys `synth_xilinx -family xc3se` → `blinky-nexys2.edif` (finish with ISE)
- `mister/` — Yosys `synth_intel_alm` → `blinky-superstation.vqm` (finish with Quartus for `.rbf`)

Pin constraints under `../constraints/` are starting points — always verify against your board schematic.
