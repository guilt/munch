## Arty A7 (Artix-7) minimal constraints for blinky
## 100 MHz clock on E3, LED0 (LD4) on H5. Verify against your board revision.

set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

set_property PACKAGE_PIN H5 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
