--***Este programa sirve para probar el modulo de I2C que he creado.
--El master de este proyecto solo trata la escritura a traves de I2C.
--Le invoco para probar una placa "BRD 0M13488 (Expansor de GPIO I2C).
--Tiene que enviar una trama de configuracion de pines y otra de salidas.
--Con esta configuracion pongo en salida los pines 4, 5, 6 y 7,
--ademas pongo a 1 los pines 5 y 7. Al tomar valor con un polimetro
--observo como esos pines tienen voltaje de 3.3V y el resto a 0.
--Ahora que veo que puedo enviar datos por I2C, el siguiente paso es
--hacer el apartado de lectura, y posteriormente, juntar ambos en un unico master.
-------------------------------------------------------------------------------------
--Notas:
--***

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY pruebaI2C_Read is
	PORT(
			FPGA_CLK1_50: IN STD_LOGIC;
			KEY			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			SCL			: OUT STD_LOGIC;
			SDA			: INOUT STD_LOGIC);	
END pruebaI2C_Read;

architecture a of pruebaI2C_Read is

	COMPONENT masterI2C_Read is
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
	TYPE estados is (e0, e1, e2, e3);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	

	signal command, data : std_logic_vector(7 downto 0);
	
	--Senales de datos para la placa
	constant cmd_config	: std_logic_vector(7 downto 0) := "00000011"; 	--Configura los pines de la placa. Cuales son de entrada y cuales de salida. (03h)
	constant cmd_write	: std_logic_vector(7 downto 0) := "00000001"; 	--Dice que el dato siguiente es para escribir en la salida.
	constant data_addr	: std_logic_vector(7 downto 0) := "11100100"; 	--Direccion de la placa y bit de escritura.
	constant data_ports	: std_logic_vector(7 downto 0) := "00001111"; 	--Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	constant data_out		: std_logic_vector(7 downto 0) := "10101010"; 	--Digo donde quiero escribir un uno. Solo lo hara en las que se configuren como salida.
	signal 	reset			: std_logic:='0';
	signal	wait_count 	: std_logic_vector(13 downto 0):="00000000000000";
	signal 	change		: std_logic;
	SIGNAL 	go				: std_logic;
	signal 	ocupado		: std_logic;
	signal 	espera		: std_logic;
	signal 	cont			: std_logic_vector (6 downto 0):="0000000";
	signal 	clk100k		: std_logic;
	signal 	clk100k_z	: std_logic;

BEGIN

	reset<=NOT(KEY(0));

	--AQUI LE HE METIDO EL CLOCK. ANTES NO ESTABA.
	PROCESS(clk100k, ep, reset)
	BEGIN
		IF(rising_edge(clk100k))THEN
			IF(reset='1')then
				es<=e0;
			ELSE
				CASE ep IS
					WHEN e0 =>				--Estado de conf
						command<=cmd_write;
						data<=cmd_write;
						es<=e1;
					WHEN e1 =>
						command<=cmd_write;
						data<=data_out;
						es<=e2;
					WHEN e2 =>
						es<=e3;
					WHEN e3 =>
						es<=e3;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	espera	<='1' 			when ep=e1 else '0';
	go			<='1' 	when (ocupado='0' and (ep=e0 or ep=e1)) else '0'; --OJO! Esto es una PRUEBA. Solo queria transmitir una trama!!!
	--command	<=cmd_config 	when ep=e1 else cmd_write when ep=e2 else command;
	--data		<=data_ports 	when ep=e1 else data_out when ep=e2 else data;
	--go<=NOT(KEY(1)) when ocupado='0' else '0';
	--ep <= es when go='1';


	PROCESS(clk100k, ocupado, es)
	BEGIN
		if(ocupado='0')then
			ep<=es;
		end if;
	END PROCESS;

--	PROCESS(clk100k)
--	BEGIN
--		IF (falling_edge(clk100k))THEN
--			IF(ocupado='0')THEN
--				ep<=es;
--			END IF;
--		END IF;
--	END PROCESS;

	inst1: masterI2C_Read
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 	=> reset,
		ADD 	=> data_addr,
		COM	=> command,
		DAT 	=> data,
		GO	=> go,
		BUSY	=> ocupado,
		SCLK	=> clk100k,
		SDAT	=> SDA
	);
	clk100k_Z <= 'Z' when clk100k = '1' else '0';
	SCL <= clk100k_Z;
	--SCL <= clk100k;
	
	--Me interesa tirar la trama por otra salida
	--Para eso puedo añadir una señal más en el master, algo así como rd_ack.
	--Cuando esa señal esté activa, en este lado tendría que hacer un caso en el que una variable coja el valor que hay en ese momento en SDA.
	--miVar<=SDA when rd_ack='1', else 'X';
	--Después con eso le puedo contestar al master y que se encargue de hacer la lógica para ack en la UC.
END a;