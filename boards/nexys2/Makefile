# Nexys 2 (Spartan-3E) experimental Yosys synthesis
# Produces JSON + EDIF for ISE 14.7. Full bitstream needs proprietary PnR.

TOP = blinky
SRC = ../../src/blinky.v

.PHONY: all clean

all: blinky-nexys2.json blinky-nexys2.edif

blinky-nexys2.json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc3se -top $(TOP); write_json $@"

blinky-nexys2.edif: $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc3se -top $(TOP); write_edif $@"

clean:
	rm -f *.edif *.json
