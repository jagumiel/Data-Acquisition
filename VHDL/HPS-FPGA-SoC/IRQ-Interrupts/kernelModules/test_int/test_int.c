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
#define DEVNAME "test_int"

void *base;
static uint8_t input_state;
int fd;
uint32_t *dato=0;

static irq_handler_t __test_isr(int irq, void *dev_id, struct pt_regs *regs){
	dato=(uint32_t*)(base+REG_BASE);
	printk (KERN_INFO DEVNAME ": ISR\n");
	if(irq==41){
		printk("IRQ=%d\n", irq);
		input_state=ioread8(base);
		printk("input_state=%d\n", input_state);
	}
	return (irq_handler_t) IRQ_HANDLED;
}

static int __test_int_driver_probe(struct platform_device* pdev){
	if (request_mem_region(REG_BASE, REG_SPAN, "test_int") == NULL) {
		printk("Fallo al pedir memoria.");
		return -EBUSY;
	}

	base = ioremap(REG_BASE, REG_SPAN);
	if (base == NULL) {
		printk("Fallo al mapear memoria.");
		return -EFAULT;
	}

	int irq_num;
	irq_num = platform_get_irq(pdev, 0);
	printk(KERN_INFO DEVNAME ": La IRQ %d va a ser registrada!\n", irq_num);
	dato=(uint32_t*)(base+REG_BASE);
	return request_irq(irq_num, (irq_handler_t) __test_isr, 0, DEVNAME, NULL);
}

static int __test_int_driver_remove (struct platform_device *pdev){
	int irq_num;
	irq_num = platform_get_irq (pdev, 0);
	printk(KERN_INFO "test_int: Abandonando la captura de la IRQ %d !\n", irq_num);
	free_irq(irq_num, NULL);
	iounmap(base);
	release_mem_region(REG_BASE, REG_SPAN);
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