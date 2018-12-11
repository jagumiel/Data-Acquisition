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
			SS			: OUT STD_LOGIC;
			GPIO_0	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Voltios		: OUT STD_LOGIC);--Del GPIO quiero obtener los 2,5V nada más. Es para probar y no coger otra fuente extra.
			--Ojo. Del GPIO ahora tienen que salir 3.3V, por lo que hay que colocarle una resistencia.
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
	TYPE estados is (e0, e1, e2, e3, e4, e5, e6);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
		
	--Senales de datos para la placa
	signal 	reset			: std_logic:='0';
	signal 	change		: std_logic;
	signal	go				: std_logic;
	signal 	ocupado		: std_logic;
	signal	speed			: std_logic_vector(1 downto 0):="11";
	constant	numBits 		: integer range 0 to 12 :=12;
	signal	enviado		: std_logic_vector(numBits-1 downto 0):=(others=>'0');
	signal	recibido		: std_logic_vector(numBits-1 downto 0):=(others=>'0');

BEGIN

	reset<=NOT(KEY(0));
	Voltios<='1';

	PROCESS(FPGA_CLK1_50, ep, reset)
	BEGIN
		IF(rising_edge(FPGA_CLK1_50))THEN
			IF(reset='1')then
				es<=e0;
			ELSE
				CASE ep IS
					WHEN e0 =>
						speed<="11";
						--Metele un counter para que repita varias veces a esa velocidad.
						es<=e1;
					WHEN e1 =>
						speed<="11";
						es<=e2;
					WHEN e2 =>
						speed<="10";
						es<=e3;
					WHEN e3 =>
						speed<="01";
						es<=e4;
					WHEN e4 =>
						es<=e4;
					WHEN e5 =>
						es<=e6;
					WHEN e6 =>
						es<=e6;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	go			<='1' 	when (ocupado='0' and (ep=e0 or ep=e1 or ep=e2 or ep=e3)) else '0'; --OJO! Esto es una PRUEBA. Solo queria transmitir una trama!!!
	
	PROCESS(FPGA_CLK1_50, ocupado, es)
	BEGIN
		if(falling_edge(ocupado))then
			ep<=es;
		end if;
	END PROCESS;


	inst1: masterSPI_RW
		Generic Map( nBits => numBits)
    	Port Map( 
		CLK_50 	=> FPGA_CLK1_50,
		RST 	=> reset,
		START 	=> go,
		SPEED	=> speed,
		CPOL 	=> '1',
		CPHA	=> '1',
		CS => "0",
		I_DATA => enviado, --Datos que envio.
		O_DATA => recibido, --Datos que recibo
		BUSY => ocupado,
		CONVST => CONVST,
		SCLK	=> SCK,
		SS1 => SS,
		SS2	=> open,
		MOSI	=> MOSI,
		MISO => MISO
	);
	
	LED<=recibido(numBits-1 downto numBits-8);
END a;