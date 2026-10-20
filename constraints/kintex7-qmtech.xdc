## QMTech Kintex-7 XC7K325T minimal constraints for blinky
## Adjust PACKAGE_PIN for your specific board revision / LED and clock.
## Common: 50 MHz or 100 MHz clock, one LED.

set_property PACKAGE_PIN AB11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 20.000 [get_ports clk]

set_property PACKAGE_PIN AA2 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
