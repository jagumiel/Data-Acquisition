--***Este programa es un sumador por reloj con botón de reset.
--Se ha hecho para comprobar como funcionan los pulsadores.***

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 


entity pruebaSumaKey is
	port(
		FPGA_CLK1_50: in  std_logic; --Hay que coger uno de los relojes con el nombre que aparece en el manual.
		KEY 	: in  std_logic_vector(0 downto 0); --Declaro solo 1 boton.
		LED 	: out std_logic_vector(7 downto 0)
	);
end pruebaSumaKey;
	
architecture a of pruebaSumaKey is
	signal clk_a	: std_logic; --Reloj auxiliar.
	signal cont		: std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal total	: std_logic_vector(7 downto 0) := "00000000";
BEGIN
	
	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			if (cont<"01011111010111100000111111")then
				clk_a<='0';
				cont<=cont+'1';
			else
				clk_a<='1';
				if(cont="10111110101111000001111111") then
					cont<="00000000000000000000000000";
				end if;
				cont<=cont+'1';
			end if;
		end if;
	end process;
	

--En la guía aparece que los pulsadores llevan ya incluido el debouncing.
	process (clk_a)
	begin							--OJO. Los dos if en la misma instruccion no funcionaban "(clk_a='1' and KEY(0)='0')".
		if (clk_a='1') then 	--Pero separados sí que funciona.
			if(KEY(0)='0')then--0=Tecla Pulsada
				total<="00000000";
			else
				if (total<"11111111")then --Evito el overflow.
					total<=total+'1';
				else
					total<="00000000";
				end if;
			end if;
		end if;
	end process;

	LED<=total;

end a;