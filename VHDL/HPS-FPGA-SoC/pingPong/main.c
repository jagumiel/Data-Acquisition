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
uint32_t *dataFromFPGA;
uint32_t *dataToFPGA;
int fd;

void handler(int signo){
	*dataFromFPGA=0;
	*dataToFPGA=0;
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
	dataFromFPGA=(uint32_t*)(base+FPGA_TO_HPS_BASE);
	dataToFPGA=(uint32_t*)(base+HPS_TO_FPGA_BASE);
	signal(SIGINT, handler);
	//printf("El valor actual es: /n");
	while(1){
		//Hago un bypass
		*dataToFPGA=*dataFromFPGA;
	}
}