	nios_system u0 (
		.clk_clk       (<connected-to-clk_clk>),       //   clk.clk
		.reset_reset_n (<connected-to-reset_reset_n>), // reset.reset_n
		.leds_export   (<connected-to-leds_export>),   //  leds.export
		.adc_sclk      (<connected-to-adc_sclk>),      //   adc.sclk
		.adc_cs_n      (<connected-to-adc_cs_n>),      //      .cs_n
		.adc_dout      (<connected-to-adc_dout>),      //      .dout
		.adc_din       (<connected-to-adc_din>)        //      .din
	);

