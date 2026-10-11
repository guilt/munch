# MiSTer / SuperStation Cyclone V flow
# Expects Quartus (via Docker in CI) to be available as quartus_sh

.PHONY: all clean

all: output_files/blinky.sof

output_files/blinky.sof: ../../src/blinky.v ../../constraints/mister.qsf
	mkdir -p output_files
	# Copy or symlink constraints if needed; quartus_sh expects .qpf/.qsf in cwd or specified
	cp ../../constraints/mister.qsf blinky.qsf || true
	quartus_sh --flow compile blinky || echo "Quartus not available in this environment"

# Produce .rbf for MiSTer SD card if .sof exists
rbf: output_files/blinky.sof
	quartus_cpf -c output_files/blinky.sof blinky-superstation.rbf || true

clean:
	rm -rf output_files db incremental_db *.sof *.rbf *.rpt *.summary
