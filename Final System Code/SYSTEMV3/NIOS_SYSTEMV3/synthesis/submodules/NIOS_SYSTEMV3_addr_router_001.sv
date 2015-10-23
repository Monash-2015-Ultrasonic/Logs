// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0sp1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module NIOS_SYSTEMV3_addr_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 2,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 97 
   )
  (output [92 - 86 : 0] default_destination_id,
   output [99-1 : 0] default_wr_channel,
   output [99-1 : 0] default_rd_channel,
   output [99-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[92 - 86 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 99'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 99'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 99'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module NIOS_SYSTEMV3_addr_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [103-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [103-1    : 0] src_data,
    output reg [99-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 57;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 92;
    localparam PKT_DEST_ID_L = 86;
    localparam PKT_PROTECTION_H = 96;
    localparam PKT_PROTECTION_L = 94;
    localparam ST_DATA_W = 103;
    localparam ST_CHANNEL_W = 99;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 60;
    localparam PKT_TRANS_READ  = 61;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h200000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h202000 - 64'h200000); 
    localparam PAD2 = log2ceil(64'h203000 - 64'h202800); 
    localparam PAD3 = log2ceil(64'h203010 - 64'h203000); 
    localparam PAD4 = log2ceil(64'h203020 - 64'h203010); 
    localparam PAD5 = log2ceil(64'h203030 - 64'h203020); 
    localparam PAD6 = log2ceil(64'h203040 - 64'h203030); 
    localparam PAD7 = log2ceil(64'h203050 - 64'h203040); 
    localparam PAD8 = log2ceil(64'h203060 - 64'h203050); 
    localparam PAD9 = log2ceil(64'h203070 - 64'h203060); 
    localparam PAD10 = log2ceil(64'h203080 - 64'h203070); 
    localparam PAD11 = log2ceil(64'h203090 - 64'h203080); 
    localparam PAD12 = log2ceil(64'h2030a0 - 64'h203090); 
    localparam PAD13 = log2ceil(64'h2030b0 - 64'h2030a0); 
    localparam PAD14 = log2ceil(64'h2030c0 - 64'h2030b0); 
    localparam PAD15 = log2ceil(64'h2030d0 - 64'h2030c0); 
    localparam PAD16 = log2ceil(64'h2030e0 - 64'h2030d0); 
    localparam PAD17 = log2ceil(64'h2030f0 - 64'h2030e0); 
    localparam PAD18 = log2ceil(64'h203100 - 64'h2030f0); 
    localparam PAD19 = log2ceil(64'h203110 - 64'h203100); 
    localparam PAD20 = log2ceil(64'h203120 - 64'h203110); 
    localparam PAD21 = log2ceil(64'h203130 - 64'h203120); 
    localparam PAD22 = log2ceil(64'h203140 - 64'h203130); 
    localparam PAD23 = log2ceil(64'h203150 - 64'h203140); 
    localparam PAD24 = log2ceil(64'h203160 - 64'h203150); 
    localparam PAD25 = log2ceil(64'h203170 - 64'h203160); 
    localparam PAD26 = log2ceil(64'h203180 - 64'h203170); 
    localparam PAD27 = log2ceil(64'h203190 - 64'h203180); 
    localparam PAD28 = log2ceil(64'h2031a0 - 64'h203190); 
    localparam PAD29 = log2ceil(64'h2031b0 - 64'h2031a0); 
    localparam PAD30 = log2ceil(64'h2031c0 - 64'h2031b0); 
    localparam PAD31 = log2ceil(64'h2031d0 - 64'h2031c0); 
    localparam PAD32 = log2ceil(64'h2031e0 - 64'h2031d0); 
    localparam PAD33 = log2ceil(64'h2031f0 - 64'h2031e0); 
    localparam PAD34 = log2ceil(64'h203200 - 64'h2031f0); 
    localparam PAD35 = log2ceil(64'h203210 - 64'h203200); 
    localparam PAD36 = log2ceil(64'h203220 - 64'h203210); 
    localparam PAD37 = log2ceil(64'h203230 - 64'h203220); 
    localparam PAD38 = log2ceil(64'h203240 - 64'h203230); 
    localparam PAD39 = log2ceil(64'h203250 - 64'h203240); 
    localparam PAD40 = log2ceil(64'h203260 - 64'h203250); 
    localparam PAD41 = log2ceil(64'h203270 - 64'h203260); 
    localparam PAD42 = log2ceil(64'h203280 - 64'h203270); 
    localparam PAD43 = log2ceil(64'h203290 - 64'h203280); 
    localparam PAD44 = log2ceil(64'h2032a0 - 64'h203290); 
    localparam PAD45 = log2ceil(64'h2032b0 - 64'h2032a0); 
    localparam PAD46 = log2ceil(64'h2032c0 - 64'h2032b0); 
    localparam PAD47 = log2ceil(64'h2032d0 - 64'h2032c0); 
    localparam PAD48 = log2ceil(64'h2032e0 - 64'h2032d0); 
    localparam PAD49 = log2ceil(64'h2032f0 - 64'h2032e0); 
    localparam PAD50 = log2ceil(64'h203300 - 64'h2032f0); 
    localparam PAD51 = log2ceil(64'h203310 - 64'h203300); 
    localparam PAD52 = log2ceil(64'h203320 - 64'h203310); 
    localparam PAD53 = log2ceil(64'h203330 - 64'h203320); 
    localparam PAD54 = log2ceil(64'h203340 - 64'h203330); 
    localparam PAD55 = log2ceil(64'h203350 - 64'h203340); 
    localparam PAD56 = log2ceil(64'h203360 - 64'h203350); 
    localparam PAD57 = log2ceil(64'h203370 - 64'h203360); 
    localparam PAD58 = log2ceil(64'h203380 - 64'h203370); 
    localparam PAD59 = log2ceil(64'h203390 - 64'h203380); 
    localparam PAD60 = log2ceil(64'h2033a0 - 64'h203390); 
    localparam PAD61 = log2ceil(64'h2033b0 - 64'h2033a0); 
    localparam PAD62 = log2ceil(64'h2033c0 - 64'h2033b0); 
    localparam PAD63 = log2ceil(64'h2033d0 - 64'h2033c0); 
    localparam PAD64 = log2ceil(64'h2033e0 - 64'h2033d0); 
    localparam PAD65 = log2ceil(64'h2033f0 - 64'h2033e0); 
    localparam PAD66 = log2ceil(64'h203400 - 64'h2033f0); 
    localparam PAD67 = log2ceil(64'h203410 - 64'h203400); 
    localparam PAD68 = log2ceil(64'h203420 - 64'h203410); 
    localparam PAD69 = log2ceil(64'h203430 - 64'h203420); 
    localparam PAD70 = log2ceil(64'h203440 - 64'h203430); 
    localparam PAD71 = log2ceil(64'h203450 - 64'h203440); 
    localparam PAD72 = log2ceil(64'h203460 - 64'h203450); 
    localparam PAD73 = log2ceil(64'h203470 - 64'h203460); 
    localparam PAD74 = log2ceil(64'h203480 - 64'h203470); 
    localparam PAD75 = log2ceil(64'h203490 - 64'h203480); 
    localparam PAD76 = log2ceil(64'h2034a0 - 64'h203490); 
    localparam PAD77 = log2ceil(64'h2034b0 - 64'h2034a0); 
    localparam PAD78 = log2ceil(64'h2034c0 - 64'h2034b0); 
    localparam PAD79 = log2ceil(64'h2034d0 - 64'h2034c0); 
    localparam PAD80 = log2ceil(64'h2034e0 - 64'h2034d0); 
    localparam PAD81 = log2ceil(64'h2034f0 - 64'h2034e0); 
    localparam PAD82 = log2ceil(64'h203500 - 64'h2034f0); 
    localparam PAD83 = log2ceil(64'h203510 - 64'h203500); 
    localparam PAD84 = log2ceil(64'h203520 - 64'h203510); 
    localparam PAD85 = log2ceil(64'h203530 - 64'h203520); 
    localparam PAD86 = log2ceil(64'h203540 - 64'h203530); 
    localparam PAD87 = log2ceil(64'h203550 - 64'h203540); 
    localparam PAD88 = log2ceil(64'h203560 - 64'h203550); 
    localparam PAD89 = log2ceil(64'h203570 - 64'h203560); 
    localparam PAD90 = log2ceil(64'h203580 - 64'h203570); 
    localparam PAD91 = log2ceil(64'h203590 - 64'h203580); 
    localparam PAD92 = log2ceil(64'h2035a0 - 64'h203590); 
    localparam PAD93 = log2ceil(64'h2035b0 - 64'h2035a0); 
    localparam PAD94 = log2ceil(64'h2035c0 - 64'h2035b0); 
    localparam PAD95 = log2ceil(64'h2035d0 - 64'h2035c0); 
    localparam PAD96 = log2ceil(64'h2035e0 - 64'h2035d0); 
    localparam PAD97 = log2ceil(64'h2035f0 - 64'h2035e0); 
    localparam PAD98 = log2ceil(64'h2035f8 - 64'h2035f0); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h2035f8;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [99-1 : 0] default_src_channel;





    NIOS_SYSTEMV3_addr_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x200000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 22'h0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 97;
    end

    // ( 0x200000 .. 0x202000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 22'h200000   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 96;
    end

    // ( 0x202800 .. 0x203000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 22'h202800   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 95;
    end

    // ( 0x203000 .. 0x203010 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 22'h203000   ) begin
            src_channel = 99'b100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 82;
    end

    // ( 0x203010 .. 0x203020 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 22'h203010   ) begin
            src_channel = 99'b010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 83;
    end

    // ( 0x203020 .. 0x203030 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 22'h203020   ) begin
            src_channel = 99'b001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 84;
    end

    // ( 0x203030 .. 0x203040 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 22'h203030   ) begin
            src_channel = 99'b000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 85;
    end

    // ( 0x203040 .. 0x203050 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 22'h203040   ) begin
            src_channel = 99'b000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 78;
    end

    // ( 0x203050 .. 0x203060 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 22'h203050   ) begin
            src_channel = 99'b000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 79;
    end

    // ( 0x203060 .. 0x203070 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 22'h203060   ) begin
            src_channel = 99'b000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 80;
    end

    // ( 0x203070 .. 0x203080 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 22'h203070   ) begin
            src_channel = 99'b000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 81;
    end

    // ( 0x203080 .. 0x203090 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 22'h203080   ) begin
            src_channel = 99'b000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 74;
    end

    // ( 0x203090 .. 0x2030a0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 22'h203090   ) begin
            src_channel = 99'b000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 75;
    end

    // ( 0x2030a0 .. 0x2030b0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 22'h2030a0   ) begin
            src_channel = 99'b000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 76;
    end

    // ( 0x2030b0 .. 0x2030c0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 22'h2030b0   ) begin
            src_channel = 99'b000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 77;
    end

    // ( 0x2030c0 .. 0x2030d0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 22'h2030c0   ) begin
            src_channel = 99'b000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 73;
    end

    // ( 0x2030d0 .. 0x2030e0 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 22'h2030d0   ) begin
            src_channel = 99'b000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 69;
    end

    // ( 0x2030e0 .. 0x2030f0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 22'h2030e0   ) begin
            src_channel = 99'b000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 70;
    end

    // ( 0x2030f0 .. 0x203100 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 22'h2030f0   ) begin
            src_channel = 99'b000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 71;
    end

    // ( 0x203100 .. 0x203110 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 22'h203100   ) begin
            src_channel = 99'b000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 72;
    end

    // ( 0x203110 .. 0x203120 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 22'h203110   ) begin
            src_channel = 99'b000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 58;
    end

    // ( 0x203120 .. 0x203130 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 22'h203120   ) begin
            src_channel = 99'b000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 59;
    end

    // ( 0x203130 .. 0x203140 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 22'h203130   ) begin
            src_channel = 99'b000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 57;
    end

    // ( 0x203140 .. 0x203150 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 22'h203140   ) begin
            src_channel = 99'b000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 64;
    end

    // ( 0x203150 .. 0x203160 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 22'h203150   ) begin
            src_channel = 99'b000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 63;
    end

    // ( 0x203160 .. 0x203170 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 22'h203160   ) begin
            src_channel = 99'b000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 62;
    end

    // ( 0x203170 .. 0x203180 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 22'h203170   ) begin
            src_channel = 99'b000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 61;
    end

    // ( 0x203180 .. 0x203190 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 22'h203180   ) begin
            src_channel = 99'b000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 68;
    end

    // ( 0x203190 .. 0x2031a0 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 22'h203190   ) begin
            src_channel = 99'b000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 67;
    end

    // ( 0x2031a0 .. 0x2031b0 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 22'h2031a0   ) begin
            src_channel = 99'b000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 66;
    end

    // ( 0x2031b0 .. 0x2031c0 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 22'h2031b0   ) begin
            src_channel = 99'b000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 65;
    end

    // ( 0x2031c0 .. 0x2031d0 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 22'h2031c0   ) begin
            src_channel = 99'b000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 56;
    end

    // ( 0x2031d0 .. 0x2031e0 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 22'h2031d0   ) begin
            src_channel = 99'b000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 60;
    end

    // ( 0x2031e0 .. 0x2031f0 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 22'h2031e0   ) begin
            src_channel = 99'b000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 52;
    end

    // ( 0x2031f0 .. 0x203200 )
    if ( {address[RG:PAD34],{PAD34{1'b0}}} == 22'h2031f0   ) begin
            src_channel = 99'b000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 53;
    end

    // ( 0x203200 .. 0x203210 )
    if ( {address[RG:PAD35],{PAD35{1'b0}}} == 22'h203200   ) begin
            src_channel = 99'b000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 54;
    end

    // ( 0x203210 .. 0x203220 )
    if ( {address[RG:PAD36],{PAD36{1'b0}}} == 22'h203210   ) begin
            src_channel = 99'b000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 55;
    end

    // ( 0x203220 .. 0x203230 )
    if ( {address[RG:PAD37],{PAD37{1'b0}}} == 22'h203220   ) begin
            src_channel = 99'b000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 48;
    end

    // ( 0x203230 .. 0x203240 )
    if ( {address[RG:PAD38],{PAD38{1'b0}}} == 22'h203230   ) begin
            src_channel = 99'b000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 49;
    end

    // ( 0x203240 .. 0x203250 )
    if ( {address[RG:PAD39],{PAD39{1'b0}}} == 22'h203240   ) begin
            src_channel = 99'b000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 50;
    end

    // ( 0x203250 .. 0x203260 )
    if ( {address[RG:PAD40],{PAD40{1'b0}}} == 22'h203250   ) begin
            src_channel = 99'b000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 51;
    end

    // ( 0x203260 .. 0x203270 )
    if ( {address[RG:PAD41],{PAD41{1'b0}}} == 22'h203260   ) begin
            src_channel = 99'b000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 44;
    end

    // ( 0x203270 .. 0x203280 )
    if ( {address[RG:PAD42],{PAD42{1'b0}}} == 22'h203270   ) begin
            src_channel = 99'b000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 45;
    end

    // ( 0x203280 .. 0x203290 )
    if ( {address[RG:PAD43],{PAD43{1'b0}}} == 22'h203280   ) begin
            src_channel = 99'b000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 46;
    end

    // ( 0x203290 .. 0x2032a0 )
    if ( {address[RG:PAD44],{PAD44{1'b0}}} == 22'h203290   ) begin
            src_channel = 99'b000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 47;
    end

    // ( 0x2032a0 .. 0x2032b0 )
    if ( {address[RG:PAD45],{PAD45{1'b0}}} == 22'h2032a0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
    end

    // ( 0x2032b0 .. 0x2032c0 )
    if ( {address[RG:PAD46],{PAD46{1'b0}}} == 22'h2032b0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 41;
    end

    // ( 0x2032c0 .. 0x2032d0 )
    if ( {address[RG:PAD47],{PAD47{1'b0}}} == 22'h2032c0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 42;
    end

    // ( 0x2032d0 .. 0x2032e0 )
    if ( {address[RG:PAD48],{PAD48{1'b0}}} == 22'h2032d0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 43;
    end

    // ( 0x2032e0 .. 0x2032f0 )
    if ( {address[RG:PAD49],{PAD49{1'b0}}} == 22'h2032e0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
    end

    // ( 0x2032f0 .. 0x203300 )
    if ( {address[RG:PAD50],{PAD50{1'b0}}} == 22'h2032f0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
    end

    // ( 0x203300 .. 0x203310 )
    if ( {address[RG:PAD51],{PAD51{1'b0}}} == 22'h203300   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
    end

    // ( 0x203310 .. 0x203320 )
    if ( {address[RG:PAD52],{PAD52{1'b0}}} == 22'h203310   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
    end

    // ( 0x203320 .. 0x203330 )
    if ( {address[RG:PAD53],{PAD53{1'b0}}} == 22'h203320   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
    end

    // ( 0x203330 .. 0x203340 )
    if ( {address[RG:PAD54],{PAD54{1'b0}}} == 22'h203330   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x203340 .. 0x203350 )
    if ( {address[RG:PAD55],{PAD55{1'b0}}} == 22'h203340   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x203350 .. 0x203360 )
    if ( {address[RG:PAD56],{PAD56{1'b0}}} == 22'h203350   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x203360 .. 0x203370 )
    if ( {address[RG:PAD57],{PAD57{1'b0}}} == 22'h203360   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
    end

    // ( 0x203370 .. 0x203380 )
    if ( {address[RG:PAD58],{PAD58{1'b0}}} == 22'h203370   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x203380 .. 0x203390 )
    if ( {address[RG:PAD59],{PAD59{1'b0}}} == 22'h203380   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x203390 .. 0x2033a0 )
    if ( {address[RG:PAD60],{PAD60{1'b0}}} == 22'h203390   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x2033a0 .. 0x2033b0 )
    if ( {address[RG:PAD61],{PAD61{1'b0}}} == 22'h2033a0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x2033b0 .. 0x2033c0 )
    if ( {address[RG:PAD62],{PAD62{1'b0}}} == 22'h2033b0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x2033c0 .. 0x2033d0 )
    if ( {address[RG:PAD63],{PAD63{1'b0}}} == 22'h2033c0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x2033d0 .. 0x2033e0 )
    if ( {address[RG:PAD64],{PAD64{1'b0}}} == 22'h2033d0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x2033e0 .. 0x2033f0 )
    if ( {address[RG:PAD65],{PAD65{1'b0}}} == 22'h2033e0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x2033f0 .. 0x203400 )
    if ( {address[RG:PAD66],{PAD66{1'b0}}} == 22'h2033f0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x203400 .. 0x203410 )
    if ( {address[RG:PAD67],{PAD67{1'b0}}} == 22'h203400   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x203410 .. 0x203420 )
    if ( {address[RG:PAD68],{PAD68{1'b0}}} == 22'h203410   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x203420 .. 0x203430 )
    if ( {address[RG:PAD69],{PAD69{1'b0}}} == 22'h203420   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x203430 .. 0x203440 )
    if ( {address[RG:PAD70],{PAD70{1'b0}}} == 22'h203430   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x203440 .. 0x203450 )
    if ( {address[RG:PAD71],{PAD71{1'b0}}} == 22'h203440   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x203450 .. 0x203460 )
    if ( {address[RG:PAD72],{PAD72{1'b0}}} == 22'h203450   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x203460 .. 0x203470 )
    if ( {address[RG:PAD73],{PAD73{1'b0}}} == 22'h203460   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x203470 .. 0x203480 )
    if ( {address[RG:PAD74],{PAD74{1'b0}}} == 22'h203470   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x203480 .. 0x203490 )
    if ( {address[RG:PAD75],{PAD75{1'b0}}} == 22'h203480   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x203490 .. 0x2034a0 )
    if ( {address[RG:PAD76],{PAD76{1'b0}}} == 22'h203490   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x2034a0 .. 0x2034b0 )
    if ( {address[RG:PAD77],{PAD77{1'b0}}} == 22'h2034a0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x2034b0 .. 0x2034c0 )
    if ( {address[RG:PAD78],{PAD78{1'b0}}} == 22'h2034b0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x2034c0 .. 0x2034d0 )
    if ( {address[RG:PAD79],{PAD79{1'b0}}} == 22'h2034c0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x2034d0 .. 0x2034e0 )
    if ( {address[RG:PAD80],{PAD80{1'b0}}} == 22'h2034d0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x2034e0 .. 0x2034f0 )
    if ( {address[RG:PAD81],{PAD81{1'b0}}} == 22'h2034e0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x2034f0 .. 0x203500 )
    if ( {address[RG:PAD82],{PAD82{1'b0}}} == 22'h2034f0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x203500 .. 0x203510 )
    if ( {address[RG:PAD83],{PAD83{1'b0}}} == 22'h203500   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x203510 .. 0x203520 )
    if ( {address[RG:PAD84],{PAD84{1'b0}}} == 22'h203510   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x203520 .. 0x203530 )
    if ( {address[RG:PAD85],{PAD85{1'b0}}} == 22'h203520   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x203530 .. 0x203540 )
    if ( {address[RG:PAD86],{PAD86{1'b0}}} == 22'h203530   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x203540 .. 0x203550 )
    if ( {address[RG:PAD87],{PAD87{1'b0}}} == 22'h203540   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 94;
    end

    // ( 0x203550 .. 0x203560 )
    if ( {address[RG:PAD88],{PAD88{1'b0}}} == 22'h203550   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 93;
    end

    // ( 0x203560 .. 0x203570 )
    if ( {address[RG:PAD89],{PAD89{1'b0}}} == 22'h203560   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 92;
    end

    // ( 0x203570 .. 0x203580 )
    if ( {address[RG:PAD90],{PAD90{1'b0}}} == 22'h203570   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 86;
    end

    // ( 0x203580 .. 0x203590 )
    if ( {address[RG:PAD91],{PAD91{1'b0}}} == 22'h203580   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x203590 .. 0x2035a0 )
    if ( {address[RG:PAD92],{PAD92{1'b0}}} == 22'h203590   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 98;
    end

    // ( 0x2035a0 .. 0x2035b0 )
    if ( {address[RG:PAD93],{PAD93{1'b0}}} == 22'h2035a0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 89;
    end

    // ( 0x2035b0 .. 0x2035c0 )
    if ( {address[RG:PAD94],{PAD94{1'b0}}} == 22'h2035b0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 87;
    end

    // ( 0x2035c0 .. 0x2035d0 )
    if ( {address[RG:PAD95],{PAD95{1'b0}}} == 22'h2035c0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 88;
    end

    // ( 0x2035d0 .. 0x2035e0 )
    if ( {address[RG:PAD96],{PAD96{1'b0}}} == 22'h2035d0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x2035e0 .. 0x2035f0 )
    if ( {address[RG:PAD97],{PAD97{1'b0}}} == 22'h2035e0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 91;
    end

    // ( 0x2035f0 .. 0x2035f8 )
    if ( {address[RG:PAD98],{PAD98{1'b0}}} == 22'h2035f0   ) begin
            src_channel = 99'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 90;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


