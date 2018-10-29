library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity lectorGPIO is
	port(
		dat_in	: in std_logic;
		salida	: out std_logic
	);
end lectorGPIO;

architecture a of lectorGPIO is

	signal resul	: std_logic; --Señal auxiliar. No puedo actuar directamente con las señales del sistema.
	
	begin
	
		resul<=dat_in;
		salida<=resul;

end a;