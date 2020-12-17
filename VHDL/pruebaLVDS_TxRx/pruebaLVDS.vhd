--LVDS Signal transmission @64Mbps. 8Mhz clock frequency.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity pruebaLVDS is
	port(
		Clk50			: in  std_logic;
		inFrame		: in std_logic_vector (0 DOWNTO 0);
		rxClockIn	: in std_logic;
		LED			: out std_logic_vector(7 downto 0);
		outFrame		: out std_logic_vector(0 DOWNTO 0);
		txClockOut	: out std_logic
	);
end pruebaLVDS;


architecture a of pruebaLVDS is

	COMPONENT LVDS_TX IS
		PORT
		(
			--pll_areset	: IN  STD_LOGIC ;
			tx_in			: IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
			tx_inclock	: IN  STD_LOGIC ;
			tx_out		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
			tx_outclock	: OUT STD_LOGIC 
		);
	END COMPONENT;
	
	component LVDS_RX
		PORT
		(
			rx_in			: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
			rx_inclock	: IN STD_LOGIC ;
			rx_out		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			rx_outclock	: OUT STD_LOGIC 
		);
	end component;


	component PLL_IP is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk25
			outclk_1 : out std_logic;        -- clk100
			outclk_2 : out std_logic         -- clk12.5
		);
	end component PLL_IP;



	signal counter 	: std_logic_vector(25 downto 0):="00000000000000000000000000";
	signal msg			: std_logic_vector(7 downto 0);
	signal go			: std_logic;
	signal pll_clk25	: std_logic;
	signal buf_led 	: std_logic_vector(7 downto 0);
	signal pll_clk100	: std_logic;
	signal pll_clk12_5: std_logic;


BEGIN
	
	process(Clk50)
		constant var1	: std_logic_vector(7 downto 0):="10101010";
		constant var2	: std_logic_vector(7 downto 0):="11110000";
	begin

		if (rising_edge(Clk50)) then
			if (counter<"01011111010111100000111111")then --Cuento hasta la mitad.
				go<='0';
				msg<=var1;
				counter<=counter+'1';
			else
				go<='1';
				msg<=var2;
				counter<=counter+'1';
			end if;
			if(counter="10111110101111000001111111")then --Si llega a un 50M de ciclos, reseteo de nuevo la señal.
				counter<="00000000000000000000000000";
			end if;
		end if;
	end process;
		
	--LED<=msg;
	--GPIO3<=buf_led;
	--LED<=buf_led;
		
	
	LVDS_TX_inst : LVDS_TX PORT MAP (
		--pll_areset	=> '0',
		tx_in	 		=> msg,
		tx_inclock	=> pll_clk25,
		tx_out	 	=> outFrame,
		tx_outclock	=> txClockOut
	);
	
	
	PLL_IP_inst : PLL_IP PORT MAP (
		refclk   => Clk50,
		rst      => '0',
		outclk_0 => pll_clk25,
		outclk_1 => pll_clk100,
		outclk_2 => pll_clk12_5
	);
	
	
	LVDS_RX_inst : LVDS_RX PORT MAP (
		rx_in	 => inFrame,
		rx_inclock	 => rxClockIn,
		rx_out	 => LED,
		rx_outclock	 => open
	);


	
end a;