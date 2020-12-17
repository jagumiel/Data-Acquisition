//altlvds_tx CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" COMMON_RX_TX_PLL="OFF" CORECLOCK_DIVIDE_BY=1 DATA_RATE="64.0 Mbps" DESERIALIZATION_FACTOR=8 DEVICE_FAMILY="Cyclone V" DIFFERENTIAL_DRIVE=0 ENABLE_CLK_LATENCY="OFF" IMPLEMENT_IN_LES="OFF" INCLOCK_BOOST=0 INCLOCK_DATA_ALIGNMENT="EDGE_ALIGNED" INCLOCK_PERIOD=125000 INCLOCK_PHASE_SHIFT=0 MULTI_CLOCK="OFF" NUMBER_OF_CHANNELS=1 OUTCLOCK_ALIGNMENT="EDGE_ALIGNED" OUTCLOCK_DIVIDE_BY=8 OUTCLOCK_DUTY_CYCLE=50 OUTCLOCK_MULTIPLY_BY=1 OUTCLOCK_PHASE_SHIFT=0 OUTCLOCK_RESOURCE="Dual-Regional Clock" OUTPUT_DATA_RATE=64 PLL_COMPENSATION_MODE="AUTO" PLL_SELF_RESET_ON_LOSS_LOCK="OFF" PREEMPHASIS_SETTING=0 REFCLK_FREQUENCY="8.000000 MHz" REGISTERED_INPUT="TX_CORECLK" USE_EXTERNAL_PLL="OFF" USE_NO_PHASE_SHIFT="ON" VOD_SETTING=0 pll_areset tx_in tx_inclock tx_out tx_outclock CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48
//VERSION_BEGIN 18.1 cbx_altaccumulate 2018:09:12:13:04:24:SJ cbx_altclkbuf 2018:09:12:13:04:24:SJ cbx_altddio_in 2018:09:12:13:04:24:SJ cbx_altddio_out 2018:09:12:13:04:24:SJ cbx_altera_syncram_nd_impl 2018:09:12:13:04:24:SJ cbx_altiobuf_bidir 2018:09:12:13:04:24:SJ cbx_altiobuf_in 2018:09:12:13:04:24:SJ cbx_altiobuf_out 2018:09:12:13:04:24:SJ cbx_altlvds_tx 2018:09:12:13:04:24:SJ cbx_altpll 2018:09:12:13:04:24:SJ cbx_altsyncram 2018:09:12:13:04:24:SJ cbx_arriav 2018:09:12:13:04:23:SJ cbx_cyclone 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_counter 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_lpm_mux 2018:09:12:13:04:24:SJ cbx_lpm_shiftreg 2018:09:12:13:04:24:SJ cbx_maxii 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ cbx_util_mgl 2018:09:12:13:04:24:SJ  VERSION_END
//CBXI_INSTANCE_NAME="pruebaLVDS_LVDS_TX_LVDS_TX_inst_altlvds_tx_ALTLVDS_TX_component"
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2018  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.




//altclkctrl CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" CLOCK_TYPE="Dual-Regional Clock" DEVICE_FAMILY="Cyclone V" inclk outclk
//VERSION_BEGIN 18.1 cbx_altclkbuf 2018:09:12:13:04:24:SJ cbx_cycloneii 2018:09:12:13:04:24:SJ cbx_lpm_add_sub 2018:09:12:13:04:24:SJ cbx_lpm_compare 2018:09:12:13:04:24:SJ cbx_lpm_decode 2018:09:12:13:04:24:SJ cbx_lpm_mux 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_nadder 2018:09:12:13:04:24:SJ cbx_stratix 2018:09:12:13:04:24:SJ cbx_stratixii 2018:09:12:13:04:24:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ  VERSION_END

//synthesis_resources = cyclonev_clkena 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  LVDS_TX_altclkctrl
	( 
	inclk,
	outclk) /* synthesis synthesis_clearbox=1 */;
	input   [3:0]  inclk;
	output   outclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [3:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_sd4_outclk;
	wire [1:0]  clkselect;
	wire ena;

	cyclonev_clkena   sd4
	( 
	.ena(ena),
	.enaout(),
	.inclk(inclk[0]),
	.outclk(wire_sd4_outclk));
	defparam
		sd4.clock_type = "Dual-Regional Clock",
		sd4.ena_register_mode = "always enabled",
		sd4.lpm_type = "cyclonev_clkena";
	assign
		clkselect = {2{1'b0}},
		ena = 1'b1,
		outclk = wire_sd4_outclk;
endmodule //LVDS_TX_altclkctrl

//synthesis_resources = cyclonev_clkena 1 cyclonev_ir_fifo_userdes 2 generic_pll 3 reg 8 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"{-to pll_fclk} PLL_COMPENSATION_MODE=LVDS;-name MULTICYCLE 7 -from txreg* -to lvds_tx_fifo*;-name MULTICYCLE_HOLD 8 -from txreg* -to lvds_tx_fifo*"} *)
module  LVDS_TX_lvds_tx
	( 
	pll_areset,
	tx_in,
	tx_inclock,
	tx_out,
	tx_outclock) /* synthesis synthesis_clearbox=1 */;
	input   pll_areset;
	input   [7:0]  tx_in;
	input   tx_inclock;
	output   [0:0]  tx_out;
	output   tx_outclock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   pll_areset;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_coreclk_buf_outclk;
	wire  wire_lvds_outclk_tx_serialiser_txout;
	wire  wire_sd1_txout;
	(* ALTERA_ATTRIBUTE = {"PRESERVE_REGISTER=ON"} *)
	reg	[7:0]	txreg;
	wire  wire_pll_ena_outclk;
	wire  wire_pll_fclk_fboutclk;
	wire  wire_pll_fclk_outclk;
	wire  wire_pll_sclk_outclk;

	LVDS_TX_altclkctrl   coreclk_buf
	( 
	.inclk({{3{1'b0}}, wire_pll_sclk_outclk}),
	.outclk(wire_coreclk_buf_outclk));
	cyclonev_ir_fifo_userdes   lvds_outclk_tx_serialiser
	( 
	.bslipmax(),
	.bslipout(),
	.dout(),
	.loaden(wire_pll_ena_outclk),
	.lvdsmodeen(),
	.lvdstxsel(),
	.rstn(pll_areset),
	.rxout(),
	.scanout(),
	.txin(10'b0011110000),
	.txout(wire_lvds_outclk_tx_serialiser_txout),
	.writeclk(wire_pll_fclk_outclk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bslipctl(1'b0),
	.bslipin(1'b0),
	.dinfiforx({2{1'b0}}),
	.dynfifomode({3{1'b0}}),
	.readclk(1'b0),
	.readenable(1'b0),
	.regscan(1'b0),
	.regscanovrd(1'b0),
	.scanin(1'b0),
	.tstclk(1'b0),
	.writeenable(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.observablefout1(),
	.observablefout2(),
	.observablefout3(),
	.observablefout4(),
	.observableout(),
	.observablewaddrcnt()
	// synopsys translate_on
	);
	defparam
		lvds_outclk_tx_serialiser.a_rb_bypass_serializer = "false",
		lvds_outclk_tx_serialiser.a_rb_data_width = 8,
		lvds_outclk_tx_serialiser.a_rb_fifo_mode = "serializer_mode",
		lvds_outclk_tx_serialiser.a_rb_tx_outclk = "true",
		lvds_outclk_tx_serialiser.lpm_type = "cyclonev_ir_fifo_userdes";
	cyclonev_ir_fifo_userdes   sd1
	( 
	.bslipmax(),
	.bslipout(),
	.dout(),
	.loaden(wire_pll_ena_outclk),
	.lvdsmodeen(),
	.lvdstxsel(),
	.rstn(pll_areset),
	.rxout(),
	.scanout(),
	.txin({{2{1'b0}}, txreg[7:0]}),
	.txout(wire_sd1_txout),
	.writeclk(wire_pll_fclk_outclk)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.bslipctl(1'b0),
	.bslipin(1'b0),
	.dinfiforx({2{1'b0}}),
	.dynfifomode({3{1'b0}}),
	.readclk(1'b0),
	.readenable(1'b0),
	.regscan(1'b0),
	.regscanovrd(1'b0),
	.scanin(1'b0),
	.tstclk(1'b0),
	.writeenable(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.observablefout1(),
	.observablefout2(),
	.observablefout3(),
	.observablefout4(),
	.observableout(),
	.observablewaddrcnt()
	// synopsys translate_on
	);
	defparam
		sd1.a_rb_data_width = 8,
		sd1.a_rb_fifo_mode = "serializer_mode",
		sd1.lpm_type = "cyclonev_ir_fifo_userdes";
	// synopsys translate_off
	initial
		txreg = 0;
	// synopsys translate_on
	always @ ( posedge wire_coreclk_buf_outclk)
		  txreg <= tx_in;
	generic_pll   pll_ena
	( 
	.fbclk(wire_pll_fclk_fboutclk),
	.fboutclk(),
	.locked(),
	.outclk(wire_pll_ena_outclk),
	.refclk(tx_inclock),
	.rst(pll_areset));
	defparam
		pll_ena.duty_cycle = 13,
		pll_ena.output_clock_frequency = "8.000000 MHz",
		pll_ena.phase_shift = "93750 ps",
		pll_ena.reference_clock_frequency = "8.000000 MHz",
		pll_ena.lpm_type = "generic_pll";
	generic_pll   pll_fclk
	( 
	.fbclk(wire_pll_fclk_fboutclk),
	.fboutclk(wire_pll_fclk_fboutclk),
	.locked(),
	.outclk(wire_pll_fclk_outclk),
	.refclk(tx_inclock),
	.rst(pll_areset));
	defparam
		pll_fclk.output_clock_frequency = "64.000000 MHz",
		pll_fclk.phase_shift = "7813 ps",
		pll_fclk.reference_clock_frequency = "8.000000 MHz",
		pll_fclk.lpm_type = "generic_pll";
	generic_pll   pll_sclk
	( 
	.fbclk(wire_pll_fclk_fboutclk),
	.fboutclk(),
	.locked(),
	.outclk(wire_pll_sclk_outclk),
	.refclk(tx_inclock),
	.rst(pll_areset));
	defparam
		pll_sclk.output_clock_frequency = "8.000000 MHz",
		pll_sclk.phase_shift = "117188 ps",
		pll_sclk.reference_clock_frequency = "8.000000 MHz",
		pll_sclk.lpm_type = "generic_pll";
	assign
		tx_out = {wire_sd1_txout},
		tx_outclock = wire_lvds_outclk_tx_serialiser_txout;
endmodule //LVDS_TX_lvds_tx
//VALID FILE
