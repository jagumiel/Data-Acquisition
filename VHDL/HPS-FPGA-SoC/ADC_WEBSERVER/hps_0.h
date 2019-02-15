#ifndef _ALTERA_HPS_0_H_
#define _ALTERA_HPS_0_H_

/*
 * This file was automatically generated by the swinfo2header utility.
 * 
 * Created from SOPC Builder system 'hps' in
 * file './hps.sopcinfo'.
 */

/*
 * This file contains macros for module 'hps_0' and devices
 * connected to the following master:
 *   h2f_lw_axi_master
 * 
 * Do not include this header file and another header file created for a
 * different module or master group at the same time.
 * Doing so may result in duplicate macro names.
 * Instead, use the system header file which has macros with unique names.
 */

/*
 * Macros for device 'adc_val', class 'altera_avalon_pio'
 * The macros are prefixed with 'ADC_VAL_'.
 * The prefix is the slave descriptor.
 */
#define ADC_VAL_COMPONENT_TYPE altera_avalon_pio
#define ADC_VAL_COMPONENT_NAME adc_val
#define ADC_VAL_BASE 0x0
#define ADC_VAL_SPAN 16
#define ADC_VAL_END 0xf
#define ADC_VAL_BIT_CLEARING_EDGE_REGISTER 0
#define ADC_VAL_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADC_VAL_CAPTURE 0
#define ADC_VAL_DATA_WIDTH 12
#define ADC_VAL_DO_TEST_BENCH_WIRING 0
#define ADC_VAL_DRIVEN_SIM_VALUE 0
#define ADC_VAL_EDGE_TYPE NONE
#define ADC_VAL_FREQ 50000000
#define ADC_VAL_HAS_IN 1
#define ADC_VAL_HAS_OUT 0
#define ADC_VAL_HAS_TRI 0
#define ADC_VAL_IRQ_TYPE NONE
#define ADC_VAL_RESET_VALUE 0


#endif /* _ALTERA_HPS_0_H_ */
