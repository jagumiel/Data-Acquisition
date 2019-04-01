#!/bin/sh
export PATH=$PATH:/cygdrive/c/intelFPGA_lite/18.1/quartus/sopc_builder/bin/
sopc-create-header-files \
"./hps.sopcinfo" \
--single hps_0.h \
--module hps_0