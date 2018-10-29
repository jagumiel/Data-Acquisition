module adc_demo (CLOCK_50, KEY, LED, ADC_SCLK, 
		ADC_CS_N, ADC_SDAT, ADC_SADDR);

		input CLOCK_50;
		input [0:0] KEY;
		output [7:0] LED;
		input ADC_SDAT;
		output ADC_SCLK, ADC_CS_N, ADC_SADDR;
		nios_system NIOS (
		.clk_clk (CLOCK_50),
		.reset_reset_n (KEY[0]),
		.leds_export (LED),
		.adc_sclk (ADC_SCLK),
		.adc_cs_n (ADC_CS_N),
		.adc_dout (ADC_SDAT),
		.adc_din (ADC_SADDR));
endmodule
