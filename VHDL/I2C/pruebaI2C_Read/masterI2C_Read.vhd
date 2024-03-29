library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity masterI2C_Read is
    Port( 
		CLK_50 	: IN  STD_LOGIC;			--Reloj a 50Mhz
		RST 	: IN  STD_LOGIC;
		ADD	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Address: Dirección del dispositivo.
		COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Command: Tipo de orden a enviar.
		DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Data: Información a enviar.
		GO		: IN  STD_LOGIC;								--Inicio.
		BUSY	: OUT STD_LOGIC;								--Ocupado. No puede atender nuevas peticiones.
		SCLK	: OUT STD_LOGIC;								--Señal de reloj para la sincronización del I2C. 100kHz.
		SDAT	: INOUT STD_LOGIC);							--Señal de datos generada. Trama a enviar al dispositivo.
end masterI2C_Read;


architecture a of masterI2C_Read is

	--Estados
	TYPE estados is (e0, e1, e2, e3, e4, e5, e6, e7, e8);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	
	--Señales de control de la máquina de estados
	signal idle 	: std_logic := '0';
	signal start 	: std_logic := '0';
	signal config	: std_logic := '0';
	signal cmd		: std_logic := '0';
	signal data		: std_logic := '0';
	signal ack 		: std_logic := '0';
	signal stop		: std_logic := '0';
	signal conf_rdy: std_logic := '0';
	signal cmd_rdy	: std_logic := '0';
	signal data_rdy: std_logic := '0';
	signal ack_tx	: std_logic := '0';							--Acknowledge transmission. Estado de ACK en el que el MAESTRO tiene que responder.
	signal ack_rx	: std_logic := '0';							--Acknowledge reception. Estado de ACK en el que el ESCLAVO tiene que responder.
	signal cBits	: integer range -1 to 7 :=7; 				--Contador de bits.
	signal sec		: std_logic := '0';--Senal para saber si es la segunda vez que pasa(RS-Repeated Start)
	

	--Generación de relojes
	signal clk200k : std_logic :='0'; 									--Reloj de 200kHz. Se usa para hacer las condiciones de inicio/parada y trama.
	signal clk100k	: std_logic :='0'; 									--Reloj de 100kHz. Para la sincronización. Señal SCL.
	signal cont		: std_logic_vector(7 downto 0) :="00000000";	--Lo uso para contar ciclos a la hora de hacer el reloj de 200kHz.
	
	--Señales de datos para la placa
	signal data_addr	: std_logic_vector(7 downto 0); --Dirección de la placa y bit de escritura.
	signal data_cmd	: std_logic_vector(7 downto 0); --Comando.
	signal data_info	: std_logic_vector(7 downto 0); --Datos asociados al comando.
	
	--Otras señales
	signal reset 	 : std_logic;
	signal sdat_gen : std_logic:='1'; --Trama generada para SDAT.
	signal hold 	 : std_logic:='1'; --Para ir al ritmo de SCLK y no del CLK. Mantiene el valor en el canal SDAT lo que dure el ciclo de SCLK.
	signal stopped  : std_logic:='0';
	signal started  : std_logic:='0';
	signal terminate: std_logic:='0';
	signal ack_rdy  : std_logic:='0'; --Para detener el ack durante un ciclo.
	signal count100 : std_logic_vector(8 downto 0):="000000000";

begin

	reset	  	 <= RST;
	--data_addr <= ADD; Esto va mas abajo, tengo que cambiar el ultimo bit.
	data_cmd  <= COM;
	data_info <= DAT;

	--Maquina de estados
	PROCESS(ep, reset, GO, conf_rdy, cmd_rdy, data_rdy, ack, stopped, sec, started, ack_rdy)--He añadido ACK a la lista de sensibilidad, pero no la trato.
	BEGIN
		IF(reset='1')then
			es<=e0;
		ELSE
			CASE ep IS
				WHEN e0 =>				--Estado de espera
					IF(GO='1')THEN
						es<=e1;
					ELSE
						es<=e0;
					END IF;
				WHEN e1=>				--Llamada para generar la condición de inicio
					IF(started='1')THEN
						es<=e2;
					ELSE
						es<=e1;
					END IF;
				WHEN e2=>				--Configurar
					IF(conf_rdy='1')THEN
						es<=e3;
					ELSE
						es<=e2;
					END IF;
				WHEN e3 =>				--ACK
					IF(ack_rdy='1')THEN
						IF(sec='0')THEN
							es<=e4;
						ELSE
							es<=e6;
						END IF;
					ELSE
						es<=e3;
					END IF;
				WHEN e4=>				--CMD
					IF(cmd_rdy='1')THEN
						es<=e5;
					ELSE
						es<=e4;
					END IF;
				WHEN e5=>				--ACK
					IF(ack_rdy='1')THEN
						es<=e1;
					ELSE
						es<=e5;
					END IF;
				WHEN e6=>				--DATA
					IF(data_rdy='1')THEN
						es<=e7;
					ELSE
						es<=e6;
					END IF;
				WHEN e7=>				--ACK
					--OJO. Hay que comprobar si quiero mas datos o si solo quiero recibir un Byte.
					IF(ack_rdy='1')THEN
						es<=e8;
					ELSE
						es<=e7;
					END IF;
				WHEN e8=>				--Llamada para generar la condición de parada.
					if (stopped='1')then
						es<=e0;
					else
						es<=e8;
					end if;
			END CASE;
		END IF;
	END PROCESS;
	
	--Cambio de estados.
	PROCESS(clk200k)
	BEGIN
		if(rising_edge(clk200k))then
			ep<=es;
		end if;
	END PROCESS;
	
	--Señales de control
	idle		<='1' when ep=e0 else '0';
	start		<='1' when ep=e1 else '0';
	config 	<='1' when ep=e2 else '0';
	cmd		<='1' when ep=e4 else '0';
	data	 	<='1' when ep=e6 else '0';
	ack_tx	<='1' when ep=e7 else '0';
	ack_rx	<='1' when ep=e3 or ep=e5 else '0';
	stop		<='1' when ep=e8 else '0';

	--Reloj de 200kHz
	process (CLK_50)
	begin
		if (rising_edge(CLK_50)) then
			if (cont<"1111101")then --Si es menor que 125
				clk200k<='0';
				cont<=cont+'1';
			else
				clk200k<='1';
				cont<=cont+'1';
			end if;
			if(cont="11111001")then 
				cont<="00000000";
			end if;
		end if;
	end process;

	--Reloj de 100kHz (Va a enviarse a SCLK)
	process(clk200k)
	begin
		if(rising_edge(clk200k))then
			clk100k<=not(clk100k);
		end if;
	end process;
	
	--Unidad de Control (UC)
	process (CLK_50)	--En este proceso voy a manipular exclusivamente la señal SDAT.
	begin
		if(rising_edge(CLK_50))then
			if(idle='1')then
				sdat_gen<='1';
				stopped<='0';
				terminate<='0';
			elsif(start='1')then					--Comienzo de la transmision: SDAT a 0 antes que SCLK
				ack_rdy<='0';
				if(sec='0')then 					--Si es la segunda vez que pasa, le pongo el bit de escritura.
					data_addr<=ADD;
				else
					--Ten en cuenta que en la primera ronda, el SDA ya esta a '1', pero en las segunda, despues del ACK, SDA vale '0'.
					--sdat_gen<='1';
					conf_rdy<='0'; --Tengo que volver a ponerlo a 0 para que vuelva a enviar el address
					data_addr<=ADD(7 downto 1)&'1';
				end if;
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<='0';
						started<='1';
					else
						sdat_gen<='1';
					end if;
				else
					sdat_gen<='1';
				end if;
				--Hay que inicializar las variables de rdy a 0.
			elsif(config='1')then
				if(clk100k='0')then
					if(clk200k='0')then
						sdat_gen<=data_addr(cBits);
						hold<='0';
					end if;
				elsif(clk100k='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(clk100k='0' and cBits=-1)then--aqui he metido el clk
					cBits<=7;
					conf_rdy<='1';
				end if;
			elsif(cmd='1')then
			ack_rdy<='0';
				if(clk100k='0')then
					if(clk200k='0')then
						sdat_gen<=data_cmd(cBits);
						hold<='0';
					end if;
				elsif(clk100k='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(clk100k='0'and cBits=-1)then--aqui he metido el clk
					cBits<=7;
					sec<='1';	--Activo sec para decir que ya ha pasado. En el siguiente estado e5 le toca ir al e0.
					started<='0';
					cmd_rdy<='1';
				end if;
			elsif(data='1')then
				--Aqui ten en cuenta que recibes datos, tienes que almacenarlos
				sdat_gen<='1'; --Para leer lo pongo en alta impedancia.
				--Del mismo modo tengo que contarlos, en algun momento tendre que salir del estado.
				if(clk100k='0')then
					if(clk200k='0')then
						data_info(cBits)<=SDAT;
						hold<='0';
					end if;
				elsif(clk100k='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(clk100k='0' and cBits=-1)then--aqui he metido el clk
					cBits<=7;
					sec<='1';	--Activo sec para decir que ya ha pasado. En el siguiente estado e5 le toca ir al e0.
					data_rdy<='1';
				end if;
			elsif(ack_rx='1')then
				--Cuestion de tiempos, tienes que quedarte un ciclo.
--				if(clk100k='0')then
--					if(clk200k='0')then
				sdat_gen<='1';
--				if(count100<"111110011")then
--					count100<=count100+'1';
--				else
--					count100<="000000000";
					ack_rdy<='1';
				--end if;
			elsif(ack_tx='1')then
				--Cuestion de tiempos, tienes que quedarte un ciclo.
--				if(clk100k='0')then
--					if(clk200k='0')then
--						sdat_gen<='1';
--						hold<='0';
--					end if;
--				elsif(clk100k='1' and hold='0')then
--					hold<='1';
--					ack_rdy<='1';
--				end if;
				sdat_gen<='1';
				if(count100<"111110011")then
					count100<=count100+'1';
				else
					count100<="000000000";
					ack_rdy<='1';
				end if;
			elsif(stop='1')then				--Fin de la transmision: SDAT a 1 despues de SCLK
				--Pongo las variables de control a 0 para la proxima trama.
				conf_rdy<='0';
				cmd_rdy<='0';
				data_rdy<='0';
				ack_rdy<='0';
				--He cambiado de estado, pero estoy a la espera de que el ACK del dispositivo termine, espero al siguiente ciclo para poner SDA a 0.
				if(clk100k='0')then
					terminate<='1';
					sdat_gen<='0';
				end if;
				--Si todavía sigue en el ciclo anterior, el del ACK, lo mantengo a 1 para que haya alta impedancia y pueda escribir 0 el dispositivo.
				if(clk100k='1' and terminate='0')then
					sdat_gen<='1';
				end if;
				--Si ya estoy en el siguiente ciclo, durante la bajada estaba 0, por lo que ahora hago la condición de parada subiendo SDA en el momento adecuado.
				if(clk100k='1' and clk200k='0' and terminate='1')then --Si estoy en el siguiente ciclo y en medio del bit de SCL que esta a 1, ya puedo subir SDA
					sdat_gen<='1';
					stopped<='1';
					started<='0';
				end if;
			end if;
		end if;
	end process;
		
	--Salidas
	SDAT <= 'Z' when sdat_gen = '1' else '0'; --En el bus I2C los '1' se representa con alta impedancia.
	SCLK 	<= '1' when ep=e0 else clk100k;
	BUSY	<= not(idle);

end a;