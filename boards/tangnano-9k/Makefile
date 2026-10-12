# Tang Nano 9K open flow (Yosys + nextpnr-himbaechel + Apicula)
# Requires: yosys, nextpnr-himbaechel, gowin_pack (OSS CAD Suite)

DEVICE   = GW1NR-LV9QN88PC6/I5
FAMILY   = GW1N-9C
CST      = ../../constraints/tangnano-9k.cst
TOP      = blinky
SRC      = ../../src/blinky.v
OUT      = blinky-tangnano-9k.fs

all: $(OUT)
bit: $(OUT)

blinky.json: $(SRC)
	yosys -p "read_verilog $<; synth_gowin -top $(TOP) -json $@"

blinky_pnr.json: blinky.json $(CST)
	nextpnr-himbaechel --json $< --write $@ \
		--device $(DEVICE) \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

$(OUT): blinky_pnr.json
	gowin_pack -d $(FAMILY) -o $@ $<

.PHONY: all bit clean
clean:
	rm -f *.json *.fs
