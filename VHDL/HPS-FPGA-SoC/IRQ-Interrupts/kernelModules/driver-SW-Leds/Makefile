obj-m += test_int.o
KERNELPATH=/home/jose/linux-socfpga-socfpga-4.14.73-ltsi-rt/

all:
	make -C $(KERNELPATH) M=$(PWD) modules

clean:
	make -C $(KERNELPATH) M=$(PWD) clean
