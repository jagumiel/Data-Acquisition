<<<<<<< HEAD
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY pruebaI2C is
	PORT(
			FPGA_CLK1_50 	: IN STD_LOGIC;
			KEY		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			SCL		: OUT STD_LOGIC;
			SDA		: INOUT STD_LOGIC);	
END pruebaI2C;

architecture a of pruebaI2C is

	COMPONENT masterI2C is
   	 	Port( 
			CLK_50: IN  STD_LOGIC;
			RST 	: IN  STD_LOGIC;
			ADD	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Address: Direccion del dispositivo.
			COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Command: Tipo de orden a enviar.
			DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Data: Informacion a enviar.
			GO		: IN  STD_LOGIC;
			BUSY	: OUT STD_LOGIC;
			SCLK	: OUT STD_LOGIC;
			SDAT	: INOUT STD_LOGIC
			);
	end COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	

	signal command, data : std_logic_vector(7 downto 0);
	
	--Senales de datos para la placa
	constant cmd_config	: std_logic_vector(7 downto 0) := "00000011"; 	--Configura los pines de la placa. Cuales son de entrada y cuales de salida. (03h)
	constant cmd_write	: std_logic_vector(7 downto 0) := "00000001"; 	--Dice que el dato siguiente es para escribir en la salida.
	constant data_addr	: std_logic_vector(7 downto 0) := "11100100"; 	--Direccion de la placa y bit de escritura.
	constant data_ports	: std_logic_vector(7 downto 0) := "00001111"; 	--Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	constant data_out		: std_logic_vector(7 downto 0) := "10101010"; 	--Digo donde quiero escribir un uno. Solo lo hara en las que se configuren como salida.
	signal reset		: std_logic:='0';
	signal wait_count 	: std_logic_vector(13 downto 0):="00000000000000";
	signal change		: std_logic;
	SIGNAL go		: std_logic;
	signal ocupado		: std_logic;
	signal espera		: std_logic;
	signal cont		: std_logic_vector (6 downto 0):="0000000";
	signal clk100k		: std_logic;
	signal clk100k_z	: std_logic;

BEGIN

	reset<=NOT(KEY(0));

	--AQUI LE HE METIDO EL CLOCK. ANTES NO ESTABA.
	PROCESS(clk100k, ep, reset, change)
	BEGIN
		IF(rising_edge(clk100k))THEN
			IF(reset='1')then
				es<=e0;
			ELSE
				CASE ep IS
					WHEN e0 =>				--Estado de conf
						es<=e1;
					WHEN e1 =>
						if(change='1')then
							es<=e2;
						else
							es<=e1;
						end if;
					WHEN e2 =>
						es<=e2;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	espera	<='1' 			when ep=e1 else '0';
	go			<='1' 			when ocupado='0' else '0';
	command	<=cmd_config 	when ep=e0 else cmd_write when ep=e2 else command when ep=e1;
	data		<=data_ports 	when ep=e0 else data_out when ep=e2 else data when ep=e1;
	--go<=NOT(KEY(1)) when ocupado='0' else '0';

	PROCESS (FPGA_CLK1_50)
	BEGIN
		--Aqui le digo lo que tiene que hacer en el estado e1. Esperar.
		IF(rising_edge(FPGA_CLK1_50))THEN
			IF (espera='1')THEN
				IF(wait_count<"11110010001011")THEN
					wait_count<=wait_count+'1';
					change<='0';
				ELSE
					wait_count<="00000000000000";
					change<='1';
				END IF;
			END IF;
		END IF;
	END PROCESS;


	PROCESS(clk100k)
	BEGIN
		if(rising_edge(clk100k))then
			ep<=es;
		end if;
	END PROCESS;


	inst1: masterI2C
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 	=> reset,
		ADD 	=> data_addr,
		COM	=> command,
		DAT 	=> data,
		GO		=> go,
		BUSY	=> ocupado,
		SCLK	=> clk100k,
		SDAT	=> SDA
	);
	clk100k_Z <= 'Z' when clk100k = '1' else '0';
	SCL <= clk100k_Z;
	
	--Me interesa tirar la trama por otra salida
	--Para eso puedo añadir una señal más en el master, algo así como rd_ack.
	--Cuando esa señal esté activa, en este lado tendría que hacer un caso en el que una variable coja el valor que hay en ese momento en SDA.
	--miVar<=SDA when rd_ack='1', else 'X';
	--Después con eso le puedo contestar al master y que se encargue de hacer la lógica para ack en la UC.
=======
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY pruebaI2C is
	PORT(
			FPGA_CLK1_50 	: IN STD_LOGIC;
			KEY		: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			SCL		: OUT STD_LOGIC;
			SDA		: INOUT STD_LOGIC);	
END pruebaI2C;

architecture a of pruebaI2C is

	COMPONENT masterI2C is
   	 	Port( 
			CLK_50 	: IN  STD_LOGIC;
			RST 	: IN  STD_LOGIC;
			ADD	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Address: DirecciÃ³n del dispositivo.
			COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Command: Tipo de orden a enviar.
			DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); --Data: InformaciÃ³n a enviar.
			GO	: IN  STD_LOGIC;
			BUSY	: OUT STD_LOGIC;
			SCLK	: OUT STD_LOGIC;
			SDAT	: INOUT STD_LOGIC
			);
	end COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	

	signal command, data : std_logic_vector(7 downto 0);
	
	--Senales de datos para la placa
	constant cmd_config	: std_logic_vector(7 downto 0) := "00000011"; 	--Configura los pines de la placa. CuÃ¡les son de entrada y cuales de salida. (03h)
	constant cmd_write	: std_logic_vector(7 downto 0) := "00000001"; 	--Dice que el dato siguiente es para escribir en la salida.
	constant data_addr	: std_logic_vector(7 downto 0) := "11100100"; 	--DirecciÃ³n de la placa y bit de escritura.
	constant data_ports	: std_logic_vector(7 downto 0) := "00001111"; 	--Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	constant data_out		: std_logic_vector(7 downto 0) := "10101010"; 	--Digo donde quiero escribir un uno. SÃ³lo lo harÃ¡ en las que se configuren como salida.
	signal reset		: std_logic:='0';
	signal wait_count 	: std_logic_vector(13 downto 0):="00000000000000";
	signal change		: std_logic;
	SIGNAL go		: std_logic;
	signal ocupado		: std_logic;
	signal espera		: std_logic;
	signal cont		: std_logic_vector (6 downto 0):="0000000";
	signal clk100k		: std_logic;
	signal clk100k_z		: std_logic;

BEGIN

	reset<=NOT(KEY(0));

	PROCESS(ep, reset, change)
	BEGIN
		IF(reset='1')then
			es<=e0;
		ELSE
			CASE ep IS
				WHEN e0 =>				--Estado de conf
					es<=e1;
				WHEN e1 =>
					if(change='1')then
						es<=e2;
					else
						es<=e1;
					end if;
				WHEN e2 =>
					es<=e2;
			END CASE;
		END IF;
	END PROCESS;
	espera	<='1' 			when ep=e1 else '0';
	go			<='1' 			when ocupado='0' else '0';
	command	<=cmd_config 	when ep=e0 else cmd_write when ep=e2 else command when ep=e1;
	data		<=data_ports 	when ep=e0 else data_out when ep=e2 else data when ep=e1;

	PROCESS (FPGA_CLK1_50)
	BEGIN
		--Aqui le digo lo que tiene que hacer en el estado e1. Esperar.
		IF(rising_edge(FPGA_CLK1_50))THEN
			IF (espera='1')THEN
				IF(wait_count<"11110010001011")THEN
					wait_count<=wait_count+'1';
					change<='0';
				ELSE
					wait_count<="00000000000000";
					change<='1';
				END IF;
			END IF;
		END IF;
	END PROCESS;


	PROCESS(clk100k)
	BEGIN
		--if(clk100k='1')then
		if(rising_edge(clk100k))then
			ep<=es;
		end if;
	END PROCESS;


	inst1: masterI2C
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 	=> reset,
		ADD 	=> data_addr,
		COM	=> command,
		DAT 	=> data,
		GO		=> go,
		BUSY	=> ocupado,
		SCLK	=> clk100k,
		SDAT	=> SDA
	);
	clk100k_Z <= 'Z' when clk100k = '1' else '0';
	SCL <= clk100k_Z;

>>>>>>> c207cac0150612d7d1d3dd89802dd2c7819456e3
END a;