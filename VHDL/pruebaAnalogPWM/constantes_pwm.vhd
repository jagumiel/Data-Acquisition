library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package constantes_pwm  is

-------------------------------------------------------------------------
-- Data size definitions
------------------------------------------------------------------------- 
  constant SYS_CLK 					: natural := 50_000;		-- Reloj del sistema (En kHz)
  constant PWM_CLK 					: natural := 500;			-- Reloj del PWM (En kHz)
  constant DUTY_CYCLE_W	  			: natural := 5;			-- Resolución del PWM en bits (En 5 va bien, si se aumenta hay mas resolucion, pero es mas vulnerable a veriaciones externas)
  constant PERIOD					  	: natural := SYS_CLK / (PWM_CLK * 2**DUTY_CYCLE_W);
  constant PERIOD_W					: natural := integer(ceil(log2(real(PERIOD+1)))); 
  
end constantes_pwm;