# MiSTer / SuperStation Cyclone V flow
# Pure Yosys experimental path (synth_intel_alm) produces VQM for later Quartus use.
# Full .sof/.rbf still needs Quartus (see CI Docker job).

.PHONY: all yosys clean

all: yosys

yosys: blinky-mister.vqm

blinky-mister.vqm: ../../src/blinky.v
	yosys -p "read_verilog ../../src/blinky.v; synth_intel_alm -family cyclonev -top blinky -vqm $@"

clean:
	rm -f *.vqm *.json
