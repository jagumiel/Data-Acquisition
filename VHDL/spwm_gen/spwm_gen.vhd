library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity spwm_gen is
	port(
		clk	: in  std_logic;
--		freq_sin: std_logic_vector(31 downto 0);
--		freq_tri: std_logic_vector(31 downto 0);
		phase1a: out std_logic;
		phase2a: out std_logic;
		phase3a: out std_logic;
		phase1b: out std_logic;
		phase2b: out std_logic;
		phase3b: out std_logic
	);
end spwm_gen;

architecture a of spwm_gen is

--Componentes:
component triangle
	port (	-- system signals
		clk:		in	 std_logic;
		amp:		in	 std_logic_vector(32-1 downto 0);
		frq:		in	 std_logic_vector(32-1 downto 0);
		pwm_ctrl:out std_logic_vector(32-1 downto 0)
	);
end component;

component sin
	port (
		clk:		in	 std_logic;
		amp:		in	 std_logic_vector(32-1 downto 0);
		frq:		in	 std_logic_vector(32-1 downto 0);
		pwm_ctrl:out std_logic_vector(32-1 downto 0)
	);
end component;

component sin_120
	port (
		clk:		in  std_logic;
		amp:		in	 std_logic_vector(32-1 downto 0);
		frq:		in  std_logic_vector(32-1 downto 0);
		pwm_ctrl:out std_logic_vector(32-1 downto 0)
	);
end component;

component sin_240
	port (
		clk:		in	 std_logic;
		amp:		in	 std_logic_vector(32-1 downto 0);
		frq:		in	 std_logic_vector(32-1 downto 0);
		pwm_ctrl:out std_logic_vector(32-1 downto 0)
	);
end component;

--senales
signal seno ,seno120, seno240, triangular : std_logic_vector(31 downto 0);
signal pulso ,pulso120, pulso240 : std_logic:='0';

begin
	--	x"00002710"  == 10 000
	--Seeing 10000 cycle of 20ns takes 100000ns -> 10KHz
	--	x"00989680"  == 10 000 000
	--  Seeing 10 000 000 cycles of 10ns takes 100 000 000ns  ->  10 Hz
	--	x"05F5E100"  == 100 000 000
	--  Seeing 100 000 000 cycles of 10ns takes 1 000 000 000ns  ->  1 Hz

	inst1: triangle
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		--frq		=> x"000003E8",--50kHz
		--frq		=> x"000001F4", --100kHz
		--frq		=> x"00001388", --10kHz
		frq		=> x"000009C4", --20kHz
		pwm_ctrl	=> triangular
	);

	inst2: sin
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		--frq		=> x"00001388", --Supuestamente, 5000 ciclos de 20ns, 10kHz
		frq		=> x"0000C350", --Supuestamente, 50000 ciclos de 20ns, 1kHz
		pwm_ctrl	=> seno
	);

	inst3: sin_120
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		frq		=> x"0000C350", --Supuestamente, 5000 ciclos de 20ns, 10kHz
		pwm_ctrl	=> seno120
	);

	inst4: sin_240
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		frq		=> x"0000C350", --Supuestamente, 5000 ciclos de 20ns, 10kHz
		pwm_ctrl	=> seno240
	);

	process(clk)--Ojo, igual tienes que anadir las variables que lees a la lista de sensibilidad
	begin
		if(triangular<seno)then
			pulso<='0';
		else
			pulso<='1';
		end if;

		if(triangular<seno120)then
			pulso120<='0';
		else
			pulso120<='1';
		end if;

		if(triangular<seno240)then
			pulso240<='0';
		else
			pulso240<='1';
		end if;
	end process;
	phase1a<=pulso;
	phase2a<=pulso120;
	phase3a<=pulso240;
	phase1b<=not(pulso);
	phase2b<=not(pulso120);
	phase3b<=not(pulso240);
end a;