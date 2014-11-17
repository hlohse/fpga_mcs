//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor:        Xilinx
// \   \   \/    Version:       1.0.0
//  \   \        Filename:      timing.v
//  /   /        Date Created:  December 25, 2006
// /___/   /\    Last Modified: December 25, 2006
// \   \  /  \
//  \___\/\___\
//
// Devices:   Spartan-3 Generation FPGA
// Purpose:   Programmable video timing generation circuit
// Contact:   crabill@xilinx.com
// Reference: None
//
// Revision History:
//   Rev 1.0.0 - (crabill) First created December 25, 2006.
//
//////////////////////////////////////////////////////////////////////////////
//
// LIMITED WARRANTY AND DISCLAIMER. These designs are provided to you "as is".
// Xilinx and its licensors make and you receive no warranties or conditions,
// express, implied, statutory or otherwise, and Xilinx specifically disclaims
// any implied warranties of merchantability, non-infringement, or fitness for
// a particular purpose. Xilinx does not warrant that the functions contained
// in these designs will meet your requirements, or that the operation of
// these designs will be uninterrupted or error free, or that defects in the
// designs will be corrected. Furthermore, Xilinx does not warrant or make any
// representations regarding use or the results of the use of the designs in
// terms of correctness, accuracy, reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its licensors be liable
// for any loss of data, lost profits, cost or procurement of substitute goods
// or services, or for any special, incidental, consequential, or indirect
// damages arising from the use or operation of the designs or accompanying
// documentation, however caused and on any theory of liability. This
// limitation will apply even if Xilinx has been advised of the possibility
// of such damage. This limitation shall apply not-withstanding the failure
// of the essential purpose of any limited remedies herein.
//
//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module timing
  (

  output wire [10:0] hcount,
  output reg        hsync,
//  output wire        hblnk,

  output wire [10:0] vcount,
  output reg        vsync,
//  output wire        vblnk,
  output reg        active,

  input  wire        rst,
  input  wire        clk
  );


  wire        hblnk;
  wire        vblnk;
  wire        hsync_i;
  wire        vsync_i;
  wire        active_i;

  //1024x768@60HZ
  /*
  parameter HPIXELS_XGA = 11'd1024; //Horizontal Live Pixels
  parameter VLINES_XGA  = 11'd768;  //Vertical Live ines
  parameter HSYNCPW_XGA = 11'd136;  //HSYNC Pulse Width
  parameter VSYNCPW_XGA = 11'd6;    //VSYNC Pulse Width
  parameter HFNPRCH_XGA = 11'd24;   //Horizontal Front Portch
  parameter VFNPRCH_XGA = 11'd3;    //Vertical Front Portch
  parameter HBKPRCH_XGA = 11'd160;  //Horizontal Back Portch
  parameter VBKPRCH_XGA = 11'd29;   //Vertical Back Portch
  */

  wire [10:0] tc_hsblnk;
  wire [10:0] tc_hssync;
  wire [10:0] tc_hesync;
  wire [10:0] tc_heblnk;
  wire [10:0] tc_vsblnk;
  wire [10:0] tc_vssync;
  wire [10:0] tc_vesync;
  wire [10:0] tc_veblnk;


  wire hvsync_polarity; //1-Negative, 0-Positive

  assign hvsync_polarity = 1'b1;

  assign tc_hsblnk = 11'd1024 - 11'd1;
  assign tc_hssync = 11'd1024 - 11'd1 + 11'd24;
  assign tc_hesync = 11'd1024 - 11'd1 + 11'd24 + 11'd136;
  assign tc_heblnk = 11'd1024 - 11'd1 + 11'd24 + 11'd136 + 11'd160;
  assign tc_vsblnk =  11'd768 - 11'd1;
  assign tc_vssync =  11'd768 - 11'd1 + 11'd3;
  assign tc_vesync =  11'd768 - 11'd1 + 11'd3 + 11'd6;
  assign tc_veblnk =  11'd768 - 11'd1 + 11'd3 + 11'd6 + 11'd29;

  //******************************************************************//
  // This logic describes a 11-bit horizontal position counter.       //
  //******************************************************************//
 
  reg    [10:0] hpos_cnt = 0;
  wire          hpos_clr;
  wire          hpos_ena;

  always @(posedge clk)
  begin : hcounter
    if (hpos_clr) hpos_cnt <= 11'b000_0000_0000;
    else if (hpos_ena) hpos_cnt <= hpos_cnt + 11'b000_0000_0001;
  end

  //******************************************************************//
  // This logic describes a 11-bit vertical position counter.         //
  //******************************************************************//

  reg    [10:0] vpos_cnt = 0;
  wire          vpos_clr;
  wire          vpos_ena;

  always @(posedge clk)
  begin : vcounter
    if (vpos_clr) vpos_cnt <= 11'b000_0000_0000;
    else if (vpos_ena) vpos_cnt <= vpos_cnt + 11'b000_0000_0001;
  end

  //******************************************************************//
  // This logic describes the position counter control.  Counters are //
  // reset when they reach the total count and the counter is then    //
  // enabled to advance.  Use of GTE operator ensures dynamic changes //
  // to display timing parameters do not allow counters to run away.  //
  //******************************************************************//

  assign hpos_ena = 1'b1;
  assign hpos_clr = ((hpos_cnt >= tc_heblnk) && hpos_ena ) || rst;
 
  assign vpos_ena = hpos_clr;
  assign vpos_clr = ((vpos_cnt >= tc_veblnk) && vpos_ena ) || rst;

  //******************************************************************//
  // This is the logic for the horizontal outputs.  Active video is   //
  // always started when the horizontal count is zero.  Example:      //
  //                                                                  //
  // tc_hsblnk = 03                                                   //
  // tc_hssync = 07                                                   //
  // tc_hesync = 11                                                   //
  // tc_heblnk = 15 (htotal)                                          //
  //                                                                  //
  // hcount   00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15         //
  // hsync    ________________________------------____________        //
  // hblnk    ____________------------------------------------        //
  //                                                                  //
  // hsync time  = (tc_hesync - tc_hssync) pixels                     //
  // hblnk time  = (tc_heblnk - tc_hsblnk) pixels                     //
  // active time = (tc_hsblnk + 1) pixels                             //
  //                                                                  //
  //******************************************************************//

  assign hcount = hpos_cnt;
  assign hblnk = (hcount > tc_hsblnk);
  assign hsync_i = (hcount > tc_hssync) && (hcount <= tc_hesync);

  //******************************************************************//
  // This is the logic for the vertical outputs.  Active video is     //
  // always started when the vertical count is zero.  Example:        //
  //                                                                  //
  // tc_vsblnk = 03                                                   //
  // tc_vssync = 07                                                   //
  // tc_vesync = 11                                                   //
  // tc_veblnk = 15 (vtotal)                                          //
  //                                                                  //
  // vcount   00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15         //
  // vsync    ________________________------------____________        //
  // vblnk    ____________------------------------------------        //
  //                                                                  //
  // vsync time  = (tc_vesync - tc_vssync) lines                      //
  // vblnk time  = (tc_veblnk - tc_vsblnk) lines                      //
  // active time = (tc_vsblnk + 1) lines                              //
  //                                                                  //
  //******************************************************************//
 
  assign vcount = vpos_cnt;
  assign vblnk = (vcount > tc_vsblnk);
  assign vsync_i = (vcount > tc_vssync) && (vcount <= tc_vesync);

  //******************************************************************//
  //                                                                  //
  //******************************************************************//

  /////////////////////////////////////////
  // V/H SYNC and DE generator. copied from upper level
  /////////////////////////////////////////

  always @ (posedge clk)
  begin
    hsync <= hsync_i ^ hvsync_polarity ;
    vsync <= vsync_i ^ hvsync_polarity ;
    active <= !hblnk && !vblnk;
  end


endmodule