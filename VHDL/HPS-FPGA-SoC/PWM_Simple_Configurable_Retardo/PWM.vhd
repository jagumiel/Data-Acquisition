library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PWM is
    Port ( CLK : in  STD_LOGIC;
           DUTY : in  STD_LOGIC_VECTOR (7 downto 0);
           PWM_OUT : out  STD_LOGIC;
			  PWMinv_OUT: out	STD_LOGIC
			);
end PWM;

architecture Behavioral of PWM is

	signal COUNTER : std_logic_vector (7 downto 0) := "00000000";
	signal pwm : std_logic :='1';

begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if COUNTER="11111111" then
				COUNTER <= "00000000";
			else
				COUNTER <= COUNTER + '1';
			end if;
			if COUNTER>DUTY then
				pwm <= '0';
			elsif DUTY/="00000000" then
				pwm <= '1';
			end if;
		end if;
	end process;
	
	PWM_OUT<=pwm;
	PWMinv_OUT<=not(pwm);

end Behavioral;
