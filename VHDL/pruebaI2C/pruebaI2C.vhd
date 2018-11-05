library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity pruebaI2C is
    Port( 
			FPGA_CLK1_50 	: IN  STD_LOGIC;
			KEY 				: IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
			GPIO_0 			: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			SCL				: OUT STD_LOGIC;
			SDA				: INOUT STD_LOGIC
			);
end pruebaI2C;


architecture a of pruebaI2C is

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
	signal conf_rdy: std_logic := '0';
	signal cmd_rdy : std_logic := '0';
	signal data_rdy: std_logic := '0';
	signal ack		: std_logic := '0';
	signal cBits	: integer range 0 to 7 :=7; --Contador de bits.
	

	--Generación de relojes
	signal clk200k : std_logic :='0';
	signal clk100k	: std_logic :='0';
	signal cont		: std_logic_vector(7 downto 0) :="00000000";
	
	--Señales de datos para la placa
	signal cmd_config : std_logic_vector(7 downto 0) := "00000011"; --Configura los pines de la placa. Cuáles son de entrada y cuales de salida. (03h)
	signal cmd_write	: std_logic_vector(7 downto 0) := "00000001"; --Dice que el dato siguiente es para escribir en la salida.
	signal data_addr	: std_logic_vector(7 downto 0) := "11100100"; --Dirección de la placa y bit de escritura.
	signal data_ports : std_logic_vector(7 downto 0) := "00001111"; --Digo los puertos que son entradas y los que son salidas. (0=out; 1=in;)
	signal data_out	: std_logic_vector(7 downto 0) := "10101010"; --Digo donde quiero escribir un uno. Sólo lo hará en las que se configuren como salida.
	--Con esta configuracion sacaré voltaje por los pines 1 y 3, el resto se mantendrá a 0, ya que están a 0 o configurados como entrada.
	
	--Otras señales
	signal reset : std_logic;
	signal sda_gen : std_logic:= '1'; --Trama generada para SDA.


begin

	reset<=not(Key(0));

	--Maquina de estados
	PROCESS (clk200k, reset)
	BEGIN
		IF(reset='1')then
			es<=e0;
		ELSIF(rising_edge(clk200k))THEN
			CASE ep IS
				WHEN e0 =>				--Estado de espera
					IF(idle='1')THEN
						es<=e0;
					ELSE
						es<=e1;
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
					IF(ack='1')THEN
						es<=e0;
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
						es<=e0;
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
		ep<=es;
	END PROCESS;
	
	--Señales de control
	start		<='1' when ep=e1 else '0';
	config 	<='1' when ep=e2 else '0';
	cmd		<='1' when ep=e4 else '0';
	data	 	<='1' when ep=e6 else '0';
	
	
	

	process (FPGA_CLK1_50) --Reloj de 200kHz
	begin
		if (rising_edge(FPGA_CLK1_50)) then
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

	process(clk200k) 	--Reloj de 100kHz (Va a enviarse a SCL)
	begin
		if(rising_edge(clk200k))then
			clk100k<=not(clk100k);
		end if;
	end process;
	
	--Unidad de Control (UC)
	process (FPGA_CLK1_50)	--En este proceso voy a manipular exclusivamente la señal SDA.
	begin
		if(rising_edge(FPGA_CLK1_50))then
			if(start='1')then					--Comienzo de la transmision: SDA a 0 antes que SCL
				if(clk100k='1')then
					if(clk200k='0')then
						sda_gen<='0';			--Hasta aquí lo he simulado y funciona.
					end if;
				end if;
				--Hay que inicializar las variables de rdy a 0.
			elsif(config='1')then
				--cBits<=7; Está inicializado arriba, debería entrar. No me interesa que en cada iteracion me cambie el valor.
					if(clk100k='1')then
						sda_gen<=data_addr(cBits);
						cBits<=cBits-1;
						if(cBits=0)then
							cBits<=7;
							conf_rdy<='1';
						end if;
					end if;
			end if;
			
			
			
		end if;
	
	end process;
		
	
	--Salidas de comprobación
	GPIO_0(0) <= clk100k;
	GPIO_0(1) <= clk200k;
	SDA <= sda_gen;
	SCL <= clk100k;

end a;