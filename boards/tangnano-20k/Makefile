# Tang Nano 20K open flow (Yosys + nextpnr-himbaechel + Apicula)
# Requires: yosys, nextpnr-himbaechel, gowin_pack (OSS CAD Suite)

DEVICE   = GW2AR-LV18QN88C8/I7
FAMILY   = GW2A-18C
CST      = ../../constraints/tangnano-20k.cst
TOP      = blinky
SRC      = ../../src/blinky.v
OUT      = blinky-tangnano-20k.fs

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
