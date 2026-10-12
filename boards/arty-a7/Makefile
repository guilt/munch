# Experimental openXC7 / Yosys flow for Arty A7 (Artix-7)
# Pure Yosys synthesis to JSON (and EDIF for completeness).
# Default target is Yosys synth only (JSON + EDIF).
# Full .bit is NOT built here — OSS CAD Suite / CI do not include nextpnr-xilinx.
# For a full bitstream install openXC7 locally and run nextpnr-xilinx + Project X-Ray.

TOP = blinky
SRC = ../../src/blinky.v

.PHONY: all clean

all: blinky-arty-a7.json blinky-arty-a7.edif

blinky-arty-a7.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_json $@"

blinky-arty-a7.edif: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc7 -top $(TOP); write_edif $@"

clean:
	rm -f *.json *.edif *.fasm *.bit *.frames
