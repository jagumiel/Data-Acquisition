	component nios_system is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			leds_export   : out std_logic_vector(7 downto 0);        -- export
			adc_sclk      : out std_logic;                           -- sclk
			adc_cs_n      : out std_logic;                           -- cs_n
			adc_dout      : in  std_logic                    := 'X'; -- dout
			adc_din       : out std_logic                            -- din
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			leds_export   => CONNECTED_TO_leds_export,   --  leds.export
			adc_sclk      => CONNECTED_TO_adc_sclk,      --   adc.sclk
			adc_cs_n      => CONNECTED_TO_adc_cs_n,      --      .cs_n
			adc_dout      => CONNECTED_TO_adc_dout,      --      .dout
			adc_din       => CONNECTED_TO_adc_din        --      .din
		);

