// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ns / 1 ns

import verbosity_pkg::*;
import avalon_mm_pkg::*;
import mgc_axi_pkg::*;

module hps_hps_0_fpga_interfaces
(
   output wire [  0:  0] h2f_rst_n,
   input  wire [  0:  0] h2f_lw_axi_clk,
   output wire [ 11:  0] h2f_lw_AWID,
   output wire [ 20:  0] h2f_lw_AWADDR,
   output wire [  3:  0] h2f_lw_AWLEN,
   output wire [  2:  0] h2f_lw_AWSIZE,
   output wire [  1:  0] h2f_lw_AWBURST,
   output wire [  1:  0] h2f_lw_AWLOCK,
   output wire [  3:  0] h2f_lw_AWCACHE,
   output wire [  2:  0] h2f_lw_AWPROT,
   output wire [  0:  0] h2f_lw_AWVALID,
   input  wire [  0:  0] h2f_lw_AWREADY,
   output wire [ 11:  0] h2f_lw_WID,
   output wire [ 31:  0] h2f_lw_WDATA,
   output wire [  3:  0] h2f_lw_WSTRB,
   output wire [  0:  0] h2f_lw_WLAST,
   output wire [  0:  0] h2f_lw_WVALID,
   input  wire [  0:  0] h2f_lw_WREADY,
   input  wire [ 11:  0] h2f_lw_BID,
   input  wire [  1:  0] h2f_lw_BRESP,
   input  wire [  0:  0] h2f_lw_BVALID,
   output wire [  0:  0] h2f_lw_BREADY,
   output wire [ 11:  0] h2f_lw_ARID,
   output wire [ 20:  0] h2f_lw_ARADDR,
   output wire [  3:  0] h2f_lw_ARLEN,
   output wire [  2:  0] h2f_lw_ARSIZE,
   output wire [  1:  0] h2f_lw_ARBURST,
   output wire [  1:  0] h2f_lw_ARLOCK,
   output wire [  3:  0] h2f_lw_ARCACHE,
   output wire [  2:  0] h2f_lw_ARPROT,
   output wire [  0:  0] h2f_lw_ARVALID,
   input  wire [  0:  0] h2f_lw_ARREADY,
   input  wire [ 11:  0] h2f_lw_RID,
   input  wire [ 31:  0] h2f_lw_RDATA,
   input  wire [  1:  0] h2f_lw_RRESP,
   input  wire [  0:  0] h2f_lw_RLAST,
   input  wire [  0:  0] h2f_lw_RVALID,
   output wire [  0:  0] h2f_lw_RREADY
);




   altera_avalon_reset_source #(
      .ASSERT_HIGH_RESET(0),
      .INITIAL_RESET_CYCLES(1)
   ) h2f_reset_inst (
      .reset(h2f_rst_n),
      .clk('0)
   );

   mgc_axi_master #(
      .AXI_ID_WIDTH(12),
      .AXI_ADDRESS_WIDTH(21),
      .AXI_WDATA_WIDTH(32),
      .AXI_RDATA_WIDTH(32),
      .index(2)
   ) h2f_lw_axi_master_inst (
      .ARSIZE(h2f_lw_ARSIZE),
      .AWUSER(),
      .WVALID(h2f_lw_WVALID),
      .RLAST(h2f_lw_RLAST),
      .ACLK(h2f_lw_axi_clk),
      .RRESP(h2f_lw_RRESP),
      .ARREADY(h2f_lw_ARREADY),
      .ARPROT(h2f_lw_ARPROT),
      .ARADDR(h2f_lw_ARADDR),
      .BVALID(h2f_lw_BVALID),
      .ARID(h2f_lw_ARID),
      .BID(h2f_lw_BID),
      .ARBURST(h2f_lw_ARBURST),
      .ARCACHE(h2f_lw_ARCACHE),
      .AWVALID(h2f_lw_AWVALID),
      .WDATA(h2f_lw_WDATA),
      .ARUSER(),
      .RID(h2f_lw_RID),
      .RVALID(h2f_lw_RVALID),
      .WREADY(h2f_lw_WREADY),
      .AWLOCK(h2f_lw_AWLOCK),
      .BRESP(h2f_lw_BRESP),
      .ARLEN(h2f_lw_ARLEN),
      .AWSIZE(h2f_lw_AWSIZE),
      .AWLEN(h2f_lw_AWLEN),
      .BREADY(h2f_lw_BREADY),
      .AWID(h2f_lw_AWID),
      .RDATA(h2f_lw_RDATA),
      .AWREADY(h2f_lw_AWREADY),
      .ARVALID(h2f_lw_ARVALID),
      .WLAST(h2f_lw_WLAST),
      .ARESETn(h2f_rst_n),
      .AWPROT(h2f_lw_AWPROT),
      .WID(h2f_lw_WID),
      .AWADDR(h2f_lw_AWADDR),
      .AWCACHE(h2f_lw_AWCACHE),
      .ARLOCK(h2f_lw_ARLOCK),
      .AWBURST(h2f_lw_AWBURST),
      .RREADY(h2f_lw_RREADY),
      .WSTRB(h2f_lw_WSTRB)
   );

endmodule 

