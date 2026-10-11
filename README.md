# Multi-Board FPGA Blinky

A minimal LED blinker (the FPGA "Hello World") targeting four boards with GitHub Actions CI that produces bitstreams as release artifacts.

**Boards:**
- SuperStation One / MiSTer (Cyclone V, `.rbf`)
- Tang Nano 9K (Gowin GW1NR-9, `.fs`)
- Nexys 2 (Spartan-3E, `.bit` — legacy)
- Arty S7 (Spartan-7, `.bit`)

## Simple Circuit

One shared Verilog top-level (`src/blinky.v`) that drives a single LED from the MSB of a free-running counter. Board-specific pin constraints and (where needed) clock frequencies live under `constraints/` and `boards/`.

## Toolchains (combination is intentional)

| Board              | Preferred flow                          | CI status on GitHub-hosted runners |
|--------------------|-----------------------------------------|------------------------------------|
| Tang Nano 9K       | Yosys + nextpnr-himbaechel + Apicula    | Fully open, works                  |
| Arty S7            | openXC7 (Yosys + nextpnr-xilinx + prjxray) | Possible (chipdb heavy)         |
| SuperStation / MiSTer | Quartus 17.0 Docker                  | Docker image available             |
| Nexys 2            | ISE 14.7 Docker (Yosys synth optional)  | Possible but heavy (license + size)|

See individual board directories or the workflow for exact commands.

## GitHub Actions

- Workflow: `.github/workflows/fpga.yml`
- Builds on push/PR
- Uploads bitstreams as artifacts
- On tags (`v*`) creates a GitHub Release with the bitstreams attached

## Local build

```bash
# Example: Tang Nano (after installing OSS CAD Suite or the packages)
cd boards/tangnano9k
make
```

Flash with `openFPGALoader` or the vendor tool for your board.

## License

MIT — the design is trivial; vendor toolchains remain under their own licenses.
