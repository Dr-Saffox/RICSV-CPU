set_property PACKAGE_PIN Y9 [get_ports {CLK}]; # "GCLK"
create_clock -period 10 -name clk -waveform {0.000 5.000} [get_ports CLK]
set_property PACKAGE_PIN P16 [get_ports {RST}]; # "BTNC"
set_property PACKAGE_PIN T22 [get_ports {led[0]}]; # "LD0"
set_property PACKAGE_PIN T21 [get_ports {led[1]}]; # "LD1"
set_property PACKAGE_PIN U22 [get_ports {led[2]}]; # "LD2"
set_property PACKAGE_PIN U21 [get_ports {led[3]}]; # "LD3"
set_property PACKAGE_PIN V22 [get_ports {led[4]}]; # "LD4"
set_property PACKAGE_PIN W22 [get_ports {led[5]}]; # "LD5"
set_property PACKAGE_PIN U19 [get_ports {led[6]}]; # "LD6"
set_property PACKAGE_PIN U14 [get_ports {led[7]}]; # "LD7"

set_property PACKAGE_PIN F22 [get_ports {switch[0]}]; # "SW0"
set_property PACKAGE_PIN G22 [get_ports {switch[1]}]; # "SW1"
set_property PACKAGE_PIN H22 [get_ports {switch[2]}]; # "SW2"
set_property PACKAGE_PIN F21 [get_ports {switch[3]}]; # "SW3"
set_property PACKAGE_PIN H19 [get_ports {switch[4]}]; # "SW4"
set_property PACKAGE_PIN H18 [get_ports {switch[5]}]; # "SW5"
set_property PACKAGE_PIN H17 [get_ports {switch[6]}]; # "SW6"
set_property PACKAGE_PIN M15 [get_ports {switch[7]}]; # "SW7"
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];