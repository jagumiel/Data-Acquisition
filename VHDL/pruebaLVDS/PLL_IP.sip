set_global_assignment -entity "PLL_IP" -library "lib_PLL_IP" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_IP" -library "lib_PLL_IP" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "PLL_IP" -library "lib_PLL_IP" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_IP" -name SPD_FILE [file join $::quartus(sip_path) "PLL_IP.spd"]

set_global_assignment -library "lib_PLL_IP" -name MISC_FILE [file join $::quartus(sip_path) "PLL_IP_sim/PLL_IP.vo"]
