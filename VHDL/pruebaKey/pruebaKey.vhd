--***Este programa es para probar los botones pulsadores.
--Se ha utilizado el pulsador Key0 para hacer el ejemplo.
--Cuando el botón esté pulsado se mostrará un valor y cuando esté al aire otro.
--El resultado se muestra utilizando los LEDs como representación.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity pruebaKey is
	port(
		KEY 	: in  std_logic_vector(0 downto 0); --Declaro solo 1 boton, que será el Key0.
		LED 	: out std_logic_vector(7 downto 0)
	);
end pruebaKey;
	
architecture a of pruebaKey is
	signal num	: std_logic_vector(7 downto 0) := "00000000";
BEGIN
	
	aritmetica:process (key(0))
	begin
		if (KEY(0)='0') then --Pulsada
			num<="10101010";
		else
			num<="00001111";
		end if;		
	end process;
	
	LED<=num;

end a;