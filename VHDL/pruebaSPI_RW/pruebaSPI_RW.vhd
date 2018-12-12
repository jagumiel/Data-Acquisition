--**********************************************************************************************************
--		Este modulo esta disenado para comunicarse con la placa de evaluacion AD7091RS.
--		Se trata de un ADC que se conecta por SPI. Tiene el integrado AD7091R.
--  	Hay que tener en cuenta que en estado de idle el reloj se queda a nivel bajo (0 lógico) y
--		que ademas tiene una entrada de CONVST, que baja a 0 para volver a subir antes de transferir datos.
--		Se han anadido diferentes frecuencias de trabajo (1Mhz, 5Mhz y 25Mhz).
--		En este caso, la placa no recibe datos por MOSI, solo envia datos a traves de la linea MISO.
--**********************************************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY pruebaSPI_RW is
	PORT(
			FPGA_CLK1_50: IN STD_LOGIC;
			KEY			: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			LED			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			CONVST		: OUT STD_LOGIC;
			SCK			: OUT STD_LOGIC;
			MISO			: IN STD_LOGIC;	
			MOSI			: OUT STD_LOGIC;
			SS				: OUT STD_LOGIC);
END pruebaSPI_RW;

architecture a of pruebaSPI_RW is

	COMPONENT masterSPI_RW IS
		GENERIC( nBits : INTEGER);
		PORT(
				CLK_50		: IN  STD_LOGIC;
				RST			: IN  STD_LOGIC;
				START			: IN  STD_LOGIC;
				SPEED			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				CPOL			: IN  STD_LOGIC;							--Polaridad
				CPHA			: IN  STD_LOGIC;							--Fase
				CS				: IN  STD_LOGIC_VECTOR(0 DOWNTO 0); --Chip Select
				I_DATA		: IN  STD_LOGIC_VECTOR(nBits-1 DOWNTO 0);
				O_DATA		: OUT STD_LOGIC_VECTOR(nBits-1 DOWNTO 0);
				BUSY			: OUT STD_LOGIC;
				CONVST		: OUT STD_LOGIC;
				SCLK			: OUT STD_LOGIC;
				SS1			: OUT STD_LOGIC;
				SS2			: OUT STD_LOGIC;
				MOSI			: OUT STD_LOGIC;
				MISO			: IN  STD_LOGIC);	
	END COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2, e3);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
		
	--Senales de datos para la placa
	constant	numBits 		: integer range 0 to 12 :=12;	--Numero de bits de la trama.
	signal 	reset			: std_logic:='0';
	signal	go				: std_logic;
	signal	speed			: std_logic_vector(1 downto 0):="11";
	signal	enviado		: std_logic_vector(numBits-1 downto 0):=(others=>'0');
	signal	recibido		: std_logic_vector(numBits-1 downto 0):=(others=>'0');
	
	--Señales para el testbench
	signal 	ocupado		: std_logic;
	signal	cnt			: integer range 0 to 4 :=0;


BEGIN

	reset<=NOT(KEY(0));

	PROCESS(FPGA_CLK1_50, ep, reset)
	BEGIN
		IF(rising_edge(FPGA_CLK1_50))THEN
			IF(reset='1')then
				es<=e0;
			ELSE
				CASE ep IS
					WHEN e0 =>
						speed<="11"; 	--1MHz
						es<=e1;
					WHEN e1 =>
						speed<="10";	--5MHz
						es<=e2;
					WHEN e2 =>
						speed<="01";	--25MHz
						es<=e3;
					WHEN e3 =>
						es<=e3;			--Idle
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	go	<='1' when (ocupado='0' and (ep=e0 or ep=e1 or ep=e2)) else '0'; --OJO! Esto es una PRUEBA. Solo queria recibir una trama!!!
	
	PROCESS(FPGA_CLK1_50, ocupado, es)
	BEGIN
		if(falling_edge(ocupado))then
			if(cnt<4)then	--Hago 5 repeticiones en cada estado.
				cnt<=cnt+1;
			else
				ep<=es;
				cnt<=0;
			end if;
		end if;
	END PROCESS;


	inst1: masterSPI_RW
		Generic Map( nBits => numBits)
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 		=> reset,
		START 	=> go,
		SPEED		=> speed,
		CPOL 		=> '1',
		CPHA		=> '1',
		CS 		=> "0",
		I_DATA 	=> enviado,  --Datos que envio.
		O_DATA 	=> recibido, --Datos que recibo
		BUSY 		=> ocupado,
		CONVST 	=> CONVST,
		SCLK		=> SCK,
		SS1 		=> SS,
		SS2		=> open,
		MOSI		=> MOSI,
		MISO 		=> MISO
	);
	--Muestro el valor en los leds. Tengo solo 8 leds, asi que cojo los valores mas significativos.
	LED<=recibido(numBits-1 downto numBits-8);
END a;