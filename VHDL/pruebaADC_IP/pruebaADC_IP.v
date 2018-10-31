/*** Este programa captura el valor de una señal analógica y lo representa en digital a través de los leds.
Ademas se usan los 8 canales, que se seleccionan mediante los interruptores (SW) de la placa de desarrollo.
Para este ejemplo se está utilizando un IP Core de Altera/Intel.***/


module pruebaADC_IP (CLOCK_50, KEY, SW, LED, ADC_SCLK, 
		ADC_CS_N, ADC_SDAT, ADC_SADDR);

		input CLOCK_50;
		input [0:0] KEY;
		input [2:0] SW;
		output [7:0] LED;
		
		input ADC_SDAT;
		output ADC_SCLK, ADC_CS_N, ADC_SADDR;
		
		wire [11:0] values [7:0];
		
		assign LED = values [SW][11:4];
		
		adc_control ADC (
			.CLOCK (CLOCK_50),
			.RESET (!KEY[0]),
			.ADC_SCLK (ADC_SCLK),
			.ADC_CS_N (ADC_CS_N),
			.ADC_DIN (ADC_SADDR),
			.ADC_DOUT (ADC_SDAT),
			.CH0 (values[0]),
			.CH1 (values[1]),
			.CH2 (values[2]),
			.CH3 (values[3]),
			.CH4 (values[4]),
			.CH5 (values[5]),
			.CH6 (values[6]),
			.CH7 (values[7])		
		);
endmodule
