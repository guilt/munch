## YPCB-00338-1P1 Kintex-7 XC7K480T (FFG1156-2) minimal blinky constraints
## Adjust PACKAGE_PIN for your specific board revision / LED and clock.

set_property PACKAGE_PIN AA28 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
create_clock -period 20.000 [get_ports clk]

set_property PACKAGE_PIN P30 [get_ports led]
set_property IOSTANDARD LVCMOS18 [get_ports led]
