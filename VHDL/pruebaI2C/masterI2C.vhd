library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity masterI2C is
    Port( 
		CLK_50 	: IN  STD_LOGIC;			--Reloj a 50Mhz
		RST 	: IN  STD_LOGIC;
		ADD	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Address: Dirección del dispositivo.
		COM	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Command: Tipo de orden a enviar.
		DAT	: IN  STD_LOGIC_VECTOR (7 DOWNTO 0); 	--Data: Información a enviar.
		GO	: IN  STD_LOGIC;			--Inicio.
		BUSY	: OUT STD_LOGIC;			--Ocupado. No puede atender nuevas peticiones.
		SCLK	: OUT STD_LOGIC;			--Señal de reloj para la sincronización del I2C. 100kHz.
		SDAT	: INOUT STD_LOGIC);			--Señal de datos generada. Trama a enviar al dispositivo.
end masterI2C;


architecture a of masterI2C is

	--Estados
	TYPE estados is (e0, e1, e2, e3, e4, e5, e6, e7, e8);
	SIGNAL ep : estados :=e0; 	--Estado Presente
	SIGNAL es : estados; 		--Estado Siguiente
	
	--Señales de control de la máquina de estados
	signal idle 	: std_logic := '0';
	signal start 	: std_logic := '0';
	signal config	: std_logic := '0';
	signal cmd	: std_logic := '0';
	signal data	: std_logic := '0';
	signal ack 	: std_logic := '0';
	signal stop	: std_logic := '0';
	signal conf_rdy : std_logic := '0';
	signal cmd_rdy	: std_logic := '0';
	signal data_rdy : std_logic := '0';
	signal ack_st	: std_logic := '0';		--Acknowledge status. Indica que está en un estado del tipo ACK.
	signal cBits	: integer range -1 to 7 :=7; 	--Contador de bits.
	

	--Generación de relojes
	signal clk200k 	: std_logic :='0'; --Reloj de 200kHz. Se usa para hacer las condiciones de inicio/parada.
	signal clk100k	: std_logic :='0'; --Reloj de 100kHz. Para la sincronización. Señal SCL.
	signal cont	: std_logic_vector(7 downto 0) :="00000000";
	
	--Señales de datos para la placa
	signal data_addr	: std_logic_vector(7 downto 0); --Dirección de la placa y bit de escritura.
	signal data_cmd		: std_logic_vector(7 downto 0); --Comando.
	signal data_info	: std_logic_vector(7 downto 0); --Datos asociados al comando.
	
	--Otras señales
	signal reset 	: std_logic;
	signal sdat_gen : std_logic:='1'; --Trama generada para SDAT.
	signal hold 	: std_logic:='1'; --Para ir al ritmo de SCLK y no del CLK. Mantiene el valor en el canal SDAT lo que dure el ciclo de SCLK.


begin

	reset	  <= RST;
	data_addr <= ADD;
	data_cmd  <= COM;
	data_info <= DAT;

	--Maquina de estados
	PROCESS(ep, reset, GO, conf_rdy, cmd_rdy, data_rdy, ack)--He añadido ACK a la lista de sensibilidad, pero no la trato.
	BEGIN
		IF(reset='1')then
			es<=e0;
		ELSE
			CASE ep IS
				WHEN e0 =>				--Estado de espera
					--TO-DO: En e0 debería de sacarse una señal diciendo un "estoy libre"
					IF(GO='1')THEN
						es<=e1;
					ELSE
						es<=e0;
					END IF;
				WHEN e1=>				--Llamada para generar la condición de inicio
					es<=e2;
				WHEN e2=>				--Configurar
					IF(conf_rdy='1')THEN
						es<=e3;
					ELSE
						es<=e2;
					END IF;
				WHEN e3 =>				--ACK
					--Deberia generar una señal para que la unidad de control la lea y me diga si hay ACK o NACK.
					--TO-DO: Lo dejo para más tarde. Esto hay que hacerlo en los demás estados de comprobación.
					IF(ack='1')THEN
						es<=e4;
					ELSE
						es<=e4;
					END IF;
				WHEN e4=>				--CMD
					IF(cmd_rdy='1')THEN
						es<=e5;
					ELSE
						es<=e4;
					END IF;
				WHEN e5=>				--ACK
					IF(ack='1')THEN
						es<=e6;
					ELSE
						es<=e6;
					END IF;
				WHEN e6=>				--DATA
					IF(data_rdy='1')THEN
						es<=e7;
					ELSE
						es<=e6;
					END IF;
				WHEN e7=>				--ACK
					--Igual se puede hacer un control de errores, aunque sea por consola.
					IF(ack='1')THEN
						es<=e8;
					ELSE
						es<=e8;
					END IF;
				WHEN e8=>				--Llamada para generar la condición de parada.
					es<=e0;
			END CASE;
		END IF;
	END PROCESS;
	
	--Cambio de estados.
	PROCESS(clk100k)
	BEGIN
		--if(clk100k='1')then
		if(rising_edge(clk100k))then
			ep<=es;
		end if;
	END PROCESS;
	
	--Señales de control
	idle		<='1' when ep=e0 else '0';
	start		<='1' when ep=e1 else '0';
	config 		<='1' when ep=e2 else '0';
	cmd		<='1' when ep=e4 else '0';
	data	 	<='1' when ep=e6 else '0';
	ack_st		<='1' when ep=e3 or ep=e5 or ep=e7 else '0';
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
			if(start='1')then					--Comienzo de la transmision: SDAT a 0 antes que SCLK
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<='0';
					end if;
				end if;
				--Hay que inicializar las variables de rdy a 0.
			elsif(config='1')then
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<=data_addr(cBits);
						hold<='0';
					end if;
				elsif(clk100k='0' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(cBits=-1)then
					cBits<=7;
					conf_rdy<='1';
				end if;
			elsif(cmd='1')then
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<=data_cmd(cBits);
						hold<='0';
					end if;
				elsif(clk100k='0' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(cBits=-1)then
					cBits<=7;
					cmd_rdy<='1';
				end if;
			elsif(data='1')then
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<=data_info(cBits);
						hold<='0';
					end if;
				elsif(clk100k='0' and cBits>-1 and hold='0')then
					cBits<=cBits-1;
					hold<='1';
				end if;
				if(cBits=-1)then
					cBits<=7;
					data_rdy<='1';
				end if;
			elsif(ack_st='1')then
				if(clk200k='0')then
					--Si es correcto, el esclavo lo tiene que poner a 0, es decir, yo como maestro deberia leer un 0.
					sdat_gen<='1';
					--ack<=sdat_gen; El ack igual lo tengo que avisar desde el modulo prueba, que es el que puede leer el canal SDA de inout.
				end if;
				--TO-DO: Comprobacion de si el ack es 1.
			elsif(stop='1')then				--Fin de la transmision: SDAT a 1 despues de SCLK
				conf_rdy<='0';
				cmd_rdy<='0';
				data_rdy<='0';
				if(clk100k='1')then
					if(clk200k='0')then
						sdat_gen<='1';
					end if;
				end if;
			end if;
		end if;
	end process;
		
	--Salidas
	SDAT <= 'Z' when sdat_gen = '1' else '0'; --En el bus I2C los '1' se representa con alta impedancia.
	--SCLK <= 'Z' when clk100k = '1' else '0';
	--SDAT 	<= sdat_gen;
	SCLK 	<= clk100k;
	BUSY	<= not(idle);

end a;