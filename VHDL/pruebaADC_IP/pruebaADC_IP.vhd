library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY pruebaADC_IP IS
	PORT(
		CLOCK			: in  std_logic;
		KEY			: in  std_logic_vector (0 downto 0);
		ch0			: out std_logic_vector(11 downto 0);
		ch1			: out std_logic_vector(11 downto 0);
		ch2			: out std_logic_vector(11 downto 0);
		ch3			: out std_logic_vector(11 downto 0);
		ch4			: out std_logic_vector(11 downto 0);
		ch5			: out std_logic_vector(11 downto 0);
		ch6			: out std_logic_vector(11 downto 0);
		ch7			: out std_logic_vector(11 downto 0);
		ADC_SCLK		: out std_logic;
		ADC_CS_N		: out std_logic;
		ADC_SDAT		: in  std_logic;
		ADC_SADDR	: out std_logic;
		LED			: out std_logic_vector(7 downto 0)
	);
END pruebaADC_IP;



	 
ARCHITECTURE a OF pruebaADC_IP IS
	component adc_control is
        port (
            CLOCK    : in  std_logic                     := 'X'; -- clk
            RESET    : in  std_logic                     := 'X'; -- reset
            CH0      : out std_logic_vector(11 downto 0);        -- CH0
            CH1      : out std_logic_vector(11 downto 0);        -- CH1
            CH2      : out std_logic_vector(11 downto 0);        -- CH2
            CH3      : out std_logic_vector(11 downto 0);        -- CH3
            CH4      : out std_logic_vector(11 downto 0);        -- CH4
            CH5      : out std_logic_vector(11 downto 0);        -- CH5
            CH6      : out std_logic_vector(11 downto 0);        -- CH6
            CH7      : out std_logic_vector(11 downto 0);        -- CH7
            ADC_SCLK : out std_logic;                            -- SCLK
            ADC_CS_N : out std_logic;                            -- CS_N
            ADC_DOUT : in  std_logic                     := 'X'; -- DOUT
            ADC_DIN  : out std_logic                             -- DIN
        );
    end component adc_control;
	 
	signal reset : std_logic;
	signal chan0 : std_logic_vector(11 downto 0);
	signal chan1 : std_logic_vector(11 downto 0);
	signal chan2 : std_logic_vector(11 downto 0);
	signal chan3 : std_logic_vector(11 downto 0);
	signal chan4 : std_logic_vector(11 downto 0);
	signal chan5 : std_logic_vector(11 downto 0);
	signal chan6 : std_logic_vector(11 downto 0);
	signal chan7 : std_logic_vector(11 downto 0);
	 
BEGIN
		
	reset <= not(KEY(0));

	u0 : component adc_control
        port map (
            CLOCK    => CLOCK,		--                clk.clk
            RESET    => reset,		--              reset.reset
            CH0      => chan0,		--           readings.CH0
            CH1      => chan1,		--                   .CH1
            CH2      => chan2,		--                   .CH2
            CH3      => chan3,		--                   .CH3
            CH4      => chan4,		--                   .CH4
            CH5      => chan5,		--                   .CH5
            CH6      => chan6,		--                   .CH6
            CH7      => chan7,		--                   .CH7
            ADC_SCLK => ADC_SCLK,	-- external_interface.SCLK
            ADC_CS_N => ADC_CS_N,	--                   .CS_N
            ADC_DOUT => ADC_SDAT,	--                   .DOUT
            ADC_DIN  => ADC_SADDR	--                   .DIN
        );
		  
		  
	LED<=chan0(11 downto 4);
	ch0<=chan0;
	ch1<=chan1;
	ch2<=chan2;
	ch3<=chan3;
	ch4<=chan4;
	ch5<=chan5;
	ch6<=chan6;
	ch7<=chan7;
		  
end a;