# FPGA-HPS-SoC
In this section I will publish SoC projects, in which I pretend to communicate FPGA and HPS.

## What do you need?
Just a development board with a Cyclone V/Arria V SoC and a Linux running a Linux distribution. I'm using Angström.

## Project List and description:
* **demo_led** - Accesing the leds through HPS and controlling them through a C program. Repetitive pattern.
* **demo_sw** - Reading the on-board switches and printing the number the binary code represents as decimal on screen.
* **demo_led_sw_FPGA** - Does the same as above, but while the HPS reads the switches and prints, the FPGA is putting the combination on the LEDs. Both, FPGA and HPS are doing different tasks.
* **demo_led_sw_hps** - The HPS reads on the switches and writes it's value on the leds. It only happens when the C program is in execution.
* **hps_adc** - The FPGA configures and runs and ADC and the HPS can get the data and print it on screen.
* **hps_adc_IPCore** - The same of "hps_adc", but using Altera's IP Core.
* **hps_fpga_key** - When Key0 is pressed the FPGA changes a GPIO value from '1' to '0' and the HPS changes another GPIO from '1' to '0' aswell. I want to measure the latencies between the FPGA and the HPS.


# FPGA-HPS-SoC
En esta sección se publicarán los proyectos que se hagan comunicando la FPGA con el HPS.

## ¿Qué necesitas?
Solamente una placa de desarrollo con un SoC Cyclone V/Arria V y una distribución de Linux sobre ella. Yo estoy usando Angström.

## Lista de proyectos y descripción:
* **demo_led** - Accede a los leds a través del HPS, y los controla a través de un programa escrito en C. El patrón es repetitivo.
* **demo_sw** - Lee los interruptores de la placa e imprime por pantalla la combinación binaria que representan en formato decimal.
* **demo_led_sw_FPGA** - Hace lo mismo que el anterior, sólo que, mientras el HPS esta leyendo el valor de los interruptores e imprimiéndo, la FPGA está asociando la combinación de los switches hacia los leds. Ambos, FPGA y HPS, se dedican a hacer diferentes tareas.
* **demo_led_sw_hps** - El HPS lee los interruptores y escribe su valor en los leds. Solo pasa cuando el programa en C está en ejecución.
* **hps_adc** - La FPGA configura y pone en marcha un ADC y el HPS puede acceder a leer los datos e imprimirlos por pantalla.
* **hps_adc_IPCore** - Lo mismo que "hps_adc", pero usando el IP Core de Altera.
* **hps_fpga_key** - Cuando se presiona el botón "Key0" la FPGA cambia un GPIO de '1' a '0', y el HPS hace lo mismo con otro GPIO distinto. Quiero medir las latencias entre la FPGA y el HPS.
