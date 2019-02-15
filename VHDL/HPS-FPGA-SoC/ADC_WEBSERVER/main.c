#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/mman.h>
#include "hps_0.h"

#define REG_BASE 0xff200000
#define REG_SPAN 0x00200000

void *base;
uint32_t *adc;
int fd;

void handler(int signo){
	*adc=0;
	munmap(base, REG_SPAN);
	close(fd);
	exit(0);
}

/*La función recoge un valor y lo imprime en un fichero txt.*/
int imprimirValorFich(int valor){
	FILE *fptr;

	fptr = fopen("/usr/share/apache2/htdocs/valor.txt", "w");
	if(fptr == NULL){
		printf("Error!");
		exit(1);
	}

	fprintf(fptr,"%d", valor);
	fclose(fptr);

	return 0;
}

int main(){
	int value=0;
	int last_value=0;
	fd=open("/dev/mem",(O_RDWR|O_SYNC)); //Abro la memoria del sistema.
	if(fd<0){
		printf("Can't open memory. \n");
		return -1;
	}
	base=mmap(NULL,REG_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,REG_BASE);
	if(base==MAP_FAILED){
		printf("Can't MAP memory. \n");
		close(fd);
		return -1;
	}
	adc=(uint32_t*)(base+ADC_VAL_BASE); //El ADC_VAL_BASE esta en la cabecera.
	signal(SIGINT, handler);
	//printf("El valor actual es: /n");
	while(1){
		value=*adc;
		printf("El valor actual es: %d\n", *adc);
		imprimirValorFich(value);
		usleep(250000);
	}
}