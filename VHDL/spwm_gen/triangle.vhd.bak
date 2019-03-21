library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use ieee.numeric_std;


entity triangle is
	port (
		clk:		in	std_logic;
		amp:		in	std_logic_vector(32-1 downto 0);
		frq:		in	std_logic_vector(32-1 downto 0);
		pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
	);
end triangle;

architecture Behavioral of triangle is

	type  SAMPLE_main is array (1 to 100) of std_logic_vector(31 downto 0);--antes 1 to 100
	constant data : SAMPLE_main := (
			x"00000000", x"00000002", x"00000004", x"00000006",	x"00000008", x"0000000A", 
			x"0000000C", x"0000000E", x"00000010", x"00000012",	x"00000014", x"00000016",
			x"00000018", x"0000001A", x"0000001C", x"0000001E",	x"00000020", x"00000022",
			x"00000024", x"00000026", x"00000028", x"0000002A",	x"0000002C", x"0000002E",
			x"00000030", x"00000033", x"00000035", x"00000037",	x"00000039", x"0000003B",
			x"0000003D", x"0000003F", x"00000041", x"00000043",	x"00000045", x"00000047",
			x"00000049", x"0000004B", x"0000004D", x"0000004F",	x"00000051", x"00000053",
			x"00000055", x"00000057", x"00000059", x"0000005B",	x"0000005D", x"0000005F",
			x"00000061", x"00000063", x"00000063", x"00000061", x"0000005F", x"0000005D", 
			x"0000005B", x"00000059", x"00000057", x"00000055", x"00000053", x"00000051", 
			x"0000004F", x"0000004D", x"0000004B", x"00000049", x"00000047", x"00000045", 
			x"00000043", x"00000041", x"0000003F", x"0000003D", x"0000003B", x"00000039", 
			x"00000037", x"00000035", x"00000033", x"00000030", x"0000002E", x"0000002C", 
			x"0000002A", x"00000028", x"00000026", x"00000024", x"00000022", x"00000020", 
			x"0000001E", x"0000001C", x"0000001A", x"00000018", x"00000016", x"00000014", 
			x"00000012", x"00000010", x"0000000E", x"0000000C", x"0000000A", x"00000008",
			x"00000006", x"00000004", x"00000002", x"00000000"
		);
begin
    
	process (clk)
		variable counter:	std_logic_vector(32-1 downto 0) := (others => '0');
		variable index: natural := 1;
	begin
		if (rising_edge(clk)) then
			counter := counter + 100;--antes era 100.
			-- if counter >= 1000  =  10ns * 1000 = 10 000ns
			--    increment index and reset counter
			if (counter = frq) then
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
