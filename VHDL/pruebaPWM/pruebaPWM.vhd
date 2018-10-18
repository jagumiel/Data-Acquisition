--***Este programa genera una señal cuadrada modulable en ancho de pulso.
--Este fichero es para usar la función. Hay un módulo por debajo que se encarga del trabajo de modulación
--Le estoy pasando el reloj del sistema, pero se puede usar con otras frecuencias.***

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 
use work.constantes_pwm.ALL; --Fichero de declaracion de constantes.


entity pruebaPWM is
	port(
		FPGA_CLK1_50: in  std_logic;
		GPIO_0	 	: out  std_logic_vector(0 downto 0);
		KEY			: in std_logic_vector(0 downto 0)
	);
end pruebaPWM;


architecture a of pruebaPWM is
	component PWM is 
		port (
			clk      : in  std_logic;
			rst      : in  std_logic;
			en       : in std_logic;	
			duty     : in std_logic_vector(DUTY_CYCLE_W downto 0);	
			pwm_out  : out std_logic
		);
	end component;
	
	signal reset: std_logic;
	--He probado a diferentes valores para duty_cycle y los he comprobado en el osciloscopio. Da el resultado esperado.
--	signal duty	: std_logic_vector(DUTY_CYCLE_W downto 0):="001010"; --Le asigno un valor al duty. (10/64)*100=15.6% de duty
--	signal duty	: std_logic_vector(DUTY_CYCLE_W downto 0):="000010"; --Le asigno un valor al duty. (4/64)*100=6.25% de duty
--	signal duty	: std_logic_vector(DUTY_CYCLE_W downto 0):="010000"; --Le asigno un valor al duty. (32/64)*100=50% de duty
	signal duty	: std_logic_vector(DUTY_CYCLE_W downto 0):="011000"; --Le asigno un valor al duty. (48/64)*100=75% de duty
	
begin
		reset <= not(KEY(0));
		
		inst1: PWM
			port map(
				clk 	=> FPGA_CLK1_50,
				rst 	=> reset,
				en  	=> '1', 		--En este ejemplo quiero sacar un PWM continuo, así que dejo el enable activado.
				duty	=> duty,
				pwm_out => GPIO_0(0)
			);
		
end a;