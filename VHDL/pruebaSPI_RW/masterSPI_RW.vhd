library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY masterSPI_RW is
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
END masterSPI_RW;

architecture a of masterSPI_RW is
		
	--Señales Maquina de estados:
	TYPE estados is (e0, e1, e2, e3);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	
	--Señales de los relojes:
	signal cnt		: unsigned (5 downto 0) := (others => '0');
	signal CLK_25	: std_logic :='0';
	signal CLK_5	: std_logic :='0';
	signal CLK_1	: std_logic :='0';
	
	--Señales de control:
	signal idle 		: std_logic :='0';
	signal EOC 			: std_logic :='0'; --End Of Conversion
	signal conversion : std_logic :='0';
	signal transfer	: std_logic :='0'; --¿Hay transferencia en curso?
	signal finish		: std_logic :='0';
	signal comm_end	: std_logic :='0';
	signal stopped		: std_logic :='0';
	signal SPI_Ena		: std_logic :='0'; --Senal para la generacion del reloj.
	
	--Señales......
	signal SCLK_gen	: std_logic :='0';
	signal hold			: std_logic :='0';
	signal datIn		: std_logic_vector(nBits-1 downto 0);--Dato que quiero enviar
	signal datOut		: std_logic_vector(nBits-1 downto 0);
	signal n 			: integer range 0 to 24:=0;	--Probablemente se le pueda poner un nombre mas significativo.
	signal i 			: integer range 0 to 24:=0;--Probablemente se le pueda poner un nombre mas significativo.
	signal conv_time	: integer range 0 to 50:=0;
	signal quiet_time	: integer range 0 to  3:=0;
	signal bitCnt		: integer range -1 to nBits-1 :=nBits-1;

	
begin	
	--Asignaciones
	datIn<=I_DATA;

	--Proceso de la maquina de estados
	FSM_CLK: process(CLK_50)
	begin
		if(rising_edge(CLK_50))then
			ep<=es;
		end if;
	end process;
	
	--Señales de control
	idle 			<= '1' when ep=e0 else '0';
	conversion	<= '1' when ep=e1 else '0';
	transfer		<= '1' when ep=e2 else '0';
	finish		<= '1' when ep=e3 else '0';
	
	--Maquina de estados
	FSM: process(ep, RST, START, EOC, comm_end, stopped)
	begin
		if(RST='1')then
			es<=e0;
		else
			case ep is
				when e0 =>
					if(START='1' and stopped='0')then
						es<=e1;
					else
						es<=e0;
					end if;
				when e1 =>
					if(EOC='1')then
						es<=e2;
					else
						es<=e1;
					end if;
				when e2 =>
					if(comm_end='1')then
						es<=e3;
					else
						es<=e2;
					end if;
				when e3 =>
					if(stopped='1')then
						es<=e0;
					else
						es<=e3;
					end if;
			end case;		
		end if;
	end process;
	
	with SPEED select
		n <= 	0  when "01",	--25Mhz
				4  when "10",	-- 5MHZ
				24 when "11",	-- 1Mhz
				0  when others;
				
	--Senal de enable. Sirve para generar relojes.
	process(CLK_50)
	begin
		if rising_edge(CLK_50) then   
			if (i  >= n) then
				SPI_Ena <= '1';
				i <= 0;
			else
				SPI_Ena <= '0';
				i	<= i + 1;
			end if;
		end if;
	end process;
     
				
	
	--Demultiplexor: Seleccion de SSN
	SS1 <= NOT(transfer) when CS="0" else '1';
	SS2 <= NOT(transfer) when CS="1" else '1';
	BUSY<='0' when ep=e0 else '1';
	
	process(CLK_50)
	begin
		if rising_edge(CLK_50) then --Trabajo al ritmo del reloj del sistema
			if(conversion='1')then
					--Pongo la senal de CONVST a '0' durante 600ns. Espero 50ns mas para que se termine la conversion.
					if(conv_time<30)then --Menor que 30
						CONVST<='0';
					else
						CONVST<='1';
					end if;
					if(conv_time=32)then --Igual a 32. Desde 0 a 32 son 33 iteraciones. 33*20ns=660ns
						CONVST<='1';
						EOC<='1';
					end if;
					conv_time<=conv_time+1;
				end if;
			if (SPI_Ena='1') then          --Esta es la señal de ENABLE para procesar los pasos del SPI.
				SCLK_gen	<= NOT(SCLK_gen);	--Genero el CLK a partir del enable.

			--A partir de aqui vienen los procesos del protocolo SPI (Escribir MOSI, leer MISO, contar los bits, controlar las senales...)
				if(idle='1')then
					--poner todo a CERO.
					comm_end<='0';
					stopped<='0';
					CONVST<='1';
					EOC<='0';
					conv_time<=0;
					quiet_time<=0;
				elsif(transfer='1')then
					--Se supone que la línea SSN se ha puesto a 0 en el codigo de más arriba, y el CONVST tambien.
					if (SCLK_gen='1' and hold='0' and comm_end='0')then
						MOSI<=datIn(bitCnt);
						datOut(bitCnt)<=MISO;
						bitCnt<=bitCnt-1;
						hold<='1';
					else
						hold<='0';
						if (bitCnt=-1)then
							bitCnt<=nBits-1;
							comm_end<='1';
						end if;
					end if;
					O_DATA<=datOut;
				elsif(finish='1')then
					if(quiet_time<3)then
						quiet_time<=quiet_time+1;
					else
						stopped<='1';
					end if;
				end if;
			end if;
		end if;
	end process;
	SCLK<= SCLK_gen when ep=e2 else '0';
end a;