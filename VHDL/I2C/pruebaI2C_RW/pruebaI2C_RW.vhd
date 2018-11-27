library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY pruebaI2C_RW is
	PORT(
			FPGA_CLK1_50: IN STD_LOGIC;
			KEY			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			LED			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			SCL			: OUT STD_LOGIC;
			SDA			: INOUT STD_LOGIC);	
END pruebaI2C_RW;

architecture a of pruebaI2C_RW is

	COMPONENT masterI2C_RW is
   	 	Port( 
			CLK_50: IN  STD_LOGIC;
			RST 	: IN  STD_LOGIC;
			ADD	: IN  STD_LOGIC_VECTOR (6 DOWNTO 0);	--Address: Direccion del dispositivo.
			COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0);	--Command: Tipo de orden a enviar.
			DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0);	--Data: Informacion a enviar.
			GO		: IN  STD_LOGIC;
			RW		: IN  STD_LOGIC;							 	--Bit de L/E. 0=Write; 1=Read;
			SPEED : IN  STD_LOGIC;							 	--Velocidad de reloj. 0=100kHz; 1=400kHz.
			RDNUM : IN  INTEGER;									--Numero de registros a leer.
			BUSY	: OUT STD_LOGIC;
			DOUT	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);	--Salida de datos. Cuando hay operación de lectura saca ese resultado.
			SCLK	: OUT STD_LOGIC;
			SDAT	: INOUT STD_LOGIC
			);
	end COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2, e3, e4, e5, e6);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	

	signal command, data : std_logic_vector(7 downto 0);
	
	--Senales de datos para la placa
	constant cmd_config	: std_logic_vector(7 downto 0) := "00000011"; 	--Configura los pines de la placa. Cuales son de entrada y cuales de salida. (03h)
	constant cmd_write	: std_logic_vector(7 downto 0) := "00000001"; 	--Dice que el dato siguiente es para escribir en la salida.
	constant data_addr	: std_logic_vector(6 downto 0) := "1110010"; 	--Direccion de la placa.
	constant data_ports	: std_logic_vector(7 downto 0) := "00001111"; 	--Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	constant data_out		: std_logic_vector(7 downto 0) := "10101010"; 	--Digo donde quiero escribir un uno. Solo lo hara en las que se configuren como salida.
	signal 	reset			: std_logic:='0';
	signal	wait_count 	: std_logic_vector(13 downto 0):="00000000000000";
	signal 	change		: std_logic;
	signal 	go				: std_logic;
	signal 	ocupado		: std_logic;
	signal 	cont			: std_logic_vector (6 downto 0):="0000000";
	signal 	clk100k		: std_logic;
	signal 	clk100k_z	: std_logic;
	signal	le				: std_logic:='0';
	signal	speed			: std_logic:='0';
	signal	rdnum			:integer range 0 to 9:=6; 		--OJO! Que he puesto 2 en la definicion solo para la prueba.

BEGIN

	reset<=NOT(KEY(0));

	PROCESS(clk100k, ep, reset)
	BEGIN
		IF(rising_edge(clk100k))THEN
			IF(reset='1')then
				es<=e0;
			ELSE
				CASE ep IS
					WHEN e0 =>				--Estado de conf
						command<=cmd_config;
						data<=data_ports;
						le<='0';
						es<=e1;
					WHEN e1 =>
						command<=cmd_write;
						data<="01101010";
						le<='0';
						es<=e2;
					WHEN e2 =>
						command<=cmd_write;
						le<='1';
						es<=e3;
						rdnum<=0;
						--speed<='0';
					WHEN e3 =>
						command<="00000010";
						le<='1';
						rdnum<=0;
						--speed<='0';
						es<=e4;
					WHEN e4 =>
						command<="00000011";
						le<='1';
						es<=e5;
						rdnum<=0;
						--speed<='0';
					WHEN e5 =>
						command<="00000001";
						le<='1';
						es<=e6;
						rdnum<=3;
						--speed<='0';
					WHEN e6 =>
						es<=e6;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	go			<='1' 	when (ocupado='0' and (ep=e0 or ep=e1 or ep=e2 or ep=e3 or ep=e4 or ep=e5)) else '0'; --OJO! Esto es una PRUEBA. Solo queria transmitir una trama!!!
	speed		<='1'		when ep=e1 or ep=e2 or ep=e3 else '0';
	
	PROCESS(clk100k, ocupado, es)
	BEGIN
		if(ocupado='0')then
			ep<=es;
		end if;
	END PROCESS;


	inst1: masterI2C_RW
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 	=> reset,
		ADD 	=> data_addr,
		COM	=> command,
		DAT 	=> data,
		GO	=> go,
		RW => le,
		SPEED => '0',
		RDNUM => rdnum,
		BUSY	=> ocupado,
		DOUT => LED,
		SCLK	=> clk100k,
		SDAT	=> SDA
	);
	clk100k_Z <= 'Z' when clk100k = '1' else '0';
	SCL <= clk100k_Z;
	
END a;