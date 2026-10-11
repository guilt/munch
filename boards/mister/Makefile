# SuperStation One / MiSTer (Cyclone V) open synthesis
# Yosys synth_intel_alm produces a netlist. write_verilog emits a VQM-style file
# that Quartus can consume. Full .rbf still needs Quartus.

TOP = blinky
SRC = ../../src/blinky.v
OUT = blinky-superstation.vqm

.PHONY: all yosys clean

all: yosys

yosys: $(OUT)

$(OUT): $(SRC)
	yosys -p "read_verilog $(SRC); synth_intel_alm -family cyclonev -top $(TOP); write_verilog -attr2comment -nohex -decimal $@"

clean:
	rm -f *.vqm *.json
