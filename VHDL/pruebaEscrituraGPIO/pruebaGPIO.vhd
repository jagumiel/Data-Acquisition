--***Este programa genera una señal cuadrada y la saca a través de uno de los pines GPIO de la placa.
--Hay que observar en la guía que pines son de I/O. Ya que algunos son de Vcc y GND.
--Estoy generando una señal lenta de 1Hz. Hay que ajustar el osciloscopio para verla bien.***


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity pruebaGPIO is
	port(
		FPGA_CLK1_50: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		GPIO_0	 	: out std_logic_vector(0 downto 0)--Voy a sacar una única señal por la salida GPIO_0(0), la declaro como salida.
	);
end pruebaGPIO;

architecture a of pruebaGPIO is
	signal cont		: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal go	: std_logic;

begin

	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			if (cont<"01011111010111100000111111")then --Cuento hasta la mitad.
				go<='0';
				cont<=cont+'1';
			else
				go<='1';
				cont<=cont+'1';
			end if;
			if(cont="10111110101111000001111111")then --Si llega a un 50M de ciclos, reseteo de nuevo la señal.
				cont<="00000000000000000000000000";
			end if;
		end if;
	end process;
	
	GPIO_0(0)<= go; --La señal que genero la saco al exterior.
	
end a;