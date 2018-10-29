--***Este programa genera una señal cuadrada modulable en ancho de pulso que puede ser manipulada a través de un potenciómetro.
--Por un lado está el ADC, que se encarga de coger una señal analógica externa, y por otro lado el PWM que genera la señal.
--Usando el valor de entrada del ADC se consigue asignar un valor al duty, consiguiendo la manipulacion en tiempo real de la señal PWM.***

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 
use work.constantes_pwm.ALL; --Fichero de declaracion de constantes.


entity pruebaAnalogPWM is
	port(
		FPGA_CLK1_50: in  std_logic;
		GPIO_0	 	: out  std_logic_vector(0 downto 0);
		KEY			: in std_logic_vector(0 downto 0);
		LED			: out std_logic_vector(7 downto 0);
		--====ADC====--
		ADC_SCK : out std_logic;
		ADC_CONVST : out std_logic;
		ADC_SDO : in  std_logic;
		ADC_SDI 	: out std_logic
	);
end pruebaAnalogPWM;


architecture a of pruebaAnalogPWM is

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

	component PWM is 
		port (
			clk      : in  std_logic;
			rst      : in  std_logic;
			en       : in std_logic;	
			duty     : in std_logic_vector(DUTY_CYCLE_W downto 0);	
			pwm_out  : out std_logic
		);
	end component;
	
	signal reset: std_logic;
	signal ch0 : std_logic_vector(11 downto 0);
	signal ready : std_logic;
	
begin
		reset <= not(KEY(0));
		
		inst1 : AD7928_cyclic
			generic map(
				CH_NUMBER 	=> 8,
				CLK_DIVBIT 	=> 11,
				SAMPLE_CYCLES 	=> 1)
			port map (	reset 	=> reset,
				clk 	=> FPGA_CLK1_50,
				dout  => ADC_SDO,
				cs_n  => ADC_CONVST,
				sclk 	=> ADC_SCK,
				din 	=> ADC_SDI,
				ch0  	=> ch0, --Potenciometro
				ready => ready );
		
		inst2: PWM
			port map(
				clk 	=> FPGA_CLK1_50,
				rst 	=> reset,
				en  	=> '1',		--En este ejemplo quiero sacar un PWM continuo, así que dejo el enable activado.
				duty	=> ch0(11 downto 11-DUTY_CYCLE_W),
				pwm_out => GPIO_0(0));
				
				LED<=ch0(11 downto 4);
		
end a;