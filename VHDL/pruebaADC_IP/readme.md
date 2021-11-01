# Prueba ADC IP
## _Testing the ADC using the Intel's IP-Core_


This project uses a Terasic DE10-Nano board to test the ADC IP-Core.

To do so, I am using a potentiometer conected to 5Vcc and GND. And the "Pin 1" of the ADC inputs.
As I control the potentiometer, the readen value is shown through the in-board leds. There are 8 Leds and the ADC has a 12-bit precission, so only the Most Significant Bits are written on the LEDs output.

The following gif shows how the project works.

![Alt text](pruebaADC_IP/demo.gif?raw=true "Title")
