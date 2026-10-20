# Kintex-7 (QMTech XC7K325T) — Yosys + openXC7
# Generates chipdb on first use if the prebuilt package does not include it.

TOP      = blinky
SRC      = ../../src/blinky.v
XDC      = ../../constraints/kintex7-qmtech.xdc
PART     = xc7k325tffg676-1
FAMILY   = kintex7
DBPART   = xc7k325tffg676

NEXTPNR_XILINX_DIR ?= /opt/openxc7
CHIPDB_DIR         ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/himbaechel/xilinx
CHIPDB             ?= $(CHIPDB_DIR)/xc7k325t.bin
PRJXRAY_DB         ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/external/prjxray-db

.PHONY: all bit clean

all: blinky-kintex7-qmtech.json blinky-kintex7-qmtech.edif

blinky-kintex7-qmtech.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_json $@"

blinky-kintex7-qmtech.edif: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_edif $@"

# Generate Kintex chipdb if the package did not ship it
$(CHIPDB):
	@mkdir -p $(CHIPDB_DIR)
	@echo "Generating chipdb for xc7k325t (first use)..."
	python3 $(NEXTPNR_XILINX_DIR)/share/nextpnr/himbaechel/uarch/xilinx/gen/xilinx_gen.py \
		--xray $(PRJXRAY_DB)/$(FAMILY) --device xc7k325t --bba /tmp/xc7k325t.bba
	$(NEXTPNR_XILINX_DIR)/bin/bbasm -l /tmp/xc7k325t.bba $(CHIPDB)
	@rm -f /tmp/xc7k325t.bba

# Full openXC7 bitstream
bit: blinky-kintex7-qmtech.bit

blinky-kintex7-qmtech.bit: blinky-kintex7-qmtech.json $(XDC) $(CHIPDB)
	/opt/openxc7/bin/nextpnr-xilinx --help >/dev/null 2>&1 || command -v nextpnr-xilinx >/dev/null 2>&1 || { \
	  echo "nextpnr-xilinx not found. Install openXC7 and set NEXTPNR_XILINX_DIR."; \
	  exit 1; }
	$(or $(shell command -v nextpnr-xilinx),/opt/openxc7/bin/nextpnr-xilinx) --device $(PART) --chipdb $(CHIPDB) -o xdc=$(XDC) --json blinky-kintex7-qmtech.json -o fasm=blinky-kintex7-qmtech.fasm
	$(or $(shell command -v fasm2frames),/opt/openxc7/bin/fasm2frames) --part $(PART) --db-root $(PRJXRAY_DB)/$(FAMILY) blinky-kintex7-qmtech.fasm > blinky-kintex7-qmtech.frames
	$(or $(shell command -v xc7frames2bit),/opt/openxc7/bin/xc7frames2bit) --part_file $(PRJXRAY_DB)/$(FAMILY)/$(PART)/part.yaml \
	              --part_name $(PART) \
	              --frm_file blinky-kintex7-qmtech.frames \
	              --output_file $@
	@echo "Built $@"

clean:
	rm -f *.json *.edif *.fasm *.frames *.bit
