--***Este programa coge los switches y leds de la placa.
--Ambos se definen como un vector de bits, bajo el nombre de SW y LED.
--El programa sirve para representar la entrada de Switches con luces.
--Es decir, los interruptores encienden o apagan los leds asociados.***

library ieee;
use ieee.std_logic_1164.all;

entity pruebaLeds is
	port(
		SW 	: in  std_logic_vector(3 downto 0);
		LED 	: out std_logic_vector(7 downto 0)
	);
end pruebaLeds;
	
architecture a of pruebaLeds is
BEGIN
	LED<="0000" & SW(3 downto 0);
end a;