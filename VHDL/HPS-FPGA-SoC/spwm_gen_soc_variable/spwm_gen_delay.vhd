library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity spwm_gen_delay is
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
end spwm_gen_delay;

architecture a of spwm_gen_delay is

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

component delay
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
end component;

--senales
signal seno ,seno120, seno240, triangular : std_logic_vector(31 downto 0);
signal pulso ,pulso120, pulso240 : std_logic:='0';
signal phase1a_delay, phase2a_delay, phase3a_delay, phase1b_delay, phase2b_delay, phase3b_delay : std_logic:='0';

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

	inst5: delay
	port map( --Cuidado, mira que el NOT sea sintetizable luego.
		clk		=> clk,
		delay		=> 500,
		phase1a		=> pulso,
		phase2a		=> pulso120,
		phase3a		=> pulso240,
		phase1b		=> "NOT"(pulso),
		phase2b		=> "NOT"(pulso120),
		phase3b		=> "NOT"(pulso240),
		phase1a_d	=> phase1a_delay,
		phase2a_d	=> phase2a_delay,
		phase3a_d	=> phase3a_delay,
		phase1b_d	=> phase1b_delay,
		phase2b_d	=> phase2b_delay,
		phase3b_d	=> phase3b_delay
	);

	phase1a<=phase1a_delay;
	phase2a<=phase2a_delay;
	phase3a<=phase3a_delay;
	phase1b<=phase1b_delay;
	phase2b<=phase2b_delay;
	phase3b<=phase3b_delay;
end a;