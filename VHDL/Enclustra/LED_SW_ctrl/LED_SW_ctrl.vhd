-- Project          : Example for PWM generation and LED control using a couple of switches 
--							 for Enclustra Mercury SA2 and Terasic F2G (FMC-to-GPIO) expansion board.
-- File description : Top Level
-- File name        : LED_SW_ctrl.vhd
---------------------------------------------------------------------------------------------------
-- Tekniker 2021. Author: Jose Angel Gumiel
---------------------------------------------------------------------------------------------------
-- Description:
-- This example uses the switches placed on the Terasic F2G expansion board to change the
-- status of the user LEDs placed on the Enclustra Mercury SA2 module. At the same time, it
-- generates a clock signal which is configured as an output through the GPIOs.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
---------------------------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------------------------

entity LED_SW_ctrl is
	port (
		
		-------------------------------------------------------------------------------------------
		-- bank 8A
		-------------------------------------------------------------------------------------------		
		IO_B8A_TX_T20_D6_P         : out std_logic;	--LA26_P
		LED0_N_PL						: out std_logic;
		LED1_N_PL						: out std_logic;
		LED2_N_PL						: out std_logic;
		LED3_N_PL						: out std_logic;
		
		
		-------------------------------------------------------------------------------------------
		-- Terasic F2G
		-------------------------------------------------------------------------------------------		
		SW									: in	std_logic_vector(1 downto 0);
		
		-------------------------------------------------------------------------------------------
		-- HPS
		-------------------------------------------------------------------------------------------
		
		hps_io_hps_io_uart0_inst_RX		: in	std_logic;
		hps_io_hps_io_uart0_inst_TX		: out	std_logic;
		hps_io_hps_io_uart1_inst_RX		: in	std_logic;
		hps_io_hps_io_uart1_inst_TX		: out	std_logic;
		memory_mem_a							: out	std_logic_vector(15	downto	0);
		memory_mem_ba							: out	std_logic_vector(2	downto	0);
		memory_mem_ck							: out	std_logic;
		memory_mem_ck_n						: out	std_logic;
		memory_mem_cke							: out	std_logic;
		memory_mem_cs_n						: out	std_logic;
		memory_mem_ras_n						: out	std_logic;
		memory_mem_cas_n						: out	std_logic;
		memory_mem_we_n						: out	std_logic;
		memory_mem_reset_n					: out	std_logic;
		memory_mem_dq							: inout	std_logic_vector(31	downto	0);
		memory_mem_dqs							: inout	std_logic_vector(3	downto	0);
		memory_mem_dqs_n						: inout	std_logic_vector(3	downto	0);
		memory_mem_odt							: out	std_logic;						
		memory_mem_dm							: out	std_logic_vector(3 downto 0);
		memory_oct_rzqin						: in	std_logic					
	);	
end;
---------------------------------------------------------------------------------------------------
-- architecture declaration
---------------------------------------------------------------------------------------------------

architecture a of LED_SW_ctrl is

	-----------------------------------------------------------------------------------------------
	-- component declarations
	-----------------------------------------------------------------------------------------------

component system is
		port (
			clk_50_clk                      : out   std_logic;
			cold_reset_reset_n              : out   std_logic;
			hps_io_hps_io_uart0_inst_RX     : in    std_logic := 'X';
			hps_io_hps_io_uart0_inst_TX     : out   std_logic;
			hps_io_hps_io_uart1_inst_RX     : in    std_logic := 'X';
			hps_io_hps_io_uart1_inst_TX     : out   std_logic;
			memory_mem_a                    : out   std_logic_vector(15 downto 0);
			memory_mem_ba                   : out   std_logic_vector(2 downto 0);
			memory_mem_ck                   : out   std_logic;
			memory_mem_ck_n                 : out   std_logic;
			memory_mem_cke                  : out   std_logic;
			memory_mem_cs_n                 : out   std_logic;
			memory_mem_ras_n                : out   std_logic;
			memory_mem_cas_n                : out   std_logic;
			memory_mem_we_n                 : out   std_logic;
			memory_mem_reset_n              : out   std_logic;
			memory_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X');
			memory_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X');
			memory_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X');
			memory_mem_odt                  : out   std_logic;
			memory_mem_dm                   : out   std_logic_vector(3 downto 0);
			memory_oct_rzqin                : in    std_logic := 'X'
		);
	end component system;


	-----------------------------------------------------------------------------------------------
	-- signals
	-----------------------------------------------------------------------------------------------

	signal Rst_Async						: std_logic;
	signal Rst								: std_logic;
	signal RstChain						: std_logic_vector (7 downto 0) := (others => '0');
	signal LedCount						: std_logic_vector (24 downto 0);
	signal cold_reset_n					: std_logic;
	signal clk50							: std_logic;
	signal userSelection					: std_logic_vector (1 downto 0);

begin

	-----------------------------------------------------------------------------------------------
	-- soc system
	-----------------------------------------------------------------------------------------------

	i_soc_system: system
		port map(
			clk_50_clk                      => clk50,
			cold_reset_reset_n              => cold_reset_n,
			hps_io_hps_io_uart0_inst_RX     => hps_io_hps_io_uart0_inst_RX,
			hps_io_hps_io_uart0_inst_TX     => hps_io_hps_io_uart0_inst_TX,
			hps_io_hps_io_uart1_inst_RX     => hps_io_hps_io_uart1_inst_RX,
			hps_io_hps_io_uart1_inst_TX     => hps_io_hps_io_uart1_inst_TX,
			memory_mem_a                    => memory_mem_a,
			memory_mem_ba                   => memory_mem_ba,
			memory_mem_ck                   => memory_mem_ck,
			memory_mem_ck_n                 => memory_mem_ck_n,
			memory_mem_cke                  => memory_mem_cke,
			memory_mem_cs_n                 => memory_mem_cs_n,
			memory_mem_ras_n                => memory_mem_ras_n,
			memory_mem_cas_n                => memory_mem_cas_n,
			memory_mem_we_n                 => memory_mem_we_n,
			memory_mem_reset_n              => memory_mem_reset_n,
			memory_mem_dq                   => memory_mem_dq,
			memory_mem_dqs                  => memory_mem_dqs,
			memory_mem_dqs_n                => memory_mem_dqs_n,
			memory_mem_odt                  => memory_mem_odt,
			memory_mem_dm                   => memory_mem_dm,
			memory_oct_rzqin                => memory_oct_rzqin
	);

	-----------------------------------------------------------------------------------------------
	-- reset
	-----------------------------------------------------------------------------------------------
	
	-- asynchronous reset
	Rst_Async <= not cold_reset_n;
		
	-- synchronous reset
	process (clk50, Rst_Async)
	begin
		if Rst_Async = '1' then
			RstChain <= (others => '0');
		elsif rising_edge (clk50) then
			RstChain <= '1' & RstChain (RstChain'left downto 1);
		end if;
	end process;
	Rst <= not RstChain (0);

	-----------------------------------------------------------------------------------------------
	--	blinking led counter & LED assignment
	-----------------------------------------------------------------------------------------------
	
	process (clk50)
	begin
		if rising_edge (clk50) then
			if Rst = '1' then
				LedCount <= (others => '0');
			else
				LedCount <= std_logic_vector (unsigned (LedCount) + 1);
			end if;
		end if;
	end process;

	-- use open drain style driver because the LEDs are connected to HPS pins in parallel
	userSelection <= SW;
	LED0_N_PL <= '0' when userSelection(1) = '1' else 'Z';
	LED1_N_PL <= '0' when userSelection(0) = '1' else 'Z';
	LED2_N_PL 	<= 'Z';
	LED3_N_PL 	<= '0' when LedCount(LedCount'high) = '1' else 'Z';
	
	--CLK goes to F2G GPIOs.
	IO_B8A_TX_T20_D6_P <= clk50;
	
	
	


end a;

---------------------------------------------------------------------------------------------------
-- eof
---------------------------------------------------------------------------------------------------