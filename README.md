# munch — Multi-FPGA Usable Newbie Chips

Minimal multi-board LED blinker that builds with Yosys (and open tools) and ships ready-to-flash images in GitHub Releases.

**Boards:** Tang Nano 9K · Tang Nano 20K · Arty A7 · Arty S7 · Nexys 2 · SuperStation One / MiSTer (Cyclone V)

## Flash it (easiest)

1. Go to [Releases](https://github.com/guilt/munch/releases) and download the file for your board.
2. Follow the one-liner in **[FLASH.md](FLASH.md)**.

Example (Tang Nano 9K):
```bash
openFPGALoader -b tangnano9k blinky-tangnano-9k.fs
```

## What you get in each release

| Board                  | Artifact                         | Status |
|------------------------|----------------------------------|--------|
| Tang Nano 9K           | `blinky-tangnano-9k.fs`          | Full open flow — ready to flash |
| Tang Nano 20K          | `blinky-tangnano-20k.fs`         | Full open flow — ready to flash |
| Arty A7                | `blinky-arty-a7.bit` (+ json/edif) | Full open flow in CI (openXC7) — ready to flash |
| Arty S7                | `blinky-arty-s7.bit` (+ json/edif) | Full open flow in CI (openXC7) — ready to flash |
| Nexys 2                | `blinky-nexys2.json` + `.edif`   | Yosys experimental synth (finish with ISE) |
| SuperStation / MiSTer  | `blinky-superstation.vqm`        | Yosys open synth (full .rbf needs local Quartus) |

## Design

One shared Verilog (`src/blinky.v`) — free-running counter, MSB drives an LED. Board pin constraints live under `constraints/`.

## Quick start

```bash
make                    # help
make pre-check          # check tools
make bit                # final artifact for default board (tangnano-9k)
make BOARD=arty-a7 bit  # Arty A7 .bit (needs openXC7 locally; CI has it)
make BOARD=arty-s7 bit
make build              # intermediates only (json/edif/vqm/fasm)
make flash              # flash default board (openFPGALoader)
make clean
```

**Artifact model**
- `make build` / `make BOARD=... build` → intermediates stay in the board dir.
- `make bit` / `make BOARD=... bit` → final artifact for that board.

## Build locally

Install [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build/releases).

For Arty A7 / Arty S7 full `.bit`, also install openXC7 (CI does this automatically):
```bash
# prebuilt package used by CI
gh release download 2026-10-11 --repo FPGAwars/tools-openxc7 \
  --pattern "apio-openxc7-linux-x86-64-*.tgz"
sudo mkdir -p /opt/openxc7
sudo tar xzf apio-openxc7-linux-x86-64-*.tgz -C /opt/openxc7 --strip-components=1
export PATH="/opt/openxc7/bin:$PATH"
export NEXTPNR_XILINX_DIR=/opt/openxc7
```

Or build from source: https://github.com/openXC7/toolchain-installer

Then:
```bash
make BOARD=tangnano-9k bit     # .fs
make BOARD=tangnano-20k bit    # .fs
make BOARD=arty-a7 bit         # .bit
make BOARD=arty-s7 bit         # .bit
make BOARD=nexys2 bit          # .json + .edif
make BOARD=superstation bit    # .vqm
```

Per-board Makefiles also work directly:
```bash
cd boards/tangnano-9k && make bit
cd boards/arty-a7 && make bit
```

For the SuperStation `.rbf`, run Quartus locally (or a compatible Docker image) against `constraints/mister.qsf`. The CI Quartus image is best-effort and may not produce an `.rbf`.

## License

MIT
