--***Este programa lee una señal cuadrada a través de uno de los pines GPIO de la placa.
--Hay que observar en la guía que pines son de I/O. Ya que algunos son de Vcc y GND.***

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity pruebaLecturaGPIO is
	port(
		FPGA_CLK1_50: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		GPIO_0	 	: in  std_logic_vector(0 downto 0);--Voy a obtener una única señal por GPIO_0(0), la declaro como entrada.
		LED			: out std_logic_vector(0 downto 0)
	);
end pruebaLecturaGPIO;

architecture a of pruebaLecturaGPIO is
	signal cont	: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal go	: std_logic;

begin

	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			go<=GPIO_0(0);
		end if;
	end process;
	
	LED(0)<= go; --La señal que genero la saco al exterior.
	
end a;