library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PWM_Simple_Configurable is
    Port (	FPGA_CLK : in  STD_LOGIC;
				--DUTY		: in  STD_LOGIC_VECTOR (7 downto 0);
				--FREQ		: in  STD_LOGIC_VECTOR (24 downto 0);
				PWM_OUT	: out	STD_LOGIC;
				PWMinv_OUT: out	STD_LOGIC;
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
end PWM_Simple_Configurable;

architecture Behavioral of PWM_Simple_Configurable is

	component PWM is
	    Port ( CLK			: in	STD_LOGIC;
	           DUTY		: in  STD_LOGIC_VECTOR (7 downto 0);
	           PWM_OUT	: out	STD_LOGIC;
				  PWMinv_OUT: out	STD_LOGIC
				);
	end component;
	
	component hps is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			duty_cycle_external_export      : out   std_logic_vector(7 downto 0);                     -- export
			freq_clk_external_export        : out   std_logic_vector(24 downto 0);                    -- export
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

	signal clk_pwm : std_logic :='1';
	signal cnt : std_logic_vector(24 downto 0) := "0000000000000000000000001";
	signal DUTY: std_logic_vector(7 downto 0);
	SIGNAL FREQ: std_logic_vector(24 downto 0);
begin

	process (FPGA_CLK)
	begin
		if rising_edge(FPGA_CLK) then
			if(cnt<FREQ)then
				cnt<=cnt+'1';
				clk_pwm<=clk_pwm;
			else
				clk_pwm<=not(clk_pwm); --Invierto la senal
				cnt <= "0000000000000000000000001";
			end if;
		end if;
	end process;

	inst1: PWM
	Port Map (	CLK => clk_pwm,
					DUTY => DUTY,
					PWM_OUT => PWM_OUT,
					PWMinv_OUT =>PWMinv_OUT
				);
				
	    u0 : component hps
        port map (
            clk_clk                         => FPGA_CLK,        	  --                     clk.clk
				duty_cycle_external_export      => DUTY,
				freq_clk_external_export        => FREQ,
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

end Behavioral;
