# Arty S7 (Spartan-7) — Yosys + optional openXC7
# Default (CI): Yosys synth → JSON + EDIF
# Full .bit:   make bit   (requires local openXC7: nextpnr-xilinx + prjxray)

TOP      = blinky
SRC      = ../../src/blinky.v
XDC      = ../../constraints/arty-s7.xdc
PART     = xc7s50csga324-1
FAMILY   = spartan7
DBPART   = xc7s50csga324

NEXTPNR_XILINX_DIR ?= /opt/openxc7
CHIPDB             ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/himbaechel/xilinx/chipdb-xc7s50.bin
PRJXRAY_DB         ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/external/prjxray-db

.PHONY: all bit clean

all: blinky-arty-s7.json blinky-arty-s7.edif

blinky-arty-s7.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_json $@"

blinky-arty-s7.edif: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_edif $@"

bit: blinky-arty-s7.bit

blinky-arty-s7.bit: blinky-arty-s7.json $(XDC)
	/opt/openxc7/bin/nextpnr-xilinx --help >/dev/null 2>&1 || command -v nextpnr-xilinx >/dev/null 2>&1 || { \
	  echo "nextpnr-xilinx not found. Install openXC7 and set NEXTPNR_XILINX_DIR."; \
	  echo "See https://github.com/openXC7/toolchain-installer"; \
	  exit 1; }
	$(or $(shell command -v nextpnr-xilinx),/opt/openxc7/bin/nextpnr-xilinx) --device $(PART) --chipdb $(CHIPDB) -o xdc=$(XDC) --json blinky-arty-s7.json -o fasm=blinky-arty-s7.fasm
	$(or $(shell command -v fasm2frames),/opt/openxc7/bin/fasm2frames) --part $(PART) --db-root $(PRJXRAY_DB)/$(FAMILY) blinky-arty-s7.fasm > blinky-arty-s7.frames
	$(or $(shell command -v xc7frames2bit),/opt/openxc7/bin/xc7frames2bit) --part_file $(PRJXRAY_DB)/$(FAMILY)/$(DBPART)/part.yaml \
	              --part_name $(PART) \
	              --frm_file blinky-arty-s7.frames \
	              --output_file $@
	@echo "Built $@"

clean:
	rm -f *.json *.edif *.fasm *.frames *.bit
