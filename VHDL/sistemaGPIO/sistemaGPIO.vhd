library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity sistemaGPIO is
	port(
		FPGA_CLK1_50: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		GPIO_0	: out std_logic_vector(0 downto 0);
		GPIO_1	: in std_logic_vector(0 downto 0);
		LED		: out std_logic_vector(7 downto 0)
	);
end sistemaGPIO;


architecture a of sistemaGPIO is

	component escritorGPIO is
		port(
			pwm_in		: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
			pwm_out	: out std_logic
		);
	end component;

	component lectorGPIO is
		port(
			dat_in	: in std_logic;
			salida	: out std_logic
		);
	end component;

	signal cont	: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal go	: std_logic;

begin

	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			if (cont<"10111110101111000001111111")then
				go<='0';
				cont<=cont+'1';
			else
				cont<="00000000000000000000000000";
				go<='1';
			end if;
		end if;
	end process;
	
	inst1: escritorGPIO
	port map(pwm_in=>go,
				pwm_out=>GPIO_0(0));
	
--	inst2: lectorGPIO
--	port map(dat_in=>GPIO_1(0),
--				salida=>LED(0));		

	
end a;