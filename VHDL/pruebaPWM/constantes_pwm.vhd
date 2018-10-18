library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package constantes_pwm  is

-------------------------------------------------------------------------
-- Data size definitions
------------------------------------------------------------------------- 
  constant SYS_CLK 					: natural := 100_000;		-- System clock in kHz
  constant PWM_CLK 					: natural := 500;			-- PWM clock in kHz
  constant DUTY_CYCLE_W	  	: natural := 5;				-- PWM resolution in bits
  constant PERIOD					  : natural := SYS_CLK / (PWM_CLK * 2**DUTY_CYCLE_W);
  constant PERIOD_W					: natural := integer(ceil(log2(real(PERIOD+1)))); 
  
end constantes_pwm;