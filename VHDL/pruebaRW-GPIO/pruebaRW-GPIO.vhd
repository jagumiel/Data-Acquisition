--***Este programa es para probar la lectura y escritura de señales de manera simultanea.
--Escribo una señal cuadrada de 1Hz por GPIO_0(0) y recibo otra señal cuadrada por GPIO_O(1) que reflejo en el led.

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity pruebaRW_GPIO is
	port(
		FPGA_CLK1_50: in  	std_logic; 
		GPIO_0		: inout 	std_logic_vector(1 downto 0);
		LED 			: out 	std_logic_vector(0 downto 0)
	);
end pruebaRW_GPIO;
	
architecture a of pruebaRW_GPIO is
	signal cont	: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal go	: std_logic := '0';

BEGIN
	
	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			
			--Escritura
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
				GPIO_0(0)<=go;
			
			--Lectura				
			if (GPIO_0(1)='1')then
				LED(0)<='1';
			else
				LED(0)<='0';
			end if;
			
		end if;
	end process;
end a;