# Kintex-7 (QMTech XC7K325T) — Yosys + openXC7
# Full .bit requires openXC7 (nextpnr-xilinx + prjxray)

TOP      = blinky
SRC      = ../../src/blinky.v
XDC      = ../../constraints/kintex7-qmtech.xdc
PART     = xc7k325tffg676-1
FAMILY   = kintex7
DBPART   = xc7k325tffg676

# Override if your openXC7 install lives elsewhere
NEXTPNR_XILINX_DIR ?= /opt/openxc7
CHIPDB             ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/himbaechel/xilinx/xc7k325t.bin
PRJXRAY_DB         ?= $(NEXTPNR_XILINX_DIR)/share/nextpnr/external/prjxray-db

.PHONY: all bit clean

all: blinky-kintex7-qmtech.json blinky-kintex7-qmtech.edif

blinky-kintex7-qmtech.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_json $@"

blinky-kintex7-qmtech.edif: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_edif $@"

# Full openXC7 bitstream
bit: blinky-kintex7-qmtech.bit

blinky-kintex7-qmtech.bit: blinky-kintex7-qmtech.json $(XDC)
	/opt/openxc7/bin/nextpnr-xilinx --help >/dev/null 2>&1 || command -v nextpnr-xilinx >/dev/null 2>&1 || { \
	  echo "nextpnr-xilinx not found. Install openXC7 and set NEXTPNR_XILINX_DIR."; \
	  echo "See https://github.com/openXC7/toolchain-installer"; \
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
