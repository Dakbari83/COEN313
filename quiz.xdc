# clock from  a regular switch on board
# set this property to FALSE to allow use of non-dedicated routing resources
# to route clock IBUF when using  a regular switch input (for manual single-step
# clocking of the FPGA board in a lab setting, if not set to FALSE, placement ERRORS
# occur during the execution of the TCL synthesis script.

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]

# we use a regular switch on the board as the clock input , useful for
# manual clocking in single-step board for testing of the downloaded design
# in a lab environment

set_property -dict { PACKAGE_PIN V10    IOSTANDARD LVCMOS33 } [get_ports { clk }];



set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 }   [ get_ports { reset }    ] ;
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 }   [ get_ports { extend }    ] ;


set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 }   [ get_ports { din[3] }    ] ;
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 }   [ get_ports { din[2] }    ] ;
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 }   [ get_ports { din[1] }    ] ;
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 }   [ get_ports { din[0] }    ] ;




set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 }   [ get_ports { regout[3] }    ] ;
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 }   [ get_ports { regout[2] }    ] ;
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 }   [ get_ports { regout[1] }    ] ;
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 }   [ get_ports { regout[0] }    ] ;

set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 }   [ get_ports { regout[7] }    ] ;
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 }   [ get_ports { regout[6] }    ] ;
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 }   [ get_ports { regout[5] }    ] ;
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 }   [ get_ports { regout[4] }    ] ;









