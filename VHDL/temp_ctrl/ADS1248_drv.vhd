library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY ADS1248_drv is
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
END ADS1248_drv;

architecture a of ADS1248_drv is
		
	--SeÃ±ales Maquina de estados:
	TYPE estados is (e0, e1, e2, e3, e4, e5, e6);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	
	--SeÃ±ales de los relojes:
	signal cnt		: unsigned (5 downto 0) := (others => '0');
	
	--SeÃ±ales de control:
	signal idle 		: std_logic :='0';
	signal configurate :std_logic :='0';
	signal EOC 			: std_logic :='0'; --End Of Conversion
	signal conversion : std_logic :='0';
	signal transfer	: std_logic :='0'; --Â¿Hay transferencia en curso?
	signal finish		: std_logic :='0';
	signal preparar	: std_logic :='0';
	signal tramaBlanca: std_logic :='0';
	signal comm_end	: std_logic :='0';
	signal configured	: std_logic :='0';
	signal stopped		: std_logic :='0';
	signal primera		: std_logic :='0';
	signal blancos		: std_logic :='0';	
	signal SPI_Ena		: std_logic :='0'; --Senal para la generacion del reloj.
	
	--SeÃ±ales......
	signal SCLK_gen	: std_logic :='0';
	signal hold			: std_logic :='0';
	signal datIn		: std_logic_vector(31 downto 0);--Dato que quiero enviar
	signal datOut		: std_logic_vector(31 downto 0);
	signal n 			: integer range 0 to 24:=0;	--Probablemente se le pueda poner un nombre mas significativo.
	signal i 			: integer range 0 to 24:=0;--Probablemente se le pueda poner un nombre mas significativo.
	signal conv_time	: integer range 0 to 10255010:=0;
	signal quiet_time	: integer range 0 to  250000:=0;
	--signal bitCnt		: integer range -1 to nBits-1 :=nBits-1;
	
	--Quitas bitCnt y metes estas:
	signal confBitsCnt : integer range -1 to 119 :=119;
	signal dataBitsCnt : integer range -1 to 32 :=32;
	signal confIn		 : std_logic_vector(119 downto 0);--Dato que quiero enviar
	signal confOut		 : std_logic_vector(119 downto 0);--Dato que recibo. Realmente no me interesa
	signal transfer_pause:std_logic:='0';
	signal cs1 : std_logic:='0';
	signal delay : std_logic :='0';
	signal cont_parcial : integer range -1 to 30:=0;
	
	signal preparacion	 : std_logic_vector(23 downto 0):=x"4A0000";--Dato que recibo. Realmente no me interesa
	signal cont_prep : integer range -1 to 23 :=23;	
	signal ceros	 : std_logic_vector(15 downto 0):=x"0000";--Dato que recibo. Realmente no me interesa
	signal cont_ceros : integer range -1 to 15 :=15;
	signal prep_enviado :std_logic:='0';
	signal blancosEnviados :std_logic:='0';
		
begin	
	--Asignaciones
	--datIn<=I_DATA;
	confIn<=IN_CONF;
	datIn<=IN_RD_NOP;

	--Proceso de la maquina de estados
	FSM_CLK: process(CLK_50)
	begin
		if(rising_edge(CLK_50))then
			ep<=es;
		end if;
	end process;
	
	--SeÃ±ales de control
	idle 			<= '1' when ep=e0 else '0';
	configurate <= '1' when ep=e1 else '0';
	conversion	<= '1' when ep=e2 else '0';
	transfer		<= '1' when ep=e3 else '0';
	finish		<= '1' when ep=e4 else '0';
	preparar		<= '1' when ep=e5 else '0';
	tramaBlanca	<= '1' when ep=e6 else '0';

	
	--Maquina de estados
	FSM: process(ep, RST, START, EOC, comm_end, stopped, configured, primera, blancos)
	begin
		if(RST='1')then
			es<=e0;
		else
			case ep is
				when e0 => --idle
					if(START='1' and blancos='0')then --and stopped='0' 
						es<=e1;
					else
						es<=e0;
					end if;
				when e1 => --configurate
					if(configured='1')then
						es<=e2;
					else
						es<=e1;
					end if;
				when e2 => --conversion
					if(EOC='1')then
						es<=e3;
					else
						es<=e2;
					end if;
				when e3 => --transfer
					if(comm_end='1')then
						es<=e4;
					else
						es<=e3;
					end if;
				when e4 => --finish
					if(stopped='1')then
						es<=e5;
					else
						es<=e4;
					end if;
				when e5 => --Envio primera trama
					if(primera='1')then
						es<=e6;
					else
						es<=e5;
					end if;
				when e6 => --Envio blancos
					if(blancos='1')then
						es<=e0;
					else
						es<=e6;
					end if;
			end case;		
		end if;
	end process;
	
	with SPEED select			-- Device limit is 4Mhz.
		n <= 	6  when "01",	-- 4Mhz
				12 when "10",	-- 2MHZ
				24 when "11",	-- 1Mhz
				24 when others;
				
	--Enable signal. Used for clock (SCLK) generation.
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

	
	--Demux: Used for Chip Select (CS)
	--SS1 <= NOT(transfer) when CS="00" else '1';
	cs1 <= '0'when (configurate='1' and transfer_pause='0') or (transfer='1' and transfer_pause='0') or (preparar='1' and transfer_pause='0') or (tramaBlanca='1' and transfer_pause='0') else '1';
	
	
	--NOT((transfer xor transfer_pause) and (configurate xor transfer_pause)) when CS="00" else '1';
	SS1<=cs1;
	SS2 <= NOT(transfer) when CS="01" else '1';
	SS3 <= NOT(transfer) when CS="10" else '1';
	
	BUSY<='0' when ep=e0 else '1';
	
	
	
	process(CLK_50, delay)
	begin
		if rising_edge(CLK_50) then --Trabajo al ritmo del reloj del sistema
			if(conversion='1')then
					--Pongo la senal de CONVST a '0' durante 100us.
					MOSI<='0';--Lo acabo de agregar
					if(conv_time<5000 or conv_time>250000)then
						CONVST<='0';
					else
						CONVST<='1';
					end if;
--					if(conv_time=250000)then --5ms a '1' y lo bajo.
--						CONVST<='0';
--					end if;
					if(conv_time=10255000)then
						EOC<='1';
						--conv_time<=0;
					end if;
					conv_time<=conv_time+1;
				end if;
			--INICIO SENTENCIA: Probablemente esto que comento pueda ir en un process independiente.
			if (SPI_Ena='1') then          --Esta es la seÃ±al de ENABLE para procesar los pasos del SPI.
				SCLK_gen	<= NOT(SCLK_gen);	--Genero el CLK a partir del enable.
			--FIN SENTENCIA

			--A partir de aqui vienen los procesos del protocolo SPI (Escribir MOSI, leer MISO, contar los bits, controlar las senales...)
				if(idle='1')then
					--poner todo a CERO.
					comm_end<='0';
					stopped<='0';
					CONVST<='0';
					configured<='0';
					primera<='0';
					blancos<='0';
					prep_enviado <='0';
					blancosEnviados<='0';
					EOC<='0';
					conv_time<=0;
					quiet_time<=0;
					delay<='0';
					cont_parcial<=0;
				elsif(configurate='1')then
					--Aqui tienes que hacer una transferencia de 80bits
					--Tengo que tener el CS a 0 y el CONVST a '1'
					CONVST<='1';
					if(delay='0')then
						transfer_pause<='0';
						if (SCLK_gen='1' and hold='0' and configured='0')then
							MOSI<=confIn(confBitsCnt);
							confOut(confBitsCnt)<=MISO;
							confBitsCnt<=confBitsCnt-1;
							cont_parcial<=cont_parcial+1;
							hold<='1';
						else
							hold<='0';
							if (confBitsCnt=-1)then
								confBitsCnt<=119;
								configured<='1';
								CONVST<='0';
								MOSI<='0';--Lo acabo de agregar
								--Anado
								delay<='0';
								cont_parcial<=0;
								quiet_time<=0;
								transfer_pause<='0';
							end if;
						end if;
					end if;
					if(cont_parcial=24)then
						if(quiet_time<10)then
								transfer_pause<='1';
								delay<='1';
								quiet_time<=quiet_time+1;
							else
								delay<='0';
								cont_parcial<=0;
								quiet_time<=0;
								transfer_pause<='0';
							end if;
					end if;
					OUT_CONF<=confOut; --No me interesa					
				elsif(transfer='1')then
					transfer_pause<='0';
					--Se supone que la lÃ­nea SSN se ha puesto a 0 en el codigo de mÃ¡s arriba, y el CONVST tambien.
					if (SCLK_gen='1' and hold='0' and comm_end='0')then
						--if(dataBitsCnt<32)then
							MOSI<=datIn(dataBitsCnt);
							datOut(dataBitsCnt)<=MISO;
						--end if;
							dataBitsCnt<=dataBitsCnt-1;
							hold<='1';
					else
						hold<='0';
						if (dataBitsCnt=-1)then
							dataBitsCnt<=32;
							MOSI<='0';--Lo acabo de agregar
							transfer_pause<='1';
							comm_end<='1';
						end if;
					end if;
					OUT_RD_NOP<=datOut;
				elsif(finish='1')then
					MOSI<='0';--Lo acabo de agregar
					if(quiet_time<2500)then
						quiet_time<=quiet_time+1;
					else
						transfer_pause<='0';
						quiet_time<=0;
						stopped<='1';
					end if;
				elsif(preparar='1')then
					if (SCLK_gen='1' and hold='0' and prep_enviado='0')then
						MOSI<=preparacion(cont_prep);
						--confOut(confBitsCnt)<=MISO;
						cont_prep<=cont_prep-1;
						hold<='1';
					else
						hold<='0';
						if (cont_prep=-1)then
							cont_prep<=23;
							MOSI<='0';--Lo acabo de agregar
							--Anado
							delay<='0';
							quiet_time<=0;
							prep_enviado<='1';
							transfer_pause<='1';
						end if;
					end if;
					if(quiet_time<500 and prep_enviado='1')then
						MOSI<='0';
						transfer_pause<='1';
						quiet_time<=quiet_time+1;
					elsif(quiet_time=500 and prep_enviado='1')then
						transfer_pause<='0';
						quiet_time<=0;
						primera<='1';
					end if;
				elsif(tramaBlanca='1')then
					if (SCLK_gen='1' and hold='0' and blancosEnviados='0')then
						MOSI<=ceros(cont_ceros);
						--confOut(confBitsCnt)<=MISO;
						cont_ceros<=cont_ceros-1;
						hold<='1';
					else
						hold<='0';
						if (cont_ceros=-1)then
							cont_ceros<=15;
							MOSI<='0';--Lo acabo de agregar
							--Anado
							delay<='0';
							quiet_time<=0;
							blancosEnviados<='1';
							transfer_pause<='1';
						end if;
					end if;
					if(quiet_time<1500 and blancosEnviados='1')then
						MOSI<='0';
						transfer_pause<='1';
						quiet_time<=quiet_time+1;
					elsif(quiet_time=1500 and blancosEnviados='1')then
						transfer_pause<='0';
						quiet_time<=0;
						blancos<='1';
					end if;
				end if;
			end if;
		end if;
	end process;
	--SCLK<= SCLK_gen when (ep=e1 or ep=e3) and transfer_pause='0'  else '0';
	SCLK<= SCLK_gen when (cs1='0') else '0';
	
end a;