library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity masterI2C_RW is
    Port( 
		CLK_50: IN  STD_LOGIC;								--Reloj a 50Mhz
		RST 	: IN  STD_LOGIC;
		ADD	: IN  STD_LOGIC_VECTOR (6 DOWNTO 0); 	--Address: Dirección del dispositivo.
		COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Command: Tipo de orden a enviar.
		DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Data: Información a enviar.
		GO		: IN  STD_LOGIC;								--Inicio.
		RW		: IN  STD_LOGIC;								--Bit de L/E. 0=Write; 1=Read;
		SPEED : IN  STD_LOGIC;								--Velocidad de reloj. 0=100kHz; 1=400kHz.
		RDNUM : IN  INTEGER;									--Numero de registros a leer.
		BUSY	: OUT STD_LOGIC;								--Ocupado. No puede atender nuevas peticiones.
		DOUT	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);	--Salida de datos. Cuando hay operación de lectura saca ese resultado.
		SCLK	: OUT STD_LOGIC;								--Señal de reloj para la sincronización del I2C. 100kHz.
		SDAT	: INOUT STD_LOGIC);							--Señal de datos generada. Trama a enviar al dispositivo.
end masterI2C_RW;


architecture a of masterI2C_RW is

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
	signal ack_tx	: std_logic := '0';				--Acknowledge transmission. Estado de ACK en el que el MAESTRO tiene que responder.
	signal ack_rx	: std_logic := '0';				--Acknowledge reception. Estado de ACK en el que el ESCLAVO tiene que responder.
	signal ack_txrx	: std_logic := '0';
	signal cBits	: integer range -1 to 7 :=7; 	--Contador de bits.
	signal sec		: std_logic := '0';				--Senal para saber si es la segunda vez que pasa(RS-Repeated Start)
	

	--Generación de relojes
	signal scl2x 	: std_logic :='0'; 									--Reloj al doble de la frecuencia de scl1x. Se usa para hacer las condiciones de inicio/parada y trama.
	signal scl1x	: std_logic :='0'; 									--Reloj de 100 o 400 kHz. Para la sincronización. Señal SCL.
	signal cont		: std_logic_vector(7 downto 0) :="00000000";	--Lo uso para contar ciclos a la hora de hacer el reloj de 2x.
	signal halfCont: std_logic_vector(7 downto 0) :="01111101"; --Mitad del contador. Ciclo a '1'. Inicializado a 125.
	signal maxCont : std_logic_vector(7 downto 0) :="11111001"; --Máximo del contador. Indica cuando reiniciar. Inicializado a 249.
	
	--Señales de datos para la placa
	signal data_addr	: std_logic_vector(7 downto 0); --Dirección de la placa y bit de escritura.
	signal data_cmd	: std_logic_vector(7 downto 0); --Comando.
	signal data_info	: std_logic_vector(7 downto 0); --Datos asociados al comando.
	signal data_reg	: std_logic_vector(7 downto 0); --Datos que recibo del dispositivo.
	signal le			: std_logic;						  --Lectura/Escritura.
	
	--Otras señales
	signal reset 	 : std_logic;
	signal sdat_gen : std_logic:='1'; --Trama generada para SDAT.
	signal hold 	 : std_logic:='1'; --Para ir al ritmo de SCLK y no del CLK. Mantiene el valor en el canal SDAT lo que dure el ciclo de SCLK.
	signal stopped  : std_logic:='0';
	signal started  : std_logic:='0';
	signal terminate: std_logic:='0';
	signal terminated: std_logic:='0';
	signal ack_rdy  : std_logic:='0'; --Para detener el ack durante un ciclo.
	signal count100 : std_logic_vector(8 downto 0):="000000000";
	signal fullCont : std_logic_vector(8 downto 0):="111110011"; --499. El ciclo completo de 100kHz
	signal rdnReg	 : integer range 0 to 9:=0;		--"Readen Registers". Numero de registros leidos.

begin

	--IDEA: Igual estas senales tienen que cambiar solo cuando la maquina este disponible, para que no se modifiquen en mitad de una operacion.
	reset	  	 <= RST;
	data_cmd  <= COM;
	data_info <= DAT;
	le <= RW;

	--Maquina de estados
	PROCESS(ep, reset, GO, conf_rdy, cmd_rdy, data_rdy, ack, stopped, sec, started, ack_rdy, le)--He añadido ACK a la lista de sensibilidad.
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
				WHEN e1=>					--Llamada para generar la condición de inicio
					IF(started='1')THEN	--Started se pone a '1' cuando ha hecho la condicion de inicio.
						es<=e2;
					ELSE
						es<=e1;
					END IF;
				WHEN e2=>				--Address+RW. Envio la direccion y la operacion a realizar (leer o escribir).
					IF(conf_rdy='1')THEN
						es<=e3;
					ELSE
						es<=e2;
					END IF;
				WHEN e3 =>				--ACK
					IF(ack_rdy='1')THEN
						--IF(ACK='0')THEN
							IF(le='0')THEN --Escritura
								es<=e4;
							ELSE				--Lectura
								IF(sec='0')THEN
									es<=e4;
								ELSE
									es<=e6;
								END IF;
							END IF;
						--ELSE
							--es<=e8;
						--END IF;
					ELSE
						es<=e3;
					END IF;
				WHEN e4=>				--CMD (Mas que comando, es el registro al que accedo). Convendria cambiar el nombre de estas variables.
					IF(cmd_rdy='1')THEN
						es<=e5;
					ELSE
						es<=e4;
					END IF;
				WHEN e5=>				--ACK
					--IF(ACK='0')THEN
						IF(ack_rdy='1')THEN
							IF(le='0')THEN --Escritura
								es<=e6;
							ELSE
								es<=e1;
							END IF;
						ELSE
							es<=e5;
						END IF;
					--ELSE
						--es<=e8;
					--END IF;
				WHEN e6=>				--DATA
					IF(data_rdy='1')THEN
						es<=e7;
					ELSE
						es<=e6;
					END IF;
				WHEN e7=>				--ACK
					--OJO. Hay que comprobar si quiero mas datos o si solo quiero recibir un Byte.
					IF(ack_rdy='1')THEN
						IF(le='0')THEN
							es<=e8;
						ELSE
							IF(ack='0')THEN--Quiero que siga devolviendome mas datos. Me pasa el siguiente registro.
								es<=e6;
							ELSE				--No quiero mas datos, quiero terminar la trama.
								es<=e8;
							END IF;
						END IF;
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
	PROCESS(CLK_50)
	BEGIN
		if(rising_edge(CLK_50))then
			ep<=es;
		end if;
	END PROCESS;
	
	--Señales de control
	idle		<='1' when ep=e0 else '0';
	start		<='1' when ep=e1 else '0';
	config 	<='1' when ep=e2 else '0';
	cmd		<='1' when ep=e4 else '0';
	data	 	<='1' when ep=e6 else '0';
	ack_txrx	<='1' when ep=e3 or ep=e5 or ep=e7 else '0';
	stop		<='1' when ep=e8 else '0';

	--Reloj de 200kHz
	process (CLK_50)
	begin
		if (rising_edge(CLK_50)) then
			if (cont<halfCont)then --Si es menor que la mitad.
				scl2x<='0';
				cont<=cont+'1';
			else
				scl2x<='1';
				cont<=cont+'1';
			end if;
			if(cont=maxCont)then 
				cont<="00000000";
			end if;
		end if;
	end process;

	--Reloj de 100kHz (Va a enviarse a SCLK)
	process(scl2x)
	begin
		if(rising_edge(scl2x))then
			scl1x<=not(scl1x);
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
				ack<='0';
				rdnReg<=0;
			elsif(start='1')then					--Comienzo de la transmision: SDAT a 0 antes que SCLK
				if(SPEED='0')then
					halfCont<="01111101";	--125.
					maxCont<="11111001";		--249.
					fullCont<="111110011";	--499. Ciclo completo de 100kHz
				else
					halfCont<="00100000";	--32.
					maxCont<="00111111";		--63.
					fullCont<="001111110";	--126. Ciclo completo de "400kHz". 390kHz reales.
				end if;
				ack_rdy<='0';
				--Preparo el siguiente dato a enviar.
				if(le='0')then
					data_addr<=ADD & le;
				else
					if(sec='0')then 					--Si es la segunda vez que pasa, le pongo el bit de escritura.
						data_addr<=ADD & '0';
					else
						conf_rdy<='0'; --Tengo que volver a ponerlo a 0 para que vuelva a enviar el address
						data_addr<=ADD & le;
					end if;
				end if;
				--Hago la condicion de inicio.
				if(scl1x='1')then
					if(scl2x='0')then
						sdat_gen<='0';
						terminated<='1';
					else
						sdat_gen<='1';
					end if;
				else
					if(terminated='1')then
						if(scl2x='0')then
							started<='1';
							terminated<='0';
						end if;
					else
						sdat_gen<='1';
					end if;
				end if;
				--Hay que inicializar las variables de rdy a 0.
			elsif(config='1')then
				terminated<='0';
				ack_rdy<='0';
				ack<='0';
				if(scl1x='0')then
					if(scl2x='1')then
						if(cBits=-1)then--aqui he metido el clk,  de lo contrario el ultimo bit dura menos y cambia los tiempos de la trama
							cBits<=7;
							conf_rdy<='1';
						end if;
					else
						sdat_gen<=data_addr(cBits);
						hold<='0';
					end if;
				elsif(scl1x='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
			elsif(cmd='1')then
			ack_rdy<='0';
			ack<='0';
				if(scl1x='0')then
					if(scl2x='1')then
						if(cBits=-1)then
							cBits<=7;
							if(le='1')then
								sec<='1';	--Activo sec para decir que ya ha pasado. En el siguiente estado e5 le toca ir al e0.
							else
								sec<='0';
							end if;
							cmd_rdy<='1';
						end if;
					else
						sdat_gen<=data_cmd(cBits);
						hold<='0';
					end if;
				elsif(scl1x='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
			elsif(data='1')then
				ack_rdy<='0';
				ack<='0';
				if(scl1x='0')then
					if(scl2x='1')then
						if(cBits=-1)then
							cBits<=7;
							data_rdy<='1';
						end if;
					else
						if (le='0')then	--Si escribo, lo mando hacia sdat
							sdat_gen<=data_info(cBits);
						else			--Si leo, "pincho" la linea SDAT y lo almaceno en mi vector.
							sdat_gen<='1';
							data_reg(cBits)<=SDAT;
						end if;
						hold<='0';
					end if;
				elsif(scl1x='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
			elsif(ack_txrx='1')then
				started<='0';
				if(scl1x='0')then
					if(scl2x='1')then
						if(cBits=6)then
							cBits<=7;
							ack_rdy<='1';
							if(ep=e7 and le='1')then
								rdnReg<=rdnReg+1;
							end if;
						end if;
					else
						if(ep=e7)then
							data_rdy<='0';
							if (le='0')then	--Si escribo, lo mando hacia sdat
								ack<='1';
							else			--Si estoy en opcion de lectura, mientras tenga elementos que leer, sigo.
								if(rdnReg<RDNUM-1)then
									ack<='0';
								else
									ack<='1';
								end if;
							end if;
						else
							ack<='1';
						end if;
						hold<='0';
					end if;
				elsif(scl1x='1' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(config='0' and ack='0' and ep=e3)then
					sdat_gen<=data_addr(0);
				elsif(cmd='0' and ack='0' and ep=e5)then
					sdat_gen<=data_cmd(0);
				elsif(le='0' and data='0' and ack='0' and ep=e7)then
					sdat_gen<=data_info(0);
				elsif(le='1' and data_rdy='1' and ep=e7)then
					sdat_gen<='1';
				else
					sdat_gen<=ack;	--Antes solo esto sin condiciones.
				end if;		
			elsif(stop='1')then				--Fin de la transmision: SDAT a 1 despues de SCLK
				--Pongo las variables de control a 0 para la proxima trama.
				conf_rdy<='0';
				cmd_rdy<='0';
				data_rdy<='0';
				ack_rdy<='0';
				ack<='0';
				sec<='0';
				if(scl1x='0')then
					if(terminate='1')then
						stopped<='1';
						sdat_gen<='1';
					elsif(scl2x='1')then
						sdat_gen<='1';
					elsif(scl2x='0')then
						sdat_gen<='0';--Lo pongo aqui para que despues del ack se quede a 0.
					end if;
				else
					if(scl2x='0')then
						sdat_gen<='1';
						terminate<='1';
					end if;
				end if;
			end if;
		end if;
	end process;
		
	--Salidas
	SDAT <= 'Z' when sdat_gen = '1' or terminate='1' else '0'; --En el bus I2C los '1' se representa con alta impedancia.
	SCLK 	<= '1' when ep=e0 or terminate='1' else scl1x;
	BUSY	<= not(idle);
	DOUT <= data_reg;

end a;