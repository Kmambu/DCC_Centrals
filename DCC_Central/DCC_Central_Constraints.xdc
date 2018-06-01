## This file is a general .xdc for the Nexys4 DDR Rev. C
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { Clk_100MHz }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
##create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {Clk_100MHz}];


##Switches

set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { Sw[0] }]; 
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { Sw[1] }]; 
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { Sw[2] }]; 
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { Sw[3] }]; 
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { Sw[4] }];
set_property -dict { PACKAGE_PIN T8   IOSTANDARD LVCMOS33 } [get_ports { Sw[5] }]; 
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { Sw[6] }]; 
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { Sw[7] }]; 
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { Sw[8] }];
set_property -dict { PACKAGE_PIN H6   IOSTANDARD LVCMOS33 } [get_ports { Sw[9] }]; 
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { Sw[10] }]; 
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { Sw[11] }];






set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { Reset }]; #IO_L24N_T3_RS0_15 Sch=sw[0]




##Buttons

set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { Button_C }]; #IO_L9P_T1_DQS_14 Sch=btnc
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { Button_L }]; #IO_L12P_T1_MRCC_14 Sch=btnl
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { Button_R }]; #IO_L10N_T1_D15_14 Sch=btnr


##GPIO
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { DCC_Out }];