library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY temp_ctrl is
	PORT(
		FPGA_CLK1_50: IN STD_LOGIC;
		KEY			: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		LED			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		SW				: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CONVST		: OUT STD_LOGIC;
		SCK			: OUT STD_LOGIC;
		MISO			: IN STD_LOGIC;	
		MOSI			: OUT STD_LOGIC;
		SS1			: OUT STD_LOGIC;
		SS2			: OUT STD_LOGIC;
		SS3			: OUT STD_LOGIC;
		RESET_ADC	: OUT STD_LOGIC	--It seems it's low active. So it's value must be '1' all the time.
	);
END temp_ctrl;

architecture a of temp_ctrl is

	COMPONENT ADS1248_drv IS
		PORT(
			CLK_50		: IN  STD_LOGIC;
			RST			: IN  STD_LOGIC;
			START			: IN  STD_LOGIC;
			SPEED			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			CPOL			: IN  STD_LOGIC;							--Polaridad
			CPHA			: IN  STD_LOGIC;							--Fase
			CS				: IN  STD_LOGIC_VECTOR(1 DOWNTO 0); --Chip Select
			IN_CONF		: IN  STD_LOGIC_VECTOR(119 DOWNTO 0); --Configuracion. Digo que registro quiero para muestrear y leer.
			OUT_CONF		: OUT  STD_LOGIC_VECTOR(119 DOWNTO 0); --Lo que devuelve el ADC por MISO. NO INTERESA.
			IN_RD_NOP	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0); --Comando de lectura y los tres nops. ME LA PUEDO AHORRAR Y METERLA COMO INTERNA.
			OUT_RD_NOP	: OUT  STD_LOGIC_VECTOR(31 DOWNTO 0); --Lo que me devuelve 8bits de basura y 24 de la conversion.			
			BUSY			: OUT STD_LOGIC;
			CONVST		: OUT STD_LOGIC;
			SCLK			: OUT STD_LOGIC;
			SS1			: OUT STD_LOGIC;
			SS2			: OUT STD_LOGIC;
			SS3			: OUT STD_LOGIC;
			MOSI			: OUT STD_LOGIC;
			MISO			: IN  STD_LOGIC);	
	END COMPONENT;


	--Estados
	TYPE estados is (e0, e1, e2);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
		
	--Senales de datos para la placa
	signal 	reset			: std_logic:='0';
	signal	go				: std_logic;
	signal	speed			: std_logic_vector(1 downto 0):="11";
	signal	datoConv		: std_logic_vector(31 downto 0):=(others=>'0');
	
	--Señales para el testbench
	signal 	ocupado		: std_logic;
	signal	cnt			: integer range 0 to 4 :=0;
	
	--Senal para cambiar de emisor
	signal CS : std_logic_vector(1 downto 0):="00";
	
	--Senales para comparar.
	signal maxTemp	: std_logic_vector (23 downto 0):=(others=>'0'); --El ADC es de 24 bits. Hay que inicializarlo bien.
	
	--Senales de error
	signal stop : std_logic :='0';
	
	--otras senales
	signal done : std_logic :='0';
	signal registro : integer range 1 to 3 :=1;
	signal trama : integer range 0 to 14 :=1;
	signal temp1 :Std_logic_vector(23 downto 0) := x"000000";
	signal temp2 :Std_logic_vector(23 downto 0) := x"000000";
	signal temp3 :Std_logic_vector(23 downto 0) := x"000000";
	signal auxMUX0 :Std_logic_vector(7 downto 0) := x"01";
	signal auxIDAC1 :Std_logic_vector(7 downto 0) := x"89";
	signal MOSI_alt : std_logic :='0';
	signal SS1_alt : std_logic :='0';
	

	signal tramaConf : Std_logic_vector(119 downto 0);	--:= x"4000014200204300304A00064B0089";
	--signal tramaConf : Std_logic_vector(119 downto 0) := x"40001C4200204300304A00064B0029";
	signal tramaRead : Std_logic_vector(31 downto 0):= x"13FFFFFF";
	
	--READ DATA CONTINUOUS
	--signal tramaRead : Std_logic_vector(31 downto 0) := x"14FFFFFF";

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
						CS<="00";
						es<=e0;
					WHEN e1 =>
						CS<="01";
						es<=e2;
					WHEN e2 =>
						CS<="10";
						es<=e0;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	go	<='1' when (ocupado='0' and (ep=e0 or ep=e1 or ep=e2)) else '0';
	--go<='1' when ocupado='0'; --Seguramente esto tambien valga, pruebalo con HW real.
	
	PROCESS(FPGA_CLK1_50, ocupado, es) --Cuando se libera, paso al siguiente dispositivo.
	BEGIN
		if(falling_edge(ocupado))then
				if(ep=e0)then
					case registro is
						when 1 =>
							auxMUX0 <= x"01";
							auxIDAC1 <= x"89";
						when 2 =>
							auxMUX0 <= x"1C";
							auxIDAC1 <= x"29";
						when 3 =>
							auxMUX0 <= x"37";
							auxIDAC1 <= x"59";
					end case;
					tramaConf<=x"4000" & auxMUX0 & x"4200204300304A00064B00" & auxIDAC1;
					tramaRead<=x"13FFFFFF";
					if (registro=3)then
						registro<=1;
					else
						registro<=registro+1;
					end if;
--				elsif(ep=e1)then
--					valAmp2 <= recibido;
--				elsif(ep=e2)then
--					valAmp3 <= recibido;
--				else
--					valVolt <= recibido;
				end if;
		end if;
	END PROCESS;


	inst1: ADS1248_drv
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 		=> '0',
		START 	=> go,
		SPEED		=> "11",--1Mhz.
		CPOL 		=> '1',
		CPHA		=> '1',
		CS 		=> CS,
		IN_CONF	=> tramaConf,
		OUT_CONF	=> open,
		IN_RD_NOP	=>tramaRead,
		OUT_RD_NOP	=>datoConv,
		BUSY 		=> ocupado,
		CONVST 	=> CONVST,
		SCLK		=> SCK,
		SS1 		=> SS1_alt,
		SS2		=> SS2,
		SS3 		=> SS3,
		MOSI		=> MOSI_alt,
		MISO 		=> MISO
	);
	
	MOSI <= MOSI_alt WHEN (SS1_alt='0') else '1';
	SS1 <= SS1_alt;
	
	--Muestro el valor en los leds. Tengo solo 8 leds, asi que cojo los valores mas significativos.
	
	process(SW)
	begin
		if (SW="00")then
			LED<=temp1(23 downto 16);
		elsif(SW="01")then
			LED<=temp2(23 downto 16);
		else
			LED<=temp3(23 downto 16);
		end if;
	end process;
	
	RESET_ADC<= '1';
	
	
END a;