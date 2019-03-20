library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY hps_adc_IPCore IS
	PORT(
		CLOCK			: in  std_logic;
		KEY			: in  std_logic_vector (0 downto 0);
		ch0			: out std_logic_vector(11 downto 0);
		ch1			: out std_logic_vector(11 downto 0);
		ch2			: out std_logic_vector(11 downto 0);
		ch3			: out std_logic_vector(11 downto 0);
		ch4			: out std_logic_vector(11 downto 0);
		ch5			: out std_logic_vector(11 downto 0);
		ch6			: out std_logic_vector(11 downto 0);
		ch7			: out std_logic_vector(11 downto 0);
		ADC_SCLK		: out std_logic;
		ADC_CS_N		: out std_logic;
		ADC_SDAT		: in  std_logic;
		ADC_SADDR	: out std_logic;
		LED			: out std_logic_vector(7 downto 0);
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
END hps_adc_IPCore;



	 
ARCHITECTURE a OF hps_adc_IPCore IS
	 component adc_control is
        port (
            CLOCK    : in  std_logic                     := 'X'; -- clk
            RESET    : in  std_logic                     := 'X'; -- reset
            CH0      : out std_logic_vector(11 downto 0);        -- CH0
            CH1      : out std_logic_vector(11 downto 0);        -- CH1
            CH2      : out std_logic_vector(11 downto 0);        -- CH2
            CH3      : out std_logic_vector(11 downto 0);        -- CH3
            CH4      : out std_logic_vector(11 downto 0);        -- CH4
            CH5      : out std_logic_vector(11 downto 0);        -- CH5
            CH6      : out std_logic_vector(11 downto 0);        -- CH6
            CH7      : out std_logic_vector(11 downto 0);        -- CH7
            ADC_SCLK : out std_logic;                            -- SCLK
            ADC_CS_N : out std_logic;                            -- CS_N
            ADC_DOUT : in  std_logic                     := 'X'; -- DOUT
            ADC_DIN  : out std_logic                             -- DIN
        );
    end component adc_control;
	 
	     component hps is
        port (
            clk_clk                         : in    std_logic                     := 'X';             -- clk
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
            memory_oct_rzqin                : in    std_logic                     := 'X';             -- oct_rzqin
				adc_val_external_connection_export   : in    std_logic_vector(11 downto 0)                -- export
        );
    end component hps;
	 
	 signal reset : std_logic;
	 signal chan0 : std_logic_vector(11 downto 0);
	 signal chan1 : std_logic_vector(11 downto 0);
	 signal chan2 : std_logic_vector(11 downto 0);
	 signal chan3 : std_logic_vector(11 downto 0);
	 signal chan4 : std_logic_vector(11 downto 0);
	 signal chan5 : std_logic_vector(11 downto 0);
	 signal chan6 : std_logic_vector(11 downto 0);
	 signal chan7 : std_logic_vector(11 downto 0);
	 
BEGIN
		
	reset <= not(KEY(0));

	u0 : component adc_control
        port map (
            CLOCK    => CLOCK,		--                clk.clk
            RESET    => reset,		--              reset.reset
            CH0      => chan0,		--           readings.CH0
            CH1      => chan1,		--                   .CH1
            CH2      => chan2,		--                   .CH2
            CH3      => chan3,		--                   .CH3
            CH4      => chan4,		--                   .CH4
            CH5      => chan5,		--                   .CH5
            CH6      => chan6,		--                   .CH6
            CH7      => chan7,		--                   .CH7
            ADC_SCLK => ADC_SCLK,	-- external_interface.SCLK
            ADC_CS_N => ADC_CS_N,	--                   .CS_N
            ADC_DOUT => ADC_SDAT,	--                   .DOUT
            ADC_DIN  => ADC_SADDR	--                   .DIN
        );
		  
	    u1 : component hps
        port map (
            clk_clk                         => CLOCK,            	  --                     clk.clk
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
            memory_oct_rzqin                => HPS_DDR3_RZQ,		  --                        .oct_rzqin
				adc_val_external_connection_export   => chan0			  --  adc_val_external_connection.export
        );
		  
		  LED<=chan0(11 downto 4);
		  ch0<=chan0;
		  ch1<=chan1;
		  ch2<=chan2;
		  ch3<=chan3;
		  ch4<=chan4;
		  ch5<=chan5;
		  ch6<=chan6;
		  ch7<=chan7;
		  
end a;