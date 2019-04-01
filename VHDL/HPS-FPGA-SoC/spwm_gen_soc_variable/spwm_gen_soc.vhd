library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity spwm_gen_soc is
	port(
		clk	: in  std_logic;
--		freq_sin: std_logic_vector(31 downto 0);
--		freq_tri: std_logic_vector(31 downto 0);
		en: out std_logic;
		phase1a: out std_logic;
		phase2a: out std_logic;
		phase3a: out std_logic;
		phase1b: out std_logic;
		phase2b: out std_logic;
		phase3b: out std_logic;
		------------ HPS ----------
		HPS_DDR3_ADDR:OUT STD_LOGIC_VECTOR(14 downto 0);
		HPS_DDR3_BA: OUT STD_LOGIC_VECTOR(2 downto 0);
		HPS_DDR3_CAS_N: OUT STD_LOGIC;
		HPS_DDR3_CKE:OUT STD_LOGIC;
		HPS_DDR3_CK_N: OUT STD_LOGIC;
		HPS_DDR3_CK_P: OUT STD_LOGIC;
		HPS_DDR3_CS_N: OUT STD_LOGIC;
		HPS_DDR3_DM: OUT STD_LOGIC_VECTOR(3 downto 0);
		HPS_DDR3_DQ: INOUT STD_LOGIC_VECTOR(31 downto 0);
		HPS_DDR3_DQS_N: INOUT STD_LOGIC_VECTOR(3 downto 0);
		HPS_DDR3_DQS_P: INOUT STD_LOGIC_VECTOR(3 downto 0);
		HPS_DDR3_ODT: OUT STD_LOGIC;
		HPS_DDR3_RAS_N: OUT STD_LOGIC;
		HPS_DDR3_RESET_N: OUT  STD_LOGIC;
		HPS_DDR3_RZQ: IN  STD_LOGIC;
		HPS_DDR3_WE_N: OUT STD_LOGIC;
		HPS_ENET_GTX_CLK: OUT STD_LOGIC;
		HPS_ENET_INT_N:INOUT STD_LOGIC;
		HPS_ENET_MDC:OUT STD_LOGIC;
		HPS_ENET_MDIO:INOUT STD_LOGIC;
		HPS_ENET_RX_CLK: IN STD_LOGIC;
		HPS_ENET_RX_DATA: IN STD_LOGIC_VECTOR(3 downto 0);
		HPS_ENET_RX_DV: IN STD_LOGIC;
		HPS_ENET_TX_DATA: OUT STD_LOGIC_VECTOR(3 downto 0);
		HPS_ENET_TX_EN: OUT STD_LOGIC;
		HPS_SD_CLK: OUT STD_LOGIC;
		HPS_SD_CMD: INOUT STD_LOGIC;
		HPS_SD_DATA: INOUT STD_LOGIC_VECTOR(3 downto 0);
		HPS_UART_RX: IN   STD_LOGIC;
		HPS_UART_TX: OUT STD_LOGIC;
		HPS_USB_CLKOUT: IN STD_LOGIC;
		HPS_USB_DATA:INOUT STD_LOGIC_VECTOR(7 downto 0);
		HPS_USB_DIR: IN STD_LOGIC;
		HPS_USB_NXT: IN STD_LOGIC;
		HPS_USB_STP: OUT STD_LOGIC
	);
end spwm_gen_soc;

architecture a of spwm_gen_soc is

	--Componentes:

	component hps is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			freq_tri_external_export     	  : out   std_logic_vector(31 downto 0);                     -- export
			freq_sin_external_export        : out   std_logic_vector(31 downto 0);                    -- export
			enable_external_export          : out   std_logic;                    							-- export
			hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			memory_mem_a                    : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                   : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                 : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                  : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                 : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                 : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n              : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                  : out   std_logic;                                        -- mem_odt
			memory_mem_dm                   : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                : in    std_logic                     := 'X'              -- oct_rzqin
		);
	end component hps;

	component triangle
		port (	-- system signals
			clk:		in	 std_logic;
			amp:		in	 std_logic_vector(32-1 downto 0);
			frq:		in	 std_logic_vector(32-1 downto 0);
			pwm_ctrl:out std_logic_vector(32-1 downto 0)
		);
	end component;

	component sin
		port (
			clk:		in	 std_logic;
			amp:		in	 std_logic_vector(32-1 downto 0);
			frq:		in	 std_logic_vector(32-1 downto 0);
			pwm_ctrl:out std_logic_vector(32-1 downto 0)
		);
	end component;

	component sin_120
		port (
			clk:		in  std_logic;
			amp:		in	 std_logic_vector(32-1 downto 0);
			frq:		in  std_logic_vector(32-1 downto 0);
			pwm_ctrl:out std_logic_vector(32-1 downto 0)
		);
	end component;

	component sin_240
		port (
			clk:		in	 std_logic;
			amp:		in	 std_logic_vector(32-1 downto 0);
			frq:		in	 std_logic_vector(32-1 downto 0);
			pwm_ctrl:out std_logic_vector(32-1 downto 0)
		);
	end component;

	component delay
		port(
			clk:	 in std_logic;
			delay:	 in integer range 0 to 1000; --Lo voy a tomar en ns. Calcula que sean 500 aprox.
			phase1a: in std_logic;
			phase2a: in std_logic;
			phase3a: in std_logic;
			phase1b: in std_logic;
			phase2b: in std_logic;
			phase3b: in std_logic;
			phase1a_d: out std_logic;
			phase2a_d: out std_logic;
			phase3a_d: out std_logic;
			phase1b_d: out std_logic;
			phase2b_d: out std_logic;
			phase3b_d: out std_logic
		);
	end component;

	--senales
	signal seno ,seno120, seno240, triangular : std_logic_vector(31 downto 0);
	signal pulso ,pulso120, pulso240 : std_logic:='0';
	signal phase1a_delay, phase2a_delay, phase3a_delay, phase1b_delay, phase2b_delay, phase3b_delay : std_logic:='0';
	--No las vas a usar, van a ser otras. Aqui serian freq_tri y freq_sin
	signal FREQ_TRI: std_logic_vector(31 downto 0);
	signal FREQ_SIN: std_logic_vector(31 downto 0);	
	signal FREQ_TRI_n: std_logic_vector(31 downto 0);
	signal FREQ_SIN_n: std_logic_vector(31 downto 0);
	signal enable:std_logic:='0';

begin

	en<=enable;
	
	process(clk)
	begin
		if(rising_edge(clk))then
			if(FREQ_SIN<x"000001f4")then
				FREQ_SIN_n<=x"000001f4";
			else
				FREQ_SIN_n<=FREQ_SIN;
			end if;
			if(FREQ_TRI<x"000001f4")then
				FREQ_TRI_n<=x"000001f4";
			else
				FREQ_TRI_n<=FREQ_TRI;
			end if;
		end if;
	end process;

	 u0 : component hps
		port map (
			clk_clk                         => clk,        	  --                     clk.clk
			freq_tri_external_export        => FREQ_TRI,
			freq_sin_external_export        => FREQ_SIN,
			enable_external_export          => enable,
			hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK, 	  --                  hps_io.hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0), --                        .hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1), --                        .hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2), --                        .hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3), --                        .hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0), --                        .hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,		  --                        .hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,		  --                        .hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,		  --                        .hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,		  --                        .hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,	  --                        .hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1), --                        .hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2), --                        .hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3), --                        .hps_io_emac1_inst_RXD3
			hps_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,			  --                        .hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),		  --                        .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),		  --                        .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,			  --                        .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),      --                        .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),      --                        .hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),     --                        .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),     --                        .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),     --                        .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),     --                        .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),     --                        .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),     --                        .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),     --                        .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),     --                        .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,		  --                        .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP     => HPS_USB_STP,			  --                        .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,			  --                        .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,			  --                        .hps_io_usb1_inst_NXT
			hps_io_hps_io_uart0_inst_RX     => HPS_UART_RX,			  --                        .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX     => HPS_UART_TX,			  --                        .hps_io_uart0_inst_TX
			hps_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N,		  --                        .hps_io_gpio_inst_GPIO35
			memory_mem_a                    => HPS_DDR3_ADDR,		  --                  memory.mem_a
			memory_mem_ba                   => HPS_DDR3_BA,			  --                        .mem_ba
			memory_mem_ck                   => HPS_DDR3_CK_P,		  --                        .mem_ck
			memory_mem_ck_n                 => HPS_DDR3_CK_N,		  --                        .mem_ck_n
			memory_mem_cke                  => HPS_DDR3_CKE,		  --                        .mem_cke
			memory_mem_cs_n                 => HPS_DDR3_CS_N,		  --                        .mem_cs_n
			memory_mem_ras_n                => HPS_DDR3_RAS_N,		  --                        .mem_ras_n
			memory_mem_cas_n                => HPS_DDR3_CAS_N,		  --                        .mem_cas_n
			memory_mem_we_n                 => HPS_DDR3_WE_N,		  --                        .mem_we_n
			memory_mem_reset_n              => HPS_DDR3_RESET_N,	  --                        .mem_reset_n
			memory_mem_dq                   => HPS_DDR3_DQ,			  --                        .mem_dq
			memory_mem_dqs                  => HPS_DDR3_DQS_P,		  --                        .mem_dqs
			memory_mem_dqs_n                => HPS_DDR3_DQS_N,		  --                        .mem_dqs_n
			memory_mem_odt                  => HPS_DDR3_ODT,		  --                        .mem_odt
			memory_mem_dm                   => HPS_DDR3_DM,			  --                        .mem_dm
			memory_oct_rzqin                => HPS_DDR3_RZQ			  --                        .oct_rzqin
	  );

	--	x"00002710"  == 10 000
	--Seeing 10000 cycle of 20ns takes 100000ns -> 10KHz
	--	x"00989680"  == 10 000 000
	--  Seeing 10 000 000 cycles of 10ns takes 100 000 000ns  ->  10 Hz
	--	x"05F5E100"  == 100 000 000
	--  Seeing 100 000 000 cycles of 10ns takes 1 000 000 000ns  ->  1 Hz
	
	inst1: triangle
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		--frq		=> x"000003E8",--50kHz
		--frq		=> x"000001F4", --100kHz
		--frq		=> x"00001388", --10kHz
		--frq		=> x"000009C4", --20kHz
		frq 		=> FREQ_TRI_n,
		pwm_ctrl	=> triangular
	);

	inst2: sin
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		--frq		=> x"00001388", --Supuestamente, 5000 ciclos de 20ns, 10kHz
		--frq		=> x"0000C350", --Supuestamente, 50000 ciclos de 20ns, 1kHz
		frq		=> FREQ_SIN_n,
		pwm_ctrl	=> seno
	);

	inst3: sin_120
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		frq		=> FREQ_SIN_n,
		--frq		=> x"0000C350",
		pwm_ctrl	=> seno120
	);

	inst4: sin_240
	port map(
		clk		=> clk,
		amp		=> x"FFFFFFFF",
		frq		=> FREQ_SIN_n,
		--frq		=> x"0000C350",
		pwm_ctrl	=> seno240
	);

	process(clk)--Ojo, igual tienes que anadir las variables que lees a la lista de sensibilidad
	begin
		if(rising_edge(clk))then
			if(triangular<seno)then
				pulso<='0';
			else
				pulso<='1';
			end if;
	
			if(triangular<seno120)then
				pulso120<='0';
			else
				pulso120<='1';
			end if;
	
			if(triangular<seno240)then
				pulso240<='0';
			else
				pulso240<='1';
			end if;
		end if;
	end process;

	inst5: delay
	port map( --Cuidado, mira que el NOT sea sintetizable luego.
		clk		=> clk,
		delay		=> 500,
		phase1a		=> pulso,
		phase2a		=> pulso120,
		phase3a		=> pulso240,
		phase1b		=> "NOT"(pulso),
		phase2b		=> "NOT"(pulso120),
		phase3b		=> "NOT"(pulso240),
		phase1a_d	=> phase1a_delay,
		phase2a_d	=> phase2a_delay,
		phase3a_d	=> phase3a_delay,
		phase1b_d	=> phase1b_delay,
		phase2b_d	=> phase2b_delay,
		phase3b_d	=> phase3b_delay
	);

	process(clk, enable)
	begin
		if(rising_edge(clk))then
			if(enable='1')then
				phase1a <= phase1a_delay;
				phase2a <= phase2a_delay;
				phase3a <= phase3a_delay;
				phase1b <= phase1b_delay;
				phase2b <= phase2b_delay;
				phase3b <= phase3b_delay;
			else
				phase1a <= '0';
				phase2a <= '0';
				phase3a <= '0';
				phase1b <= '0';
				phase2b <= '0';
				phase3b <= '0';
			end if;
		end if;
	end process;
end a;