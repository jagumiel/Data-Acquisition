#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/mman.h>
#include "hps_0.h"

#define REG_BASE 0xff200000
#define REG_SPAN 0x00200000

#define MAX_BUF 1024

void *base;
uint32_t *duty;
uint32_t *freq;
uint32_t *en;
int fd;

void handler(int signo){
	*duty=0;
	*freq=0;
	*en=0;
	munmap(base, REG_SPAN);
	close(fd);
	exit(0);
}

void imprimirMenu(){
	printf("  Menu del PWM: \n\n");
	printf("****************************************\n");
	printf("Seleccione la opcion que quiere utilizar:\n");
	printf("\t\t\t\t-1) Encender/Apagar. \n");
	printf("\t\t\t\t-2) Cambiar frecuencia. \n");
	printf("\t\t\t\t-3) Cambiar Duty-Cycle. \n");
	printf("\t\t\t\t-4) Salir de la aplicacion.\n");
	printf("\n");
	printf("\t\t\t\tElija una opcion:\n ");
}


int main(){
	char seleccion[MAX_BUF];
	char c_freq[MAX_BUF];
	char c_duty[MAX_BUF];
	char c_en[MAX_BUF];
	int n_freq, n_duty;
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
	freq=(uint32_t*)(base+FREQ_CLK_BASE);
	duty=(uint32_t*)(base+DUTY_CYCLE_BASE);
	en=(uint32_t*)(base+ENABLE_BASE);
	signal(SIGINT, handler);
	
	//imprimo el menu
	imprimirMenu();
	
	//Inicializaciones (antes del bucle principal)
	*en=0;
	*freq=24; //4kHz aprox
	*duty=230; //90% aprox
	

	//Bucle principal. Aqui se desarrollara el programa
	while(fgets(seleccion, MAX_BUF, stdin) != NULL){
		//Comprobaciones, que comando se ha seleccionado? Que parametros tengo que solicitar?
		if (strcmp(seleccion,"1\n")==0){
			printf("Pulse 0 para apagar o 1 para encender. \n");
			fgets(c_en, MAX_BUF, stdin);
			*en=atoi(c_en);
		}
		else if (strcmp(seleccion,"2\n")==0){
			printf("Esta es la seleccion: %s\n Introduzca la frecuencia en Hz. \n", seleccion);
			fgets(c_freq, MAX_BUF, stdin);
			n_freq=atoi(c_freq);
			if(n_freq<1){
				printf("La frecuencia permitida se encuentra en el rango 1Hz-100kHz\n");
			}else{
				*freq=50000000/(512*n_freq);
			}
		}
		else if (strcmp(seleccion,"3\n")==0){
			printf("Esta es la seleccion: %s\n Introduzca el duty-cycle. \n", seleccion);
			fgets(c_duty, MAX_BUF, stdin);
			n_duty=atoi(c_duty);
			*duty=(n_duty*256)/100;
		}else if(strcmp(seleccion,"4\n")==0){
			*en=0;
			exit(0);
		}
		imprimirMenu();
	}
}