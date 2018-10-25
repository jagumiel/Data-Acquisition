library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constantes_pwm.ALL;	--Usa un fichero con definiciones de constantes. Es para asignar longitudes a los vectores.


entity PWM is 
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
	
    en       : in std_logic;	
    duty     : in std_logic_vector(DUTY_CYCLE_W downto 0);	--Resolucion del PWM en bits.
    pwm_out  : out std_logic
  );
end entity PWM;

architecture a of PWM is
  signal clk_en    : std_logic;
  signal cnt       : unsigned(PERIOD_W-1 downto 0);
  signal cnt_duty  : unsigned(DUTY_CYCLE_W-1 downto 0);

begin
  cnt_pr : process(clk, rst)
  begin 
    if (rst = '1') then
      cnt     <= (others => '0');
      clk_en  <= '0';
    elsif (rising_edge(clk)) then
    -- default
    clk_en	<= '0';
    
    if (en = '1') then
      if (cnt = 0) then
          cnt     <= to_unsigned(PERIOD-1, cnt'length);
          clk_en	<= '1';
        else
          cnt <= cnt - 1;
        end if;
      end if;	
    end if;	
  end process cnt_pr;	
   	
  cnt_duty_pr : process(clk, rst)
  begin 
    if (rst = '1') then
      cnt_duty    <= (others => '0');
      pwm_out     <= '0';
    elsif (rising_edge(clk)) then		
      if (clk_en = '1') then
        cnt_duty <= cnt_duty + 1;
      end if;	
      if (cnt_duty < unsigned(duty)) then
        pwm_out <= '1';
      else
        pwm_out <= '0';
      end if;		
    end if;	
  end process cnt_duty_pr;	

end a;