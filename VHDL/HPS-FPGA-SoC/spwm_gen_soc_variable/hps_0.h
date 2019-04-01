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
 * Macros for device 'freq_tri', class 'altera_avalon_pio'
 * The macros are prefixed with 'FREQ_TRI_'.
 * The prefix is the slave descriptor.
 */
#define FREQ_TRI_COMPONENT_TYPE altera_avalon_pio
#define FREQ_TRI_COMPONENT_NAME freq_tri
#define FREQ_TRI_BASE 0x0
#define FREQ_TRI_SPAN 16
#define FREQ_TRI_END 0xf
#define FREQ_TRI_BIT_CLEARING_EDGE_REGISTER 0
#define FREQ_TRI_BIT_MODIFYING_OUTPUT_REGISTER 0
#define FREQ_TRI_CAPTURE 0
#define FREQ_TRI_DATA_WIDTH 32
#define FREQ_TRI_DO_TEST_BENCH_WIRING 0
#define FREQ_TRI_DRIVEN_SIM_VALUE 0
#define FREQ_TRI_EDGE_TYPE NONE
#define FREQ_TRI_FREQ 50000000
#define FREQ_TRI_HAS_IN 0
#define FREQ_TRI_HAS_OUT 1
#define FREQ_TRI_HAS_TRI 0
#define FREQ_TRI_IRQ_TYPE NONE
#define FREQ_TRI_RESET_VALUE 0

/*
 * Macros for device 'freq_sin', class 'altera_avalon_pio'
 * The macros are prefixed with 'FREQ_SIN_'.
 * The prefix is the slave descriptor.
 */
#define FREQ_SIN_COMPONENT_TYPE altera_avalon_pio
#define FREQ_SIN_COMPONENT_NAME freq_sin
#define FREQ_SIN_BASE 0x10
#define FREQ_SIN_SPAN 16
#define FREQ_SIN_END 0x1f
#define FREQ_SIN_BIT_CLEARING_EDGE_REGISTER 0
#define FREQ_SIN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define FREQ_SIN_CAPTURE 0
#define FREQ_SIN_DATA_WIDTH 32
#define FREQ_SIN_DO_TEST_BENCH_WIRING 0
#define FREQ_SIN_DRIVEN_SIM_VALUE 0
#define FREQ_SIN_EDGE_TYPE NONE
#define FREQ_SIN_FREQ 50000000
#define FREQ_SIN_HAS_IN 0
#define FREQ_SIN_HAS_OUT 1
#define FREQ_SIN_HAS_TRI 0
#define FREQ_SIN_IRQ_TYPE NONE
#define FREQ_SIN_RESET_VALUE 0

/*
 * Macros for device 'enable', class 'altera_avalon_pio'
 * The macros are prefixed with 'ENABLE_'.
 * The prefix is the slave descriptor.
 */
#define ENABLE_COMPONENT_TYPE altera_avalon_pio
#define ENABLE_COMPONENT_NAME enable
#define ENABLE_BASE 0x20
#define ENABLE_SPAN 16
#define ENABLE_END 0x2f
#define ENABLE_BIT_CLEARING_EDGE_REGISTER 0
#define ENABLE_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ENABLE_CAPTURE 0
#define ENABLE_DATA_WIDTH 1
#define ENABLE_DO_TEST_BENCH_WIRING 0
#define ENABLE_DRIVEN_SIM_VALUE 0
#define ENABLE_EDGE_TYPE NONE
#define ENABLE_FREQ 50000000
#define ENABLE_HAS_IN 0
#define ENABLE_HAS_OUT 1
#define ENABLE_HAS_TRI 0
#define ENABLE_IRQ_TYPE NONE
#define ENABLE_RESET_VALUE 0


#endif /* _ALTERA_HPS_0_H_ */
