library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use ieee.numeric_std;


entity sin_120 is
	port (
		clk:		in	std_logic;
		amp:		in	std_logic_vector(32-1 downto 0);
		frq:		in	std_logic_vector(32-1 downto 0);
		pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
	);
end sin_120;

architecture Behavioral of sin_120 is

	type  SAMPLE_main is array (1 to 100) of std_logic_vector(31 downto 0);
	constant data : SAMPLE_main := (
			x"00000032", x"00000035", x"00000038", x"0000003B", x"0000003F", x"00000042",
			x"00000045", x"00000047", x"0000004A", x"0000004D", x"00000050", x"00000052",
			x"00000055", x"00000057", x"00000059", x"0000005B", x"0000005C", x"0000005E",
			x"0000005F", x"00000061", x"00000062", x"00000063", x"00000063", x"00000064",
			x"00000064", x"00000064", x"00000064", x"00000063", x"00000063", x"00000062",
			x"00000061", x"00000060", x"0000005F", x"0000005D", x"0000005C", x"0000005A",
			x"00000058", x"00000056", x"00000053", x"00000051", x"0000004E", x"0000004C",
			x"00000049", x"00000046", x"00000043", x"00000040", x"0000003D", x"0000003A",
			x"00000037", x"00000034", x"00000030", x"0000002D", x"0000002A", x"00000027",
			x"00000024", x"00000021", x"0000001E", x"0000001B", x"00000018", x"00000016",
			x"00000013", x"00000011", x"0000000E", x"0000000C", x"0000000A", x"00000008",
			x"00000007", x"00000005", x"00000004", x"00000003", x"00000002", x"00000001",
			x"00000001", x"00000000", x"00000000", x"00000000", x"00000000", x"00000001",
			x"00000001", x"00000002", x"00000003", x"00000005", x"00000006", x"00000008",
			x"00000009", x"0000000B", x"0000000D", x"0000000F", x"00000012", x"00000014",
			x"00000017", x"0000001A", x"0000001D", x"0000001F", x"00000022", x"00000025",
			x"00000029", x"0000002C", x"0000002F", x"00000032"
		);
begin
    
	process (clk)
		variable counter:	std_logic_vector(32-1 downto 0) := (others => '0');
		variable index: natural := 34;
	begin
		if (rising_edge(clk)) then
			counter := counter + 100;--Lo cambio a 200 para 20ns
			-- if counter >= 1000  =  10ns * 1000 = 10 000ns
			--    increment index and reset counter
			if (counter >= frq) then
				index := index + 1;
				counter := (others => '0');
			end if;

			-- if index > 100 reset it to 1
			if (index > 100) then
				index := 1;
			end if;
		end if;
		pwm_ctrl <= data(index);
	end process;

end Behavioral;