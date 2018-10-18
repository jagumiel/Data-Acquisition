--***Este programa captura el valor de una señal analógica y lo representa en digital a través de los leds.
--En este caso se está utilizando el conversor analogico-digital integrado en la placa.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity pruebaOnBoardADC is
	 port(		
			FPGA_CLK1_50	: in  std_logic; 
			KEY 				: in  std_logic_vector(0 downto 0);
			LED				: out std_logic_vector(7 downto 0);
			--====ADC====--
			ADC_SCK : out std_logic;
			ADC_CONVST : out std_logic;
			ADC_SDO : in  std_logic;
			ADC_SDI 	: out std_logic
		);
end pruebaOnBoardADC;

architecture a of pruebaOnBoardADC is 


	component AD7928_cyclic is
	 generic	(
		CH_NUMBER 	: natural range 1 to 8 := 8;
		CLK_DIVBIT 	: natural range 1 to 11 := 11;
		SAMPLE_CYCLES 	: natural range 1 to 1000000 := 1	);
	 port (
			reset: in std_logic;
			clk	: in std_logic;
			dout	: in std_logic;
			cs_n	: out std_logic;
			sclk	: out std_logic;
			din	: out std_logic;
			ch0	: out std_logic_vector(11 downto 0);
			ch1	: out std_logic_vector(11 downto 0);
			ch2	: out std_logic_vector(11 downto 0);
			ch3	: out std_logic_vector(11 downto 0);
			ch4	: out std_logic_vector(11 downto 0);
			ch5	: out std_logic_vector(11 downto 0);
			ch6	: out std_logic_vector(11 downto 0);
			ch7	: out std_logic_vector(11 downto 0);
			ready	: out std_logic	);
end component;

	signal voltimetro : std_logic_vector(7 downto 0) := "00000000";
	signal reset : std_logic;
	signal ch0 : std_logic_vector(11 downto 0);
	signal ready : std_logic;

begin

	reset <= not(KEY(0));
	
	inst1 : AD7928_cyclic
		generic map(
			CH_NUMBER 	=> 1,
			CLK_DIVBIT 	=> 11,
			SAMPLE_CYCLES 	=> 1)
		port map (	reset 	=> reset,
				clk 	=> FPGA_CLK1_50,
				dout  	=> ADC_SDO,
				cs_n  	=> ADC_CONVST,
				sclk 	=> ADC_SCK,
				din 	=> ADC_SDI,
				ch0  	=> ch0, --Potenciometro
				ready => ready );
				
				
		voltimetro <= ch0(11 downto 4);
		LED<=voltimetro;
		
end a;