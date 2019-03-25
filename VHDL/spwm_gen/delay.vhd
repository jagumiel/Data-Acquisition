library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

--Nota, la "_d" indica que es ya con delay.

entity delay is
	port(
		clk:	 in std_logic;
		delay:	 in integer range 0 to 1000; --Lo voy a tomar en ns. Calcula que sean 500 aprox.
		phase1a: in std_logic;
		phase2a: in std_logic;
		phase3a: in std_logic;
		phase1b: in std_logic;
		phase2b: in std_logic;
		phase3b: in std_logic;
		phase1a_d: out std_logic;
		phase2a_d: out std_logic;
		phase3a_d: out std_logic;
		phase1b_d: out std_logic;
		phase2b_d: out std_logic;
		phase3b_d: out std_logic
	);
end delay;

architecture a of delay is

--Senales:
	--Estado anterior:
	signal status_phase1a: std_logic:='0';
	signal status_phase2a: std_logic:='0';
	signal status_phase3a: std_logic:='0';
	signal status_phase1b: std_logic:='0';
	signal status_phase2b: std_logic:='0';
	signal status_phase3b: std_logic:='0';
	--Espera
	signal espera: integer range 1 to 1000;
	--Contadores: (6 bits tendria que ser suficiente resolucion)
	signal cont_1a : integer range 0 to 1000:=0;
	signal cont_1b : integer range 0 to 1000:=0;
	signal cont_2a : integer range 0 to 1000:=0;
	signal cont_2b : integer range 0 to 1000:=0;
	signal cont_3a : integer range 0 to 1000:=0;
	signal cont_3b : integer range 0 to 1000:=0;

	--Locales?
	--Es posible que no puedas sacar el output directamente desde un process, igual conviene guardar en una locar y unir un "cable" al output.

begin

	espera<=delay/20;

	process(clk)
	begin
		if (status_phase1a='0' and phase1a='1')then
			--Quiero hacer de prueba un retraso de 500ns. Mi reloj es de 50Mhz=20ns.
			--500ns/20ns=25 ciclos de reloj. Mi contador tiene que contar hasta 25.
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
		
--Creo que tengo que tener 6 contadores, no puede ser lineal, porque si estas atendiendo a una en el "if" paras el resto.

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

	process(clk)
	begin
		if (status_phase2a='0' and phase2a='1')then
			if(cont_2a<espera)then
				phase2a_d<='0';
				cont_2a<=cont_2a+1;
			else
				phase2a_d<=phase2a;
				status_phase2a<=phase2a;
				cont_2a<=0;
			end if;
		else
			phase2a_d<=phase2a;
			status_phase2a<=phase2a;
		end if;
	end process;

	process(clk)
	begin
		if (status_phase2b='0' and phase2b='1')then
			if(cont_2b<espera)then
				phase2b_d<='0';
				cont_2b<=cont_2b+1;
			else
				phase2b_d<=phase2b;
				status_phase2b<=phase2b;
				cont_2b<=0;
			end if;
		else
			phase2b_d<=phase2b;
			status_phase2b<=phase2b;
		end if;
	end process;

	process(clk)
	begin
		if (status_phase3a='0' and phase3a='1')then
			if(cont_3a<espera)then
				phase3a_d<='0';
				cont_3a<=cont_3a+1;
			else
				phase3a_d<=phase3a;
				status_phase3a<=phase3a;
				cont_3a<=0;
			end if;
		else
			phase3a_d<=phase3a;
			status_phase3a<=phase3a;
		end if;
	end process;

	process(clk)
	begin
		if (status_phase3b='0' and phase3b='1')then
			if(cont_3b<espera)then
				phase3b_d<='0';
				cont_3b<=cont_3b+1;
			else
				phase3b_d<=phase3b;
				status_phase3b<=phase3b;
				cont_3b<=0;
			end if;
		else
			phase3b_d<=phase3b;
			status_phase3b<=phase3b;
		end if;
	end process;

end a;