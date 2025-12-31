set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

create_clock -period 1.800 -name clk -waveform {0.000 0.900} [get_ports clk]

set_property PACKAGE_PIN U16 [get_ports rst]
set_property PACKAGE_PIN AA23 [get_ports clk]
