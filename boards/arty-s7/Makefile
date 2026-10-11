# Experimental openXC7 / Yosys flow for Arty S7 (Spartan-7)
# Full bitstream requires nextpnr-xilinx + prjxray chipdb (heavy).
# This Makefile does synthesis to JSON as a first artifact.

TOP = blinky
SRC = ../../src/blinky.v
XDC = ../../constraints/arty-s7.xdc

.PHONY: all clean

all: blinky-arty-s7.json

blinky-arty-s7.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_json $@"

clean:
	rm -f *.json *.fasm *.bit *.frames
