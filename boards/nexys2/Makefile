# Nexys 2 (Spartan-3E) experimental Yosys synthesis
# Produces EDIF for ISE 14.7. Full bitstream needs proprietary PnR.

TOP = blinky
SRC = ../../src/blinky.v
OUT = blinky-nexys2.edif

.PHONY: all clean

all: $(OUT)

$(OUT): $(SRC)
	yosys -p "read_verilog $(SRC); synth_xilinx -family xc3se -top $(TOP); write_edif $@"

clean:
	rm -f *.edif *.json
