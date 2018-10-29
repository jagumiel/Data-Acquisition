--***Este programa funciona en base al reloj.
--Hay un contador y se muestra, a través de los leds, el tiempo en segundos que ha pasado desde su arranque.***

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity pruebaLedsCont is
	port(
		FPGA_CLK1_50: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		KEY 	: in  std_logic_vector(0 downto 0);--Key se llaman los botones de la placa.
		LED 	: out std_logic_vector(7 downto 0)
	);
end pruebaLedsCont;
	
architecture a of pruebaLedsCont is
	signal reset	: std_logic;
	signal go		: std_logic;
	signal cont		: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal suma		: std_logic_vector(7 downto 0) := "00000000";
BEGIN
	reset <= not(KEY(0));
	
	--Contador: Cuenta hasta 50M, lo que se traduce a 1 segundo.
	--Pasado ese tiempo activa la señal "go".
	process(FPGA_CLK1_50)
	begin
		if (FPGA_CLK1_50'event and FPGA_CLK1_50='1') then
			if (cont<"10111110101111000001111111")then
				go<='0';
				cont<=cont+'1';
			else
				cont<="00000000000000000000000000";
				go<='1';
			end if;
		end if;
	end process;
	
	--Sumador: Cada vez que se activa la señal go suma "1".
	--Muestra los segundos que han pasado, en binario, a través de los leds.
	process(go)
	begin
		if (go='1')then
			suma<=suma+'1';
		end if;
		LED<=suma;
		if(suma="11111111")then
			suma<="00000000";
		end if;
	end process;
	
end a;