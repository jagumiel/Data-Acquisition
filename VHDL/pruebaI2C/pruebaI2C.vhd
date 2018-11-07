library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


ENTITY pruebaI2C is
	PORT(
			FPGA_CLK1_50 	: IN STD_LOGIC;
			KEY				: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			SCL				: OUT STD_LOGIC;
			SDA				: INOUT STD_LOGIC);
			
END pruebaI2C;



architecture a of pruebaI2C is

	COMPONENT masterI2C is
    Port( 
			CLK_50 			: IN  STD_LOGIC;
			RST 				: IN  STD_LOGIC;
			ADD				: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Address: Dirección del dispositivo.
			COM				: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Command: Tipo de orden a enviar.
			DAT				: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Data: Información a enviar.
			GO					: IN  STD_LOGIC;
			BUSY				: OUT STD_LOGIC;
			SCLK				: OUT STD_LOGIC;
			SDAT				: INOUT STD_LOGIC
			);
end COMPONENT;

	signal command, data : std_logic_vector(7 downto 0);

	
	--Señales de datos para la placa
	signal cmd_config : std_logic_vector(7 downto 0) := "00000011"; --Configura los pines de la placa. Cuáles son de entrada y cuales de salida. (03h)
	signal cmd_write	: std_logic_vector(7 downto 0) := "00000001"; --Dice que el dato siguiente es para escribir en la salida.
	signal data_addr	: std_logic_vector(7 downto 0) := "11100100"; --Dirección de la placa y bit de escritura.
	signal data_ports : std_logic_vector(7 downto 0) := "00001111"; --Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	signal data_out	: std_logic_vector(7 downto 0) := "10101010"; --Digo donde quiero escribir un uno. Sólo lo hará en las que se configuren como salida.
	signal configurated : std_logic:='0';
	signal reset : std_logic:='0';
	signal go, puesto : std_logic:='0';
	signal ocupado : std_logic;

	
begin
	
	reset<=not(KEY(0));

--	process(FPGA_CLK1_50)
--	begin
--		if(configurated='0' and ocupado='0')then
--			go<='1';
--			command<=cmd_config;
--			data<=data_ports;
--			configurated<='1';			
--		end if;
--	end process;
--	
--	process(FPGA_CLK1_50)
--	begin
--		if(ocupado='0' and puesto='0')then
--			go<='1';
--			command<=cmd_write;
--			data<=data_out;
--			puesto<='1';
--		elsif(configurated='1')then
--		 go<='0';
--		end if;
--	end process;

	process(ocupado)
	begin
		if(ocupado='0')then
		go<='1';
			if (configurated='0')then
				command<=cmd_config;
				data<=data_ports;
				configurated<='1';
			elsif(configurated='1' and puesto='0')then
				command<=cmd_write;
				data<=data_out;
				puesto<='1';
			else
				go<='0';
			end if;
		else
			go<='0';
		end if;
	end process;
		
				
				
			
	
	inst1: masterI2C
    Port Map( 
			CLK_50 => FPGA_CLK1_50,
			RST 	 => reset,
			ADD 	 => data_addr,
			COM 	 => command,
			DAT 	 => data,
			GO 	 => go,
			BUSY 	 => ocupado,
			SCLK 	 => SCL,
			SDAT 	 => SDA
			);



end a;