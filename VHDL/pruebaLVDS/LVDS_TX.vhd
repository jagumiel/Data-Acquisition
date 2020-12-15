-- megafunction wizard: %ALTLVDS_TX%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: ALTLVDS_TX 

-- ============================================================
-- File Name: LVDS_TX.vhd
-- Megafunction Name(s):
-- 			ALTLVDS_TX
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 18.1.0 Build 625 09/12/2018 SJ Lite Edition
-- ************************************************************


--Copyright (C) 2018  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY LVDS_TX IS
	PORT
	(
		pll_areset		: IN STD_LOGIC ;
		tx_in		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		tx_inclock		: IN STD_LOGIC ;
		tx_out		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
		tx_outclock		: OUT STD_LOGIC 
	);
END LVDS_TX;


ARCHITECTURE SYN OF lvds_tx IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (0 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC ;



	COMPONENT altlvds_tx
	GENERIC (
		center_align_msb		: STRING;
		common_rx_tx_pll		: STRING;
		coreclock_divide_by		: NATURAL;
		data_rate		: STRING;
		deserialization_factor		: NATURAL;
		differential_drive		: NATURAL;
		enable_clock_pin_mode		: STRING;
		implement_in_les		: STRING;
		inclock_boost		: NATURAL;
		inclock_data_alignment		: STRING;
		inclock_period		: NATURAL;
		inclock_phase_shift		: NATURAL;
		intended_device_family		: STRING;
		lpm_hint		: STRING;
		lpm_type		: STRING;
		multi_clock		: STRING;
		number_of_channels		: NATURAL;
		outclock_alignment		: STRING;
		outclock_divide_by		: NATURAL;
		outclock_duty_cycle		: NATURAL;
		outclock_multiply_by		: NATURAL;
		outclock_phase_shift		: NATURAL;
		outclock_resource		: STRING;
		output_data_rate		: NATURAL;
		pll_compensation_mode		: STRING;
		pll_self_reset_on_loss_lock		: STRING;
		preemphasis_setting		: NATURAL;
		refclk_frequency		: STRING;
		registered_input		: STRING;
		use_external_pll		: STRING;
		use_no_phase_shift		: STRING;
		vod_setting		: NATURAL;
		clk_src_is_pll		: STRING
	);
	PORT (
			pll_areset	: IN STD_LOGIC ;
			tx_in	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			tx_inclock	: IN STD_LOGIC ;
			tx_out	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
			tx_outclock	: OUT STD_LOGIC 
	);
	END COMPONENT;

BEGIN
	tx_out    <= sub_wire0(0 DOWNTO 0);
	tx_outclock    <= sub_wire1;

	ALTLVDS_TX_component : ALTLVDS_TX
	GENERIC MAP (
		center_align_msb => "UNUSED",
		common_rx_tx_pll => "OFF",
		coreclock_divide_by => 1,
		data_rate => "64.0 Mbps",
		deserialization_factor => 8,
		differential_drive => 0,
		enable_clock_pin_mode => "UNUSED",
		implement_in_les => "OFF",
		inclock_boost => 0,
		inclock_data_alignment => "EDGE_ALIGNED",
		inclock_period => 125000,
		inclock_phase_shift => 0,
		intended_device_family => "Cyclone V",
		lpm_hint => "CBX_MODULE_PREFIX=LVDS_TX",
		lpm_type => "altlvds_tx",
		multi_clock => "OFF",
		number_of_channels => 1,
		outclock_alignment => "EDGE_ALIGNED",
		outclock_divide_by => 8,
		outclock_duty_cycle => 50,
		outclock_multiply_by => 1,
		outclock_phase_shift => 0,
		outclock_resource => "Dual-Regional clock",
		output_data_rate => 64,
		pll_compensation_mode => "AUTO",
		pll_self_reset_on_loss_lock => "OFF",
		preemphasis_setting => 0,
		refclk_frequency => "8.000000 MHz",
		registered_input => "TX_CORECLK",
		use_external_pll => "OFF",
		use_no_phase_shift => "ON",
		vod_setting => 0,
		clk_src_is_pll => "off"
	)
	PORT MAP (
		pll_areset => pll_areset,
		tx_in => tx_in,
		tx_inclock => tx_inclock,
		tx_out => sub_wire0,
		tx_outclock => sub_wire1
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: PRIVATE: CNX_CLOCK_CHOICES STRING "tx_coreclock"
-- Retrieval info: PRIVATE: CNX_CLOCK_MODE NUMERIC "0"
-- Retrieval info: PRIVATE: CNX_COMMON_PLL NUMERIC "0"
-- Retrieval info: PRIVATE: CNX_DATA_RATE STRING "64.0"
-- Retrieval info: PRIVATE: CNX_DESER_FACTOR NUMERIC "8"
-- Retrieval info: PRIVATE: CNX_EXT_PLL STRING "OFF"
-- Retrieval info: PRIVATE: CNX_LE_SERDES STRING "OFF"
-- Retrieval info: PRIVATE: CNX_NUM_CHANNEL NUMERIC "1"
-- Retrieval info: PRIVATE: CNX_OUTCLOCK_DIVIDE_BY NUMERIC "8"
-- Retrieval info: PRIVATE: CNX_PLL_ARESET NUMERIC "1"
-- Retrieval info: PRIVATE: CNX_PLL_FREQ STRING "8.000000"
-- Retrieval info: PRIVATE: CNX_PLL_PERIOD STRING "125.000"
-- Retrieval info: PRIVATE: CNX_REG_INOUT NUMERIC "1"
-- Retrieval info: PRIVATE: CNX_TX_CORECLOCK STRING "OFF"
-- Retrieval info: PRIVATE: CNX_TX_LOCKED STRING "OFF"
-- Retrieval info: PRIVATE: CNX_TX_OUTCLOCK STRING "ON"
-- Retrieval info: PRIVATE: CNX_USE_CLOCK_RESC STRING "Dual-Regional clock"
-- Retrieval info: PRIVATE: CNX_USE_PLL_ENABLE NUMERIC "0"
-- Retrieval info: PRIVATE: CNX_USE_TX_OUT_PHASE NUMERIC "1"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: PRIVATE: pCNX_OUTCLK_ALIGN STRING "UNUSED"
-- Retrieval info: PRIVATE: pINCLOCK_PHASE_SHIFT STRING "0.00"
-- Retrieval info: PRIVATE: pOUTCLOCK_PHASE_SHIFT STRING "0.00"
-- Retrieval info: CONSTANT: CENTER_ALIGN_MSB STRING "UNUSED"
-- Retrieval info: CONSTANT: COMMON_RX_TX_PLL STRING "OFF"
-- Retrieval info: CONSTANT: CORECLOCK_DIVIDE_BY NUMERIC "1"
-- Retrieval info: CONSTANT: clk_src_is_pll STRING "off"
-- Retrieval info: CONSTANT: DATA_RATE STRING "64.0 Mbps"
-- Retrieval info: CONSTANT: DESERIALIZATION_FACTOR NUMERIC "8"
-- Retrieval info: CONSTANT: DIFFERENTIAL_DRIVE NUMERIC "0"
-- Retrieval info: CONSTANT: ENABLE_CLOCK_PIN_MODE STRING "UNUSED"
-- Retrieval info: CONSTANT: IMPLEMENT_IN_LES STRING "OFF"
-- Retrieval info: CONSTANT: INCLOCK_BOOST NUMERIC "0"
-- Retrieval info: CONSTANT: INCLOCK_DATA_ALIGNMENT STRING "EDGE_ALIGNED"
-- Retrieval info: CONSTANT: INCLOCK_PERIOD NUMERIC "125000"
-- Retrieval info: CONSTANT: INCLOCK_PHASE_SHIFT NUMERIC "0"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
-- Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altlvds_tx"
-- Retrieval info: CONSTANT: MULTI_CLOCK STRING "OFF"
-- Retrieval info: CONSTANT: NUMBER_OF_CHANNELS NUMERIC "1"
-- Retrieval info: CONSTANT: OUTCLOCK_ALIGNMENT STRING "EDGE_ALIGNED"
-- Retrieval info: CONSTANT: OUTCLOCK_DIVIDE_BY NUMERIC "8"
-- Retrieval info: CONSTANT: OUTCLOCK_DUTY_CYCLE NUMERIC "50"
-- Retrieval info: CONSTANT: OUTCLOCK_MULTIPLY_BY NUMERIC "1"
-- Retrieval info: CONSTANT: OUTCLOCK_PHASE_SHIFT NUMERIC "0"
-- Retrieval info: CONSTANT: OUTCLOCK_RESOURCE STRING "Dual-Regional clock"
-- Retrieval info: CONSTANT: OUTPUT_DATA_RATE NUMERIC "64"
-- Retrieval info: CONSTANT: PLL_COMPENSATION_MODE STRING "AUTO"
-- Retrieval info: CONSTANT: PLL_SELF_RESET_ON_LOSS_LOCK STRING "OFF"
-- Retrieval info: CONSTANT: PREEMPHASIS_SETTING NUMERIC "0"
-- Retrieval info: CONSTANT: REFCLK_FREQUENCY STRING "8.000000 MHz"
-- Retrieval info: CONSTANT: REGISTERED_INPUT STRING "TX_CORECLK"
-- Retrieval info: CONSTANT: USE_EXTERNAL_PLL STRING "OFF"
-- Retrieval info: CONSTANT: USE_NO_PHASE_SHIFT STRING "ON"
-- Retrieval info: CONSTANT: VOD_SETTING NUMERIC "0"
-- Retrieval info: USED_PORT: pll_areset 0 0 0 0 INPUT NODEFVAL "pll_areset"
-- Retrieval info: CONNECT: @pll_areset 0 0 0 0 pll_areset 0 0 0 0
-- Retrieval info: USED_PORT: tx_in 0 0 8 0 INPUT NODEFVAL "tx_in[7..0]"
-- Retrieval info: CONNECT: @tx_in 0 0 8 0 tx_in 0 0 8 0
-- Retrieval info: USED_PORT: tx_inclock 0 0 0 0 INPUT NODEFVAL "tx_inclock"
-- Retrieval info: CONNECT: @tx_inclock 0 0 0 0 tx_inclock 0 0 0 0
-- Retrieval info: USED_PORT: tx_out 0 0 1 0 OUTPUT NODEFVAL "tx_out[0..0]"
-- Retrieval info: CONNECT: tx_out 0 0 1 0 @tx_out 0 0 1 0
-- Retrieval info: USED_PORT: tx_outclock 0 0 0 0 OUTPUT NODEFVAL "tx_outclock"
-- Retrieval info: CONNECT: tx_outclock 0 0 0 0 @tx_outclock 0 0 0 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.vhd TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.qip TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.bsf TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX_inst.vhd TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.inc TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.cmp TRUE TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL LVDS_TX.ppf TRUE FALSE
-- Retrieval info: LIB_FILE: altera_mf
-- Retrieval info: CBX_MODULE_PREFIX: ON
