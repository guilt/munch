# Tang Nano 9K open flow (Yosys + nextpnr-himbaechel + Apicula)
# Requires: yosys, nextpnr-himbaechel, gowin_pack (from apicula / OSS CAD Suite)

DEVICE   = GW1NR-LV9QN88PC6/I5
FAMILY   = GW1N-9C
CST      = ../../constraints/tangnano9k.cst
TOP      = blinky
SRC      = ../../src/blinky.v

all: blinky.fs

blinky.json: $(SRC)
	yosys -p "read_verilog $<; synth_gowin -top $(TOP) -json $@"

blinky_pnr.json: blinky.json $(CST)
	nextpnr-himbaechel --json $< --write $@ \
		--device $(DEVICE) \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

blinky.fs: blinky_pnr.json
	gowin_pack -d $(FAMILY) -o $@ $<

.PHONY: all clean
clean:
	rm -f *.json *.fs
