library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity escritorGPIO is
	port(
		pwm_in	: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		pwm_out	: out std_logic
	);
end escritorGPIO;

architecture a of escritorGPIO is

	signal pwma	: std_logic; --Señal auxiliar. No puedo actuar directamente con las señales del sistema.
	
	begin
	
		pwma<=pwm_in;
		pwm_out<=pwma;

end a;