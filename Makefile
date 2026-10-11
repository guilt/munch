# munch — top-level Makefile
# Inspired by TinyToT: help, pre-checks, per-board targets, flash.
#
# Usage:
#   make                 # show help
#   make pre-check       # check tools
#   make build           # build default board (tangnano9k)
#   make BOARD=arty-s7 build
#   make flash           # flash default board (needs openFPGALoader + board plugged in)
#   make clean

.DEFAULT_GOAL := help

# Default board — fully open flow
BOARD ?= tangnano9k

# Valid boards
BOARDS := tangnano9k arty-s7 nexys2 superstation

# Map friendly names
ifeq ($(BOARD),superstation)
  BOARD_DIR := boards/mister
else
  BOARD_DIR := boards/$(BOARD)
endif

.PHONY: help pre-check check-tools build flash clean test \
	tangnano9k arty-s7 nexys2 superstation mister \
	flash-tangnano9k flash-arty-s7 flash-nexys2 flash-superstation

help: ## Show this help
	@echo "munch — Multi-Board FPGA Blinky"
	@echo ""
	@echo "Usage: make [target] [BOARD=<board>]"
	@echo ""
	@echo "Boards: $(BOARDS)  (default: $(BOARD))"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-22s %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make pre-check"
	@echo "  make build                    # Tang Nano 9K bitstream"
	@echo "  make BOARD=arty-s7 build"
	@echo "  make flash                    # needs openFPGALoader + board"
	@echo "  make clean"

pre-check: check-tools ## Check required tools are on PATH

check-tools: ## Verify yosys, nextpnr, gowin_pack, openFPGALoader
	@echo "=== Checking toolchain ==="
	@command -v yosys >/dev/null 2>&1 && yosys --version | head -1 || echo "MISSING: yosys (install OSS CAD Suite)"
	@command -v nextpnr-himbaechel >/dev/null 2>&1 && echo "nextpnr-himbaechel: ok" || echo "MISSING: nextpnr-himbaechel (needed for Tang Nano)"
	@command -v gowin_pack >/dev/null 2>&1 && echo "gowin_pack: ok" || echo "MISSING: gowin_pack (needed for Tang Nano)"
	@command -v openFPGALoader >/dev/null 2>&1 && openFPGALoader --version 2>&1 | head -1 || echo "MISSING: openFPGALoader (needed to flash)"
	@echo "=== Done ==="

# Per-board builds
tangnano9k: ## Build Tang Nano 9K full bitstream (.fs)
	$(MAKE) -C boards/tangnano9k

arty-s7: ## Build Arty S7 Yosys netlist (.json + .edif)
	$(MAKE) -C boards/arty-s7

nexys2: ## Build Nexys 2 Yosys netlist (.json + .edif)
	$(MAKE) -C boards/nexys2

superstation: mister ## Build SuperStation / Cyclone V Yosys netlist (.vqm)
mister:
	$(MAKE) -C boards/mister

build: ## Build the selected board (BOARD=..., default tangnano9k)
	@echo "Building board: $(BOARD)"
	$(MAKE) $(BOARD)

# Flash targets (best-effort; openFPGALoader)
flash-tangnano9k: ## Flash Tang Nano 9K with openFPGALoader
	openFPGALoader -b tangnano9k boards/tangnano9k/blinky-tangnano9k.fs

flash-arty-s7: ## Attempt flash Arty S7 (needs .bit; openXC7 or Vivado)
	@echo "Arty S7 full bitstream requires openXC7 or Vivado."
	@echo "Current artifact is boards/arty-s7/blinky-arty-s7.json"
	@echo "See FLASH.md"

flash-nexys2: ## Attempt flash Nexys 2 (needs ISE .bit)
	@echo "Nexys 2 full bitstream requires ISE 14.7."
	@echo "Current artifact is boards/nexys2/blinky-nexys2.edif"
	@echo "See FLASH.md"

flash-superstation: ## Flash SuperStation / MiSTer (copy .rbf to SD card)
	@echo "SuperStation / MiSTer: copy blinky-superstation.rbf to the SD card root."
	@echo "Open artifact is boards/mister/blinky-superstation.vqm (needs Quartus for .rbf)."
	@echo "See FLASH.md"

flash: ## Flash the selected board (BOARD=..., default tangnano9k)
	$(MAKE) flash-$(BOARD)

test: ## Quick syntax / synth smoke test on default board
	@echo "Running smoke test (Yosys read + synth on blinky.v)..."
	yosys -p "read_verilog src/blinky.v; synth -top blinky; stat"
	@echo "Smoke test passed."

clean: ## Clean all board build artifacts
	$(MAKE) -C boards/tangnano9k clean
	$(MAKE) -C boards/arty-s7 clean
	$(MAKE) -C boards/nexys2 clean
	$(MAKE) -C boards/mister clean
	@echo "Cleaned."

.PHONY: all
all: build ## Alias for build
