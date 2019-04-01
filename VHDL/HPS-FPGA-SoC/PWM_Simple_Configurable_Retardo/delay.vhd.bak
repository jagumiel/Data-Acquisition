library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

--Nota, la "_d" indica que es ya con delay.

entity delay is
	port(
		clk:	 in std_logic;
		delay:	 in integer range 0 to 1000; --Lo voy a tomar en ns. Calcula que sean 500 aprox.
		phase1a: in std_logic;
		phase1b: in std_logic;
		phase1a_d: out std_logic;
		phase1b_d: out std_logic
	);
end delay;

architecture a of delay is

--Senales:
	--Estado anterior:
	signal status_phase1a: std_logic:='0';
	signal status_phase1b: std_logic:='0';
	--Espera
	signal espera: integer range 1 to 1000;
	--Contadores: (6 bits tendria que ser suficiente resolucion)
	signal cont_1a : integer range 0 to 1000:=0;
	signal cont_1b : integer range 0 to 1000:=0;

begin

	espera<=delay/20;

	process(clk)
	begin
		if (status_phase1a='0' and phase1a='1')then
			if(cont_1a<espera)then
				phase1a_d<='0';
				cont_1a<=cont_1a+1;
			else
				phase1a_d<=phase1a;
				status_phase1a<=phase1a;
				cont_1a<=0;
			end if;
		else
			phase1a_d<=phase1a;
			status_phase1a<=phase1a;
		end if;
	end process;

	process(clk)
	begin
		if (status_phase1b='0' and phase1b='1')then
			if(cont_1b<espera)then
				phase1b_d<='0';
				cont_1b<=cont_1b+1;
			else
				phase1b_d<=phase1b;
				status_phase1b<=phase1b;
				cont_1b<=0;
			end if;
		else
			status_phase1b<=phase1b;
			phase1b_d<=phase1b;
		end if;
	end process;


end a;
