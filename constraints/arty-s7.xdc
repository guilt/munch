## Arty S7 (Spartan-7) minimal constraints for blinky
## Clock is typically 100 MHz from onboard oscillator; adjust if needed.
## LED0 on many Arty S7 boards is around E18 / F13 etc. Verify against schematic.

set_property PACKAGE_PIN E18 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

set_property PACKAGE_PIN R2 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 [get_ports clk]
