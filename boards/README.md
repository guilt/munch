# Board directories

- `tangnano9k/` — fully open flow (Yosys + nextpnr-himbaechel + Apicula). Makefile provided.
- `arty-s7/` — openXC7 recommended. Add a Makefile patterned after openXC7/demo-projects once chipdb is available.
- `mister/` — Quartus 17.0 Docker. Create a `.qpf` / `.qsf` and invoke the container in CI.
- `nexys2/` — ISE 14.7 Docker. Yosys can generate EDIF (`synth_xilinx -family xc3se -ise`); ISE does PnR + bitgen. Heavy for hosted runners.

Pin constraints under `../constraints/` are starting points — always verify against your board schematic.
