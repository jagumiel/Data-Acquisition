#include <linux/module.h> /*Needed by all modules*/
#include <linux/kernel.h> /*Needed for KERN_INFO*/
#include <linux/init.h>   /*Needed for the macros*/
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/of.h>

#define REG_BASE 0xff200000
#define REG_SPAN 0x00200000
#define ENTRADA_0_BASE 0x0

#define dato (volatile short *) 0x00200000

#define DEVNAME "test_int"
void *base;
int fd;

static irq_handler_t __test_isr(int irq, void *dev_id, struct pt_regs *regs){
	//dato=(uint32_t*)(base+FPGA_TO_HPS_BASE);
	printk("dato: %d\n", *dato);
	printk (KERN_INFO DEVNAME ": ISR\n");
	return (irq_handler_t) IRQ_HANDLED;
}

static int __test_int_driver_probe(struct platform_device* pdev){
	fd=open("/dev/mem",(O_RDWR|O_SYNC)); //Abro la memoria del sistema.
	if(fd<0){
		printk("Can't open memory. \n");
		return -1;
	}
	base=mmap(NULL,REG_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,REG_BASE);
	if(base==MAP_FAILED){
		printk("Can't MAP memory. \n");
		close(fd);
		return -1;
	}
	int irq_num;
	irq_num = platform_get_irq(pdev, 0);
	printk(KERN_INFO DEVNAME ": La IRQ %d va a ser registrada!\n", irq_num);
	return request_irq(irq_num, (irq_handler_t) __test_isr, 0, DEVNAME, NULL);
}

static int __test_int_driver_remove (struct platform_device *pdev){
	int irq_num;
	irq_num = platform_get_irq (pdev, 0);
	printk(KERN_INFO "test_int: Abandonando la captura de la IRQ %d !\n", irq_num);
	free_irq(irq_num, NULL);
	return 0;
}

static const struct of_device_id __test_int_driver_id[] = {
	{.compatible = "altr , socfpga-mysoftip"},
	{}
};

static struct platform_driver __test_int_driver = {
	.driver= {
		.name = DEVNAME,
		.owner = THIS_MODULE,
		.of_match_table = of_match_ptr (__test_int_driver_id),
	},
	.probe = __test_int_driver_probe,
	.remove = __test_int_driver_remove
};

module_platform_driver (__test_int_driver);

MODULE_LICENSE("GPL");
