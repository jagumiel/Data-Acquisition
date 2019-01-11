#include <stdio.h>
#include <unistd.h>
#include <fcntl.h> 
#include <sys/mman.h> 
#include "hwlib.h" 
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h" 
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"

#define REG_BASE 0xFF200000
#define REG_SPAN 0x00200000

void* virtual_base;
void* led_addr;
void* sw_addr;
int fd;
int switches;

int main (){
	fd=open("/dev/mem",(O_RDWR|O_SYNC)); //Abro la memoria del sistema.
	virtual_base=mmap(NULL,REG_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,REG_BASE);
	/*Para acceder a los dispositivos: Base+Offset. 
	Fue definido en Qsys y ahora aparece en la cabecera generada.*/
	sw_addr=virtual_base+SW_BASE;
	led_addr=virtual_base+LED_BASE;

	while(1){
		/*Tomo el valor de los switches y se lo envio
		a la direccion de memoria de los leds.*/
		switches=*(uint32_t *)sw_addr; //Los punteros estan como void, hay que hacer un cast.
		*(uint32_t *)led_addr=switches;
		usleep(1000000);
		printf("%u\n",switches);
	}
	return 0;
}