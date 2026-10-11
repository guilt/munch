# Experimental openXC7 / Yosys flow for Arty A7 (Artix-7)
# Pure Yosys synthesis to JSON (and EDIF for completeness).
# Full bitstream requires nextpnr-xilinx + prjxray chipdb (openXC7).

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
