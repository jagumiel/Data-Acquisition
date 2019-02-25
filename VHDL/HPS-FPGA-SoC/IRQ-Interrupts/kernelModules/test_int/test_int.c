#include <linux/module.h> /*Needed by all modules*/
#include <linux/kernel.h> /*Needed for KERN_INFO*/
#include <linux/init.h>   /*Needed for the macros*/
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/of.h>

#define DEVNAME "test_int"

static irq_handler_t __test_isr(int irq, void *dev_id, struct pt_regs *regs){
	printk (KERN_INFO DEVNAME ": ISR\n");
	return (irq_handler_t) IRQ_HANDLED;
}

static int __test_int_driver_probe(struct platform_device* pdev){
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
