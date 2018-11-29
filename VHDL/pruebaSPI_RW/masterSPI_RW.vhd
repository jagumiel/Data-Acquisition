library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY masterSPI_RW is
	PORT(
			CLK_50		: IN  STD_LOGIC;
			RST			: IN  STD_LOGIC;
			START			: IN  STD_LOGIC;
			SPEED			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			CPOL			: IN  STD_LOGIC;							--Polaridad
			CPHA			: IN  STD_LOGIC;							--Fase
			CS				: IN  STD_LOGIC_VECTOR(0 DOWNTO 0); --Chip Select
			I_DATA		: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			BUSY			: OUT STD_LOGIC;
			SCLK			: OUT STD_LOGIC;
			SS1			: OUT STD_LOGIC;
			SS2			: OUT STD_LOGIC;
			MOSI			: OUT STD_LOGIC;
			MISO			: IN  STD_LOGIC);	
END masterSPI_RW;

architecture a of masterSPI_RW is
	
	--Señales Maquina de estados:
	TYPE estados is (e0, e1, e2);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	
	--Señales de los relojes:
	signal cnt	: unsigned (5 downto 0) := (others => '0');
	signal CLK_25: std_logic :='0';
	signal CLK_5	: std_logic :='0';
	signal CLK_1	: std_logic :='0';
	
	--Señales de control:
	signal idle 	: std_logic :='0';
	signal transfer: std_logic :='0'; --¿Hay transferencia en curso?
	signal finish	: std_logic :='0';
	signal comm_end: std_logic :='0';
	signal stopped	: std_logic :='0';
	signal SPI_Ena	: std_logic :='0'; --No se si deberia ir en la lista de señales de control.
	
	--Señales......
	signal n : integer range 0 to 24:=0;	--Probablemente se le pueda poner un nombre mas significativo.
	signal i : integer range 0 to 24:=0;--Probablemente se le pueda poner un nombre mas significativo.
	signal SCLK_gen : std_logic :='0';
	signal datIn	: std_logic_vector(7 downto 0);
	signal bitCnt	: integer range -1 to 7 :=0;
	signal hold	:std_logic :='0';
	
	
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
	idle 		<= '1' when ep=e0 else '0';
	transfer	<= '1' when ep=e1 else '0';
	finish	<= '1' when ep=e2 else '0';
	
	--Maquina de estados
	FSM: process(ep, RST)
	begin
		if(RST='1')then
			es<=e0;
		else
			case ep is
				when e0 =>
					if(START='1')then
						es<=e1;
					else
						es<=e0;
					end if;
				when e1 =>
					if(comm_end='1')then
						es<=e2;
					else
						es<=e1;
					end if;
				when e2 =>
					if(stopped='1')then
						es<=e1;
					else
						es<=e2;
					end if;
			end case;		
		end if;
	end process;
	
	--Multiplexor: Seleccion de la velocidad del reloj
--	with SPEED select
--		SCLK <= 	CLK_50 when "00", --Desde la entidad superior habrá que sacarlo o ponerlo a 0/1, según el caso.
--					CLK_25 when "01",
--					CLK_5	 when "10",
--					CLK_1  when "11",
--					'0'  when others;
	with SPEED select
		n <= 	0 when "01",
				4 when "10",
				24 when "11",
				0 when others;
				
				
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
	
	process(CLK_50)
	begin
		if rising_edge(CLK_50) then --Trabajo al ritmo del reloj del sistema
			if (SPI_Ena='1') then          --Esta es la señal de ENABLE para procesar los pasos del SPI.
				SCLK_gen	<= NOT(SCLK_gen);	--Genero el CLK a partir del enable.

			--...here do the other SPI processes... (FSM to write MOSI, read MISO, count the bits, maybe control !CS...)
				if(idle='1')then
					--poner todo a CERO.
					BUSY<='0';
				elsif(transfer='1')then
					BUSY<='1';
					--Se supone que la línea SSN se ha puesto a 0 en el codigo de más arriba.
					if (SCLK_gen='1' and hold='0')then
						MOSI<=datIn(bitCnt);
						bitCnt<=bitCnt-1;
						hold<='1';
					else
						hold<='0';
						if (bitCnt=-1)then
							bitCnt<=7;
							comm_end<='1';
						end if;
					end if;
				elsif(finish='1')then
					BUSY<='0';
					stopped<='1';
				end if;
			end if;
		end if;
	end process;
	
	--Relojes (Si estoy generando con la señal de enable, esto igual sobra).
	process(CLK_50)
	begin
		if rising_edge(CLK_50) then   
			cnt	<= cnt + 1;
			--25MHz
			if cnt rem 1 = 0 then
				CLK_25   <= NOT(CLK_25);
			end if;
			--5MHz
			if cnt rem 5 = 0 then
				CLK_5   <= NOT(CLK_5);
			end if;
			--1MHz
			if cnt rem 25 = 0 then
				CLK_1   <= NOT(CLK_1);
			end if;
			--Reset
			if(cnt>49)then
				cnt<="000001";
			end if;
		end if;
	end process;

end a;