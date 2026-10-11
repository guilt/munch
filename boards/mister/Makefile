# SuperStation One / MiSTer (Cyclone V) open synthesis
# Yosys synth_intel_alm produces a VQM netlist that Quartus can place & route.
# Full .rbf requires Quartus (see CI or local Docker).

TOP = blinky
SRC = ../../src/blinky.v
OUT = blinky-superstation.vqm

.PHONY: all yosys clean

all: yosys

yosys: $(OUT)

$(OUT): $(SRC)
	yosys -p "read_verilog $(SRC); synth_intel_alm -family cyclonev -top $(TOP) -vqm $@"

clean:
	rm -f *.vqm *.json
