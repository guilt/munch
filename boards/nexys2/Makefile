# Nexys 2 (Spartan-3E): Yosys synthesis + ISE 14.7 place & route
#   make          -> blinky-nexys2.json + .edif (open intermediates)
#   make bit      -> blinky-nexys2.bit (requires ISE 14.7 in /opt/Xilinx/14.7)

SHELL = /bin/bash

TOP  = blinky
SRC  = ../../src/blinky.v
PART = xc3s500e-4-fg320
UCF  = nexys2.ucf

ISE_DS ?= /opt/Xilinx/14.7/ISE_DS
ISE    := set -e; . $(ISE_DS)/settings64.sh >/dev/null 2>&1;

.PHONY: all bit clean check-yosys check-ise

all: blinky-nexys2.json blinky-nexys2.edif

check-yosys:
	@command -v yosys >/dev/null 2>&1 || { \
	  echo "ERROR: yosys not found"; \
	  echo "       Install Yosys/OSS CAD Suite or put it on PATH."; \
	  exit 1; }

blinky-nexys2.json: $(SRC) | check-yosys
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc3se -top $(TOP); write_json $@"

blinky-nexys2.edif: $(SRC) | check-yosys
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc3se -top $(TOP); write_edif $@"

bit: blinky-nexys2.bit

check-ise:
	@test -f $(ISE_DS)/settings64.sh || { \
	  echo "ERROR: ISE 14.7 not found at $(ISE_DS)"; \
	  echo "       Set ISE_DS=/path/to/ISE_DS or install ISE 14.7."; \
	  exit 1; }

blinky-nexys2.ngd: blinky-nexys2.edif $(UCF) | check-ise
	@$(ISE) ngdbuild -p $(PART) -uc $(UCF) -intstyle silent $< $@

blinky-nexys2_map.ncd: blinky-nexys2.ngd
	@$(ISE) map -p $(PART) -intstyle silent -o $@ $< blinky-nexys2.pcf

blinky-nexys2.ncd: blinky-nexys2_map.ncd
	@$(ISE) par -w -intstyle silent $< $@ blinky-nexys2.pcf

blinky-nexys2.bit: blinky-nexys2.ncd
	@$(ISE) bitgen -w -intstyle silent $< $@
	@echo "Built $@"

clean:
	rm -f *.json *.edif *.bit *.ngd *.ngo *.ncd *_map.ncd *.pcf \
	      *.bld *.bgn *.drc *.par *.pad *.ptwx *.unroutes *.xpi *.log
	rm -rf _xmsgs xlnx_auto_0_xdb
