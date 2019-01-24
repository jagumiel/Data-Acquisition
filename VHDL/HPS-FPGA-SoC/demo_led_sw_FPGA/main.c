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
uint32_t *sw;
int fd;

void handler(int signo){
	*sw=0;
	munmap(base, REG_SPAN);
	close(fd);
	exit(0);
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
	sw=(uint32_t*)(base+SW_BASE); //El SW_BASE esta en la cabecera.
	signal(SIGINT, handler);
	while(1){
		value=*sw;
		if(value!=last_value)
			printf("Numero = %d\n", value);
		usleep(250000);
		last_value=value;
	}
}