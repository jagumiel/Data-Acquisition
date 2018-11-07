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
			GO				: IN  STD_LOGIC;
			BUSY				: OUT STD_LOGIC;
			SCLK				: OUT STD_LOGIC;
			SDAT				: INOUT STD_LOGIC
			);
	end COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	

	signal command, data : std_logic_vector(7 downto 0);
	
	--Senales de datos para la placa
	signal cmd_config : std_logic_vector(7 downto 0) := "00000011"; --Configura los pines de la placa. Cuáles son de entrada y cuales de salida. (03h)
	signal cmd_write	: std_logic_vector(7 downto 0) := "00000001"; --Dice que el dato siguiente es para escribir en la salida.
	signal data_addr	: std_logic_vector(7 downto 0) := "11100100"; --Dirección de la placa y bit de escritura.
	signal data_ports : std_logic_vector(7 downto 0) := "00001111"; --Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	signal data_out	: std_logic_vector(7 downto 0) := "10101010"; --Digo donde quiero escribir un uno. Sólo lo hará en las que se configuren como salida.
	signal reset : std_logic:='0';
	signal wait_count : std_logic_vector(13 downto 0):="00000000000000";
	signal change : std_logic;
	SIGNAL go: std_logic;
	signal ocupado : std_logic;
	signal espera : std_logic;
	signal cont : std_logic_vector (6 downto 0);
	signal clk100k : std_logic;

BEGIN

	PROCESS(ep, reset, change)
	BEGIN
		IF(reset='1')then
			es<=e0;
		ELSE
			CASE ep IS
				WHEN e0 =>				--Estado de conf
					command<=cmd_config;
					data<=data_ports;
--					if(ocupado='0')then
--						go<='1';
--					end if;
					es<=e1;
				WHEN e1 =>
					if(change='1')then
						es<=e2;
					else
						es<=e1;
					end if;
					--go<='0';
				WHEN e2 =>
					if(ocupado='0')then
						--go<='1';
					end if;
					command<=cmd_write;
					data<=data_out;
					es<=e1;
			END CASE;
		END IF;
	END PROCESS;
	espera<='1' when ep=e1 else '0';

	PROCESS (FPGA_CLK1_50)
	BEGIN
		IF (espera='1')THEN
			IF(wait_count<"11110010001011")THEN
				wait_count<=wait_count+'1';
				change<='0';
			ELSE
				wait_count<="00000000000000";
				change<='1';
			END IF;
		END IF;
	END PROCESS;

	process (FPGA_CLK1_50) --Reloj de 200kHz
	begin
		if (rising_edge(FPGA_CLK1_50)) then
			if (cont<"1001011")then --Si es menor que 75
				clk100k<='0';
				cont<=cont+'1';
			else
				clk100k<='1';
				cont<=cont+'1';
			end if;
			if(cont="1111100")then 
				cont<="0000000";
			end if;
		end if;
	end process;

	PROCESS(clk100k)
	BEGIN
		if(clk100k='1')then
			ep<=es;
		end if;
	END PROCESS;


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


END a;