library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


ENTITY entrada IS
	PORT(
		FPGA_CLK1_50: IN STD_LOGIC;
		reset 		: IN STD_LOGIC;
		switches 	: IN STD_LOGIC_VECTOR(3 downto 0);
		avl_irq 		: OUT STD_LOGIC;
		avl_read		: IN STD_LOGIC;
		avl_readdata: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END entrada;


ARCHITECTURE MAIN of entrada IS

	signal cur_inputs : std_logic_vector(3 downto 0):="0000";
	signal last_inputs: std_logic_vector(3 downto 0):="0000";
	signal changed_inputs : std_logic_vector(3 downto 0):="0000";
	signal irq : std_logic:='0';
	
begin
	
	avl_irq<=irq;
	avl_readdata<=last_inputs;
	changed_inputs<=cur_inputs xor last_inputs;

	process(FPGA_CLK1_50)
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			if(reset='1')then
				cur_inputs <= "0000";
				last_inputs <= "0000";
				irq <= '0';
			else
				cur_inputs<=switches;
				last_inputs<=cur_inputs;
				if(changed_inputs/="0000")then
					irq<='1';
				elsif(avl_read='1')then
					irq<='0';
				end if;
			end if;
		end if;
	end process;

end MAIN;