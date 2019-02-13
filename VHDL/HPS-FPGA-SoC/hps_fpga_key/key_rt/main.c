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
uint32_t *gpio_hps;
uint32_t *key;
int fd;

void handler(int signo){
	*gpio_hps=0;
	*key=0;
	munmap(base, REG_SPAN);
	close(fd);
	exit(0);
}

int main(){
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
	key=(uint32_t*)(base+KEY_BASE);
	gpio_hps=(uint32_t*)(base+GPIO_HPS_BASE);
	signal(SIGINT, handler);
	//printf("El valor actual es: /n");
	while(1){
		//printf("El valor actual es: %d\n", *gpio_hps);
		if(*key==1)
			*gpio_hps=1;
		else
			*gpio_hps=0;
	}
}